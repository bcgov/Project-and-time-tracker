import { getRepository, Repository } from 'typeorm';
import { Timesheet } from './../../models/entities/timesheet.entity';
import { ITimesheet } from '../../models/interfaces/i-timesheet';
import { User, Contact } from '../../models/entities';

const timesheetRepo = (): Repository<Timesheet> => {
  return getRepository(Timesheet);
};

export const createTimesheet = async (obj: ITimesheet) => {
  const timesheet: Timesheet = timesheetRepo().create(obj);
  timesheet.dateCreated = new Date();
  timesheet.dateModified = new Date();
  await timesheetRepo().save(timesheet);
  return timesheet;
};

export const updateTimesheet = async (id: string, fields: any) => {
  const repo = timesheetRepo();
  const timesheet: Timesheet = await repo.findOne(id);

  if (!timesheet) {
    throw Error('timesheet not found');
  }
  const updatedTimesheet = await repo.merge(timesheet, fields);
  updatedTimesheet.dateModified = new Date();

  await repo.save(updatedTimesheet);
  return updatedTimesheet;
};

export const deleteTimesheet = async (id: string) => {
  const repo = timesheetRepo();

  const timesheet = await repo.findOne(id);

  if (!timesheet || timesheet.documentNo != null) {
    throw Error('timesheet not found');
  }
  return await repo.delete(timesheet);
};

export const retrieveTimesheetById = async (id: string) => {
  const repo = timesheetRepo();
  const res = await repo
    .createQueryBuilder('t')
    .innerJoinAndSelect('t.projectRfx', 'pr')
    .innerJoinAndSelect('t.project', 'p')
    .innerJoinAndSelect('t.mou', 'm')
    .innerJoinAndSelect('t.timesheetEntries', 'te')
    .where('t.id = :id', { id: id })
    .orderBy('te.entryDate', 'ASC')
    .getOne();
  if (!res) {
    throw Error(`timesheet not found for the id specified: ${id}`);
  }
  return res;
};


// types/paging.ts
export type PagingAndSort = {
  page?: number;             // 1-based
  pageSize?: number;         // cap on server, e.g., max 200
  sortBy?: 'fullName' | 'entryDate' | 'projectName' | 'rfxName';
  sortDir?: 'ASC' | 'DESC';
};


// types/timesheet-report.dto.ts
export type TimesheetRowDTO = {
  fullName: string;
  entryDate: string; // or Date if you prefer
  hoursBillable: number;
  hourlyRate: number | null;
  commentsBillable: string | null;
  hoursUnBillable: number;
  commentsUnBillable: string | null;
  expenseCategory: string | null;
  expenseAmount: number;
  expenseComment: string | null;
  IsProjectBillable: 'True' | 'False';
  Mou: string;
  projectName: string;
  rfxName: string;
};

// Optionally pass filters for date range, users, projects
export type TimesheetReportFilters = {
  startDate?: string | Date;
  endDate?: string | Date;
  userIds?: string[];
  projectIds?: string[];
};


type PagedResult<T> = {
  data: T[];
  total: number;
  page: number;
  pageSize: number;
};


type Paging = { page?: number; pageSize?: number };

