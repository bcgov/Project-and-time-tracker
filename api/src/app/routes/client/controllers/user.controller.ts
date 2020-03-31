import * as Koa from 'koa';
import * as Router from 'koa-router';
import { retrieveUsersNameAndIdByRole } from '../../../services/client/user.service';
import { Role } from '../../roles';
import { authorize } from '../../../services/common/authorize.service';

export const getUsersByRole = async (ctx: Koa.Context) => {
  try { 
    const users = await retrieveUsersNameAndIdByRole([Role.PSB_Admin, Role.PSB_User, Role.PSB_Intake_User]);
    ctx.body = users;
  } catch (err) {
    ctx.throw(err.message);
  }
};

const routerOpts: Router.IRouterOptions = {
  prefix: '/user'
};

const router: Router = new Router(routerOpts);

router.get('/', authorize, getUsersByRole);

export default router;
