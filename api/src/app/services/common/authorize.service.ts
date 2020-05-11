import * as Koa from 'koa';
import * as HttpStatus from 'http-status-codes';
import { IAuth } from '../../models/interfaces/i-auth';

export const authorize = async (ctx: Koa.Context, next: () => Promise<any>) => {
  const auth = ctx.state.auth as IAuth;

  const path = `${ctx.method}${ctx._matchedRoute}`;
  if (permissions[auth.role].includes(path)) {
    await next();
  } else {
    ctx.status = HttpStatus.FORBIDDEN;
    ctx.throw("Don't have permission to perform this action.");
  }
};

const commonForAllUsers = [
  'GET/ministry/',
  'GET/ministry/:id',
  'GET/project-sector/',
  'GET/project-sector/:id',
  'GET/project-intake-category/',
  'GET/project-intake-category/:id',
  'GET/project-intake-service/',
  'GET/project-intake-service/:id',
  'GET/rfx-phase/',
  'GET/project-risk/',
  'GET/rfx-phase/:id',
  'GET/rfx-type/',
  'GET/rfx-type/:id',
  'GET/user/',
  'GET/MOU/',
  'POST/intake/'
];

const commonForPSBAdminAndUser = [
  'GET/contact/:id/by-project-id',
  'PATCH/contact/:id',
  'GET/client/:id/by-project-id',
  'PATCH/client/:id/finance-code',
  'GET/project/',
  'GET/project/all',
  'GET/project/:id/by-user-id',
  'GET/project/:id',
  'PATCH/project/:id',
  'PATCH/project/:id/archive',
  'GET/project-rfx/:id/by-project-id',
  'POST/project-rfx/',
  'PATCH/project-rfx/:id',
  'DELETE/project-rfx/:id',
  'GET/timesheet/',
  'POST/timesheet/timesheetentries',
  'POST/timesheet/timesheetentriesByDate',
  'POST/timesheet/timesheetentriesByUser',
  'GET/timesheet/user',
  'GET/timesheet/:id',
  'POST/timesheet/',
  'POST/timesheet/light',
  'POST/timesheet/batch',
  'POST/timesheet/getLight',
  'GET/timesheet/all',
  'GET/procurement/:id',
  'GET/projectnotes/:id',
  'PATCH/procurement/:id',
  'PATCH/timesheet/:id',
  'DELETE/timesheet/:id',
  'POST/MOU/',
  'PATCH/intake/:id',
  'DELETE/intake/:id',
  'DELETE/MOU/:id'
];

const User = [...commonForAllUsers];

const PSB_User = [
  ...commonForAllUsers,
  ...commonForPSBAdminAndUser,
  'POST/project/:id/assign-backup', // should be removed on 2nd phase based on the new requirement.
  'POST/project/:id/assign-lead' // should be removed on 2nd phase based on the new requirement.
];

const manage_finances = [
  ...PSB_User,
  'POST/project/finance',
  'POST/project/timesheetprojects',
  'POST/project/exportedPdfs',
  'POST/project/downloadFinancePdf'
];

const PSB_Intake_User = [
  ...PSB_User,
  'POST/project/:id/assign-lead',
  'POST/project/:id/assign-backup',
  'GET/intake/',
  'GET/intake/:id',
  'POST/intake/:id/approve'
];

const permissions = {
  PSB_Admin: [
    ...commonForAllUsers,
    'GET/intake/',
    'GET/intake/:id',
    // 'PATCH/intake/:id',
    'POST/procurement/',
    'POST/projectnotes/',
    'POST/intake/:id/approve',
    'POST/project/:id/assign-lead',
    'POST/project/:id/assign-backup',
    'PATCH/ministry/:id/update',
    'POST/ministry/',
    'GET/project-risk/:id',
    'PATCH/project-risk/:id/update',
    'PATCH/project-risk/:id',
    'PATCH/contact/:id/partial',
    'POST/project/finance',
    'POST/project/timesheetprojects',
    'POST/project/exportedPdfs',
    'POST/project/downloadFinancePdf',
    ...commonForPSBAdminAndUser
  ],
  PSB_User,
  User,
  PSB_Intake_User,
  manage_finances
};
