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
    ctx.throw('Don\'t have permission to perform this action.');
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
  'GET/rfx-phase/:id',
  'GET/rfx-type/',
  'GET/rfx-type/:id',
  'GET/user/'
];

const commonForPSBAdminAndUser = [
  'GET/contact/:id/by-project-id',
  'PATCH/contact/:id',
  'GET/client/:id/by-project-id',
  'PATCH/client/:id/finance-code',
  'GET/project/',
  'GET/project/:id',
  'PATCH/project/:id',
  'GET/project-rfx/:id/by-project-id',
  'POST/project-rfx/',
  'PATCH/project-rfx/:id',
  'DELETE/project-rfx/:id',
  'GET/timesheet/',
  'GET/timesheet/:id',
  'POST/timesheet/',
  'POST/timesheet/light',
  'POST/timesheet/getLight',
  'PATCH/timesheet/:id',
  'DELETE/timesheet/:id',
];

const permissions = {
  PSB_Admin: [
    ...commonForAllUsers,    
    'GET/intake/',
    'GET/intake/:id',
    'POST/intake/',
    'POST/intake/:id/approve',
    'POST/project/:id/assign-lead',
    'POST/project/:id/assign-backup',
    'GET/project-risk/',
    ...commonForPSBAdminAndUser
  ],
  PSB_User: [
    ...commonForAllUsers,    
    'POST/project/:id/assign-lead', // should be removed on 2nd phase based on the new requirement.
    'POST/project/:id/assign-backup', // should be removed on 2nd phase based on the new requirement.
    ...commonForPSBAdminAndUser
  ],
  User: [
    ...commonForAllUsers,
    'POST/intake/'
  ],
};
