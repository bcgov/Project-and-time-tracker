import * as Koa from 'koa';
import * as Router from 'koa-router';
import { Role } from '../../roles';
import { IAuth } from '../../../models/interfaces/i-auth';
import { authorize } from '../../../services/common/authorize.service';
import databaseConnection from '../../../../app/database/database.connection';

const PgCursor = require('pg-cursor');
const { stringify } = require('csv-stringify'); // ✅ use the streaming API


/**
 * Generates a clean, sanitized filename for the Timesheet CSV
 */
const buildTimesheetFilename = (
  startDate?: string, 
  endDate?: string, 
  names?: string[]
): string => {
  const start = startDate ? startDate.slice(0, 10) : 'ALL-DATES';
  const end = endDate ? endDate.slice(0, 10) : 'ALL-DATES';

  // Determine User Context
  let userLabel = '_ALL-USERS';
  if (names && names.length === 1) {
    userLabel = `_${names[0].substring(0, 12)}`;
  } else if (names && names.length > 1) {
    userLabel = `_${names.length}-USERS`;
  }

  // Handle date range logic
  const dateRange = (start === 'ALL-DATES' && end === 'ALL-DATES') 
    ? 'ALL-DATES' 
    : `${start}_to_${end}`;

  const rawName = `Timesheets_${dateRange}${userLabel}.csv`;

  // Sanitize: Replace non-alphanumeric (except ._-) with hyphens and trim length
  return rawName.replace(/[^a-zA-Z0-9._-]/g, '-').slice(0, 180);
};