export const retrieveAllHoursPaged = async (
  filters: TimesheetReportFilters = {},
  paging: Paging = {}
): Promise<{ data: TimesheetRowDTO[]; total: number }> => {
  const repo = getRepository(Timesheet);
  const page = Math.max(1, Number(paging.page || 1));
  const pageSize = Math.min(200, Math.max(1, Number(paging.pageSize || 100)));

  console.log("retrieveAllHoursPaged()")

  // ----- Base QB (filters but no selects yet)
  const baseQb = repo
    .createQueryBuilder('t')
    .innerJoin('t.timesheetEntries', 'te')
    .leftJoin('t.user', 'u')
    .leftJoin('u.contact', 'c')
    .innerJoin('t.mou', 'mou')
    .innerJoin('t.project', 'p')
    .innerJoin('t.projectRfx', 'pr')
    .where('(te.hoursBillable != 0 OR te.hoursUnBillable != 0 OR te.expenseAmount != 0)');

  // ---- Optional filters
  
if (filters.startDate) {
    baseQb.andWhere('te.entryDate >= :startDate', { startDate: filters.startDate });
  }
  if (filters.endDate) {
    baseQb.andWhere('te.entryDate <= :endDate', { endDate: filters.endDate });
  }
  if (filters.userIds && filters.userIds.length) {
    console.log(filters.userIds)
    baseQb.andWhere('u.id IN (:...userIds)', { userIds: filters.userIds });
  }
  if (filters.projectIds && filters.projectIds.length) {
    baseQb.andWhere('p.id IN (:...projectIds)', { projectIds: filters.projectIds });
  }


  // ---- COUNT(*) with same filters (no ORDER BY / LIMIT / OFFSET)
  const countQb = baseQb.clone().select('COUNT(*)', 'cnt').orderBy();
  const { cnt } = await countQb.getRawOne<{ cnt: string }>();
  const total = Number(cnt) || 0;

  // ---- DATA query: select columns + order + page
  const dataQb = baseQb
    .select([
      `c.fullName AS "fullName"`,
      `te.entryDate AS "entryDate"`,
      `te.hoursBillable AS "hoursBillable"`,
      `c.hourlyRate AS "hourlyRate"`,
      `te.commentsBillable AS "commentsBillable"`,
      `te.hoursUnBillable AS "hoursUnBillable"`,
      `te.commentsUnBillable AS "commentsUnBillable"`,
      `te.expenseCategory AS "expenseCategory"`,
      `te.expenseAmount AS "expenseAmount"`,
      `te.expenseComment AS "expenseComment"`,
      // If the business rule is project category, keep p.categoryId.
      // If it's entry category, switch to te.categoryId.
      `CASE WHEN (p.categoryId = 3 OR p.categoryId IS NULL)
            THEN 'True' ELSE 'False' END AS "IsProjectBillable"`,
      `mou.name AS "Mou"`,
      `p.projectName AS "projectName"`,
      `pr.rfxName AS "rfxName"`,
    ])
    .orderBy('c.fullName', 'ASC')
    .addOrderBy('te.entryDate', 'ASC')
    .addOrderBy('p.projectName', 'ASC')
    .addOrderBy('pr.rfxName', 'ASC')
    .limit(pageSize)
    .offset((page - 1) * pageSize);

  const data = await dataQb.getRawMany<TimesheetRowDTO>();
  return { data, total };
};


export const retrieveAllHours 
= async (filters: TimesheetReportFilters = {}): Promise<TimesheetRowDTO[]> => {
  const repo = getRepository(Timesheet);

  const qb = repo
    .createQueryBuilder('t')
    .innerJoin('t.timesheetEntries', 'te')
    .leftJoin('t.user', 'u')
    .leftJoin('u.contact', 'c')
    .innerJoin('t.mou', 'mou')
    .innerJoin('t.project', 'p')
    .innerJoin('t.projectRfx', 'pr')
    .select([
      `c.fullName AS "fullName"`,
      `te.entryDate AS "entryDate"`,
      `te.hoursBillable AS "hoursBillable"`,
      `c.hourlyRate AS "hourlyRate"`,
      `te.commentsBillable AS "commentsBillable"`,
      `te.hoursUnBillable AS "hoursUnBillable"`,
      `te.commentsUnBillable AS "commentsUnBillable"`,
      `te.expenseCategory AS "expenseCategory"`,
      `te.expenseAmount AS "expenseAmount"`,
      `te.expenseComment AS "expenseComment"`,
      `CASE WHEN (p.categoryId = 3 OR p.categoryId IS NULL) THEN 'True' ELSE 'False' END AS "IsProjectBillable"`,
      `mou.name AS "Mou"`,
      `p.projectName AS "projectName"`,
      `pr.rfxName AS "rfxName"`,
    ])
    // your WHERE: billable != 0 OR unbillable != 0 OR expenseAmount != 0
    .where(`(te.hoursBillable != 0 OR te.hoursUnBillable != 0 OR te.expenseAmount != 0)`);

  // --- Optional filters (date range, users, projects)
  if (filters.startDate) {
    qb.andWhere(`te.entryDate >= :startDate`, {
      startDate: filters.startDate instanceof Date ? filters.startDate.toISOString() : filters.startDate,
    });
  }
  if (filters.endDate) {
    qb.andWhere(`te.entryDate <= :endDate`, {
      endDate: filters.endDate instanceof Date ? filters.endDate.toISOString() : filters.endDate,
    });
  }
  if (filters.userIds && filters.userIds.length) {
    console.log(filters.userIds)
    qb.andWhere(`u.id IN (:...userIds)`, { userIds: filters.userIds });
  }
  if (filters.projectIds && filters.projectIds.length) {
    qb.andWhere(`p.id IN (:...projectIds)`, { projectIds: filters.projectIds });
  }

  // ORDER BY "fullName", "entryDate", "projectName", "rfxName"
  qb.orderBy(`c.fullName`, 'ASC')
    .addOrderBy(`te.entryDate`, 'ASC')
    .addOrderBy(`p.projectName`, 'ASC')
    .addOrderBy(`pr.rfxName`, 'ASC');

    
  // ⭐⭐⭐ LIMIT RESULTS TO ONE PAGE ⭐⭐⭐
  qb.limit(100);        // <-- only first 100 rows
  qb.offset(0);         // <-- first page


  // Flattened rows:
  return qb.getRawMany<TimesheetRowDTO>();
};


export const retrieveAllTimesheets = async () => {
  const repo = timesheetRepo();
  return await repo
    .createQueryBuilder('t')
    .innerJoinAndSelect('t.project', 'p')
    .leftJoinAndSelect('t.user', 'u')
    .leftJoinAndSelect('u.contact', 'c')
    .innerJoin('t.timesheetEntries', 'te')
    .innerJoin('t.projectRfx', 'pr')
    .orderBy('t.startDate', 'DESC')
    .getMany();
};
export const retrieveAllTimesheetsByWeek = async (startOfWeek) => {
  const repo = timesheetRepo();
  return await repo
    .createQueryBuilder('t')
    .innerJoinAndSelect('t.project', 'p')
    .leftJoinAndSelect('t.user', 'u')
    .leftJoinAndSelect('u.contact', 'c')
    .innerJoin('t.timesheetEntries', 'te')
    .innerJoin('t.projectRfx', 'pr')
    .orderBy('t.startDate', 'DESC')
    .where(' t."startDate" = :startOfWeek', {
      startOfWeek,
    })
    /*.where(' t."startDate" = :startOfWeek AND t."endDate" = :endOfWeek', {
      startOfWeek,
      endOfWeek,
    })*/
    .getMany();
};
export const retrieveMyTimesheets = async (userId) => {
  const repo = timesheetRepo();
  return await repo
    .createQueryBuilder('t')
    .innerJoin('t.projectRfx', 'pr')
    .innerJoinAndSelect('t.project', 'p')
    .leftJoinAndSelect('t.user', 'u')
    .leftJoinAndSelect('u.contact', 'c')
    .innerJoin('t.timesheetEntries', 'te')
    .orderBy('t.dateModified', 'DESC')
    .where('t.userId = :userId', {
      userId,
    })
    .getMany();
};
export const retrieveForLightTimesheet = async (model) => {
  const repo = timesheetRepo();
  const res = await repo
    .createQueryBuilder('t')
    .innerJoinAndSelect('t.timesheetEntries', 'te')
    .orderBy('te.entryDate', 'ASC')
    .where(
      // 't."mouId" = :mouId AND ' +
      't."projectId" = :projectId AND' +
        ' t."projectRfxId" = :projectRfxId AND' +
        ' t."userId" = :userId AND' +
        ' t."startDate" = :entryDate AND t."endDate" >= :entryDate',
      {
        // mouId: model.mou,
        projectId: model.project,
        projectRfxId: model.projectRfx,
        userId: model.userId,
        entryDate: model.startDate,
      }
    )
    .getOne();
  return res;
};
export const retrieveForLightTimesheetByUser = async (model) => {
  const repo = timesheetRepo();
  console.log('model', model);
  const res = await repo
    .createQueryBuilder('t')
    .innerJoinAndSelect('t.projectRfx', 'pr')
    .innerJoinAndSelect('t.timesheetEntries', 'te')
    .innerJoinAndSelect('t.project', 'p')
    .orderBy('te.entryDate', 'ASC')
    .where(
      ' t."userId" = :userId AND' +
      ' t."startDate" >= :startDate AND t."endDate" <= :endDate',
      {
      userId: model.userId,
      startDate: model.startDate,
      endDate: model.endDate,
    })
    .getMany();
  return res;
};
export const retrieveTimesheetByUserAndDate = async (model) => {
  const repo = timesheetRepo();
  const res = await repo
    .createQueryBuilder('t')
    .innerJoinAndSelect('t.timesheetEntries', 'te')
    .innerJoinAndSelect('t.project', 'p')
    .innerJoinAndSelect('t.mou', 'm')
    .innerJoinAndSelect('t.projectRfx', 'pr')
    .orderBy('te.entryDate, te.dateCreated', 'ASC')
    .where(
      ' t."userId" = :userId AND' +
        ' t."startDate" = :entryDate AND t."endDate" >= :entryDate',
      {
        userId: model.userId,
        entryDate: model.startDate,
      }
    )
    .getMany();
  return res;
};
export const retrieveForLightTimesheetPreview = async (
  projectId: string,
  projectRfxId: string,
  userId: string,
  entryDate: Date
) => {
  const repo = timesheetRepo();
  const res = await repo
    .createQueryBuilder('t')
    .innerJoinAndSelect('t.timesheetEntries', 'te')
    .where(
      't."projectId" = :projectId AND' +
        ' t."projectRfxId" = :projectRfxId AND' +
        ' t."rfxPhaseId" = :rfxPhaseId AND' +
        ' t."userId" = :userId AND' +
        ' t."startDate" <= :entryDate AND t."endDate" >= :entryDate',
      {
        projectId: projectId,
        projectRfxId: projectRfxId,
        userId: userId,
        entryDate: entryDate,
      }
    )
    .getMany();
  return res;
};

export const retrieveTimesheets = async (
  projectId?: string,
  startDate?: Date,
  endDate?: Date
) => {
  const repo = timesheetRepo();

  let ret = await repo
    .createQueryBuilder('t')
    .innerJoinAndSelect('t.projectRfx', 'pr')
    .innerJoinAndSelect('t.project', 'p')
    .innerJoinAndSelect('t.rfxPhase', 'rp')
    .innerJoinAndSelect('t.timesheetEntries', 'te')
    .orderBy('te.entryDate', 'ASC');
  // .where(
  //   't."projectId" = :projectId AND t."startDate" >= :startDate AND t."endDate" <= :endDate',
  //   { projectId: projectId, startDate: startDate, endDate: endDate }
  // )
  // .getMany();

  // Only use query params if provided, otherwise return all items
  if (projectId && startDate && endDate) {
    ret = ret.where(
      't."projectId" = :projectId AND t."startDate" >= :startDate AND t."endDate" <= :endDate',
      { projectId: projectId, startDate: startDate, endDate: endDate }
    );
  }

  return ret.getMany();
};
