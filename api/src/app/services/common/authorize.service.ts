import * as Koa from 'koa';
import * as HttpStatus from 'http-status-codes';
import { IAuth } from '../../models/interfaces/i-auth';

export const authorize = async (ctx: Koa.Context, next: () => Promise<any>) => {
  const auth = ctx.state.auth as IAuth;

  const path = `${ctx.method}${ctx._matchedRoute}`;
  // console.log(`authoring path ${path}`);
  // console.log(permissions);
  let permitted = false;
  for (let index = 0; index < auth.role.length; index++) {
    if (permissions[auth.role[index]].includes(path)) {
      permitted = true;
      break;
    }
  }
  if (!permitted) {
    ctx.status = HttpStatus.FORBIDDEN;
    ctx.throw("Don't have permission to perform this action.");
  } else {
    await next();
  }
};

/**
 * Check if the authentication context has some of the provided roles.
 * @param auth Current authentication context.
 * @param roles Roles to be verified.
 */
export const isInRoles = (auth: IAuth, roles: string[]): boolean => {
  const authRoles = auth.role.map(r => r.toLowerCase());
  const rolesToCompare = roles.map(r => r.toLowerCase());
  return authRoles.some(role => rolesToCompare.includes(role.toLowerCase())); 
}

const commonForAllUsers = [
  'GET/api/ministry/',
  'GET/api/ministry/:id',
  'GET/api/project-sector/',
  'GET/api/project-sector/:id',
  'GET/api/project-intake-category/',
  'GET/api/project-intake-category/:id',
  'GET/api/project-intake-service/',
  'GET/api/project-intake-service/:id',
  'GET/api/rfx-phase/',
  'GET/api/project-risk/',
  'GET/api/rfx-phase/:id',
  'GET/api/rfx-type/',
  'GET/api/rfx-type/:id',
  'GET/api/user/',
  'GET/api/MOU/',
  'GET/api/MOU/amounts',
  'POST/api/intake/',
];

const commonForPSBAdminAndUser = [
  'GET/api/contact/:id/by-project-id',
  'PATCH/api/contact/:id',
  'GET/api/client/:id/by-project-id',
  'PATCH/api/client/:id/finance-code',
  'GET/api/project/',
  'GET/api/project/all',
  'GET/api/project/:id/by-user-id',
  'GET/api/project/:id',
  'PATCH/api/project/:id',
  'PATCH/api/project/:id/archive',
  'GET/api/project-rfx/:id/by-project-id',
  'POST/api/project-rfx/',
  'PATCH/api/project-rfx/:id',
  'DELETE/api/project-rfx/:id',
  'GET/api/timesheet/',
  'POST/api/timesheet/timesheetentries',
  'POST/api/timesheet/timesheetentriesByDate',
  'POST/api/timesheet/timesheetentriesByUser',
  'GET/api/timesheet/user',
  'GET/api/timesheet/:id',
  'POST/api/timesheet/',
  'POST/api/timesheet/light',
  'POST/api/timesheet/batch',
  'POST/api/timesheet/getLight',
  'GET/api/timesheet/all',
  'GET/api/timesheet/week/:week',
  'GET/api/timesheet/allFromDate/:date',
  'GET/api/procurement/:id',
  'GET/api/projectnotes/:id',
  'PATCH/api/procurement/:id',
  'PATCH/api/timesheet/:id',
  'DELETE/api/timesheet/:id',
  'POST/api/MOU/',
  'PATCH/api/intake/:id',
  'DELETE/api/intake/:id',
  'DELETE/api/MOU/:id',
];

const User = [...commonForAllUsers];

const PSB_User = [
  ...commonForAllUsers,
  ...commonForPSBAdminAndUser,
  'POST/api/project/:id/assign-backup', // should be removed on 2nd phase based on the new requirement.
  'POST/api/project/:id/assign-lead', // should be removed on 2nd phase based on the new requirement.
];

const Manage_Finances = [
  ...PSB_User,
  'POST/api/project/finance',
  'POST/api/project/financeOld',
  'POST/api/project/timesheetprojects',
  'POST/api/project/timesheetprojectsOld',
  'POST/api/project/exportedPdfs',
  'POST/api/project/downloadFinancePdf',
  'POST/api/project/dischargeFinanceRecord',
  'POST/api/project/reGenerateFinanceRecord',
  'POST/api/project/reinstateFinanceRecord',
  'POST/api/project/dischargedPdfs',
];

const PSB_Intake_User = [
  ...PSB_User,
  'POST/api/project/:id/assign-lead',
  'POST/api/project/:id/assign-backup',
  'GET/api/intake/',
  'GET/api/intake/:id',
  'POST/api/intake/:id/approve',
];

const permissions = {
  PSB_Admin: [
    ...commonForAllUsers,
    'PATCH/api/rfx-type/:id',
    'DELETE/api/rfx-type/:id',
    'POST/api/rfx-type/',
    'PATCH/api/rfx-phase/:id',
    'DELETE/api/rfx-phase/:id',
    'POST/api/rfx-phase/',
    'GET/api/intake/',
    'GET/api/financecode/all',
    'GET/api/intake/:id',
    // 'PATCH/api/intake/:id',
    'POST/api/procurement/',
    'POST/api/financecode/',
    'PATCH/api/financecode/:id',
    'DELETE/api/financecode/:id',
    'POST/api/projectnotes/',
    'POST/api/intake/:id/approve',
    'POST/api/project/:id/assign-lead',
    'POST/api/project/:id/assign-backup',
    'PATCH/api/ministry/:id/update',
    'POST/api/ministry/',
    'GET/api/project-risk/:id',
    'PATCH/api/project-risk/:id/update',
    'PATCH/api/project-risk/:id',
    'PATCH/api/contact/:id/partial',
    'POST/api/project/finance',
    'POST/api/project/financeOld',
    'POST/api/project/timesheetprojects',
    'POST/api/project/timesheetprojectsOld',
    'POST/api/project/exportedPdfs',
    'POST/api/project/downloadFinancePdf',
    ...commonForPSBAdminAndUser,
  ],
  PSB_User,
  User,
  PSB_Intake_User,
  Manage_Finances,
};