export const timesheetReportCsv = async (ctx: Koa.Context) => {
  const auth = ctx.state.auth as IAuth;
  const allowedRoles = [Role.PSB_Admin, Role.PSB_User];
  if (!auth?.role?.some(r => allowedRoles.includes(r))) {
    ctx.status = 403;
    ctx.body = { message: 'Forbidden' };
    return;
  }

  console.log("API: timesheetReport CSV");

  // ---- parse filters
  const { startDate, endDate, userIds, userNames, projectIds } = ctx.query as Record<string, string | undefined>;
  const toUuidArray = (s?: string) => (s ? s.split(',').map(x => x.trim()).filter(Boolean) : undefined);
  const userIdArr = toUuidArray(userIds);
  const userNameArr = toUuidArray(userNames);
  const projectIdArr = toUuidArray(projectIds);

  const where: string[] = [
    `(te."hoursBillable" != 0 OR te."hoursUnBillable" != 0 OR te."expenseAmount" != 0)`
  ];
  const params: any[] = [];
  let i = 1;
  if (startDate) { where.push(`te."entryDate" >= $${i++}`); params.push(startDate); }
  if (endDate)   { where.push(`te."entryDate" <= $${i++}`); params.push(endDate); }
  if (userIdArr?.length)    { where.push(`u."id" = ANY($${i++}::uuid[])`); params.push(userIdArr); }
  if (projectIdArr?.length) { where.push(`p."id" = ANY($${i++}::uuid[])`); params.push(projectIdArr); }

  const sql = `
    SELECT
      c."fullName" AS "fullName",
      te."entryDate" AS "entryDate",
      te."hoursBillable" AS "hoursBillable",
      c."hourlyRate" AS "hourlyRate",
      te."commentsBillable" AS "commentsBillable",
      te."hoursUnBillable" AS "hoursUnBillable",
      te."commentsUnBillable" AS "commentsUnBillable",
      te."expenseCategory" AS "expenseCategory",
      te."expenseAmount" AS "expenseAmount",
      te."expenseComment" AS "expenseComment",
      CASE WHEN (p."categoryId" = 3 OR p."categoryId" IS NULL) THEN 'True' ELSE 'False' END AS "IsProjectBillable",
      mou."name" AS "Mou",
      p."projectName" AS "projectName",
      pr."rfxName" AS "rfxName"
    FROM "timesheet" t
    JOIN "timesheet_entry" te ON te."timesheetId" = t."id"
    LEFT JOIN "user" u        ON u."id" = t."userId"
    LEFT JOIN "contact" c     ON c."id" = u."contactId"
    JOIN "mou" mou            ON mou."id" = t."mouId"
    JOIN "project" p          ON p."id"  = t."projectId"
    JOIN "project_rfx" pr     ON pr."id" = t."projectRfxId"
    WHERE ${where.join(' AND ')}
    ORDER BY c."fullName", te."entryDate", p."projectName", pr."rfxName"
  `;

  
  // ---- Build filename based on dates & users ----
  const filename = buildTimesheetFilename(startDate, endDate, userNameArr);
  // Apply to response
  ctx.attachment(filename);
  ctx.type = 'text/csv; charset=utf-8';
  ctx.set('Access-Control-Expose-Headers', 'Content-Disposition');


  // We’ll take over the raw socket and pipe CSV into it
  ctx.respond = false;
  const res = ctx.res;

  res.on('finish', () => console.log('CSV stream finished'));
  res.on('close',  () => console.log('CSV stream closed'));
  res.on('error',  (e) => console.error('CSV stream error', e));

  // Optional BOM so Excel recognizes UTF-8 correctly:
  // res.write('\uFEFF');

  // Configure the CSV stringifier as a stream with headers
  const columns = [
    'Name','Entry Date','Billable Hours','Hourly Rate','Comments (Billable)',
    'Unbillable Hours','Comments (Unbillable)','Expense Category','Expense Amount',
    'Expense Comment','Is Project Billable','MOU','Project','RFX'
  ];
  const stringifier = stringify({
    header: true,
    columns,       // header row will be generated
    quoted: true,  // quote all fields to be safe with commas/newlines
  });

  // Pipe CSV directly to the HTTP response with backpressure management
  // (csv-stringify handles backpressure; piping is fine)
  stringifier.pipe(res);

  const fmtDate = (d: any) =>
    d instanceof Date ? d.toISOString().slice(0, 10) :
    (typeof d === 'string' && /^\d{4}-\d{2}-\d{2}/.test(d)) ? d.slice(0, 10) : d;

  const conn = await databaseConnection; // TypeORM Connection (0.2.x)
  const queryRunner = conn.createQueryRunner('master');
  await queryRunner.connect();

  const pgClient: any = (queryRunner as any).databaseConnection;
  if (!pgClient) {
    await queryRunner.release();
    res.statusCode = 500;
    res.end('Failed to access underlying pg client from QueryRunner.');
    return;
  }

  const fetchSize = 5000;
  const cursor = pgClient.query(new PgCursor(sql, params));

  try {
    console.log("API: timesheetReport CSV - start cursor read");
    while (true) {
      const rows: any[] = await new Promise((resolve, reject) =>
        cursor.read(fetchSize, (err: any, r: any[]) => (err ? reject(err) : resolve(r)))
      );
      if (!rows.length) break;

      for (const r of rows) {
        stringifier.write([
          r.fullName,
          fmtDate(r.entryDate),
          Number(r.hoursBillable || 0),
          Number(r.hourlyRate || 0),
          r.commentsBillable,
          Number(r.hoursUnBillable || 0),
          r.commentsUnBillable,
          r.expenseCategory,
          Number(r.expenseAmount || 0),
          r.expenseComment,
          r.IsProjectBillable,
          r.Mou,
          r.projectName,
          r.rfxName
        ]);
      }
      // Allow event loop to process I/O between batches
      await new Promise(r => setImmediate(r));
    }

    // End CSV stream; this will flush and then end the HTTP response
    stringifier.end();
  } catch (err) {
    console.error("CSV ERR:", err);
    try { stringifier.destroy(err as Error); } catch {}
  } finally {
    await new Promise<void>(r => cursor.close(() => r()));
    await queryRunner.release();
  }
};

const routerOpts: Router.IRouterOptions = { prefix: '/api/report' };
const router: Router = new (Router as any)(routerOpts);

router.get('/export.csv', authorize, timesheetReportCsv);

export default router;