import * as Koa from 'koa';
import * as Router from 'koa-router';
import { retrieveUsers, retrieveUsersWithFinanceCodes} from '../../../services/client/user.service';
import { Role } from '../../roles';
import { authorize } from '../../../services/common/authorize.service';

/*export const getUsersByRole = async (ctx: Koa.Context) => {
  try {
    //console.log("getUsersByRole");
    const users = await retrieveUsersNameAndIdByRole([
      Role.PSB_Admin,
      Role.PSB_User,
      Role.PSB_Intake_User,
      Role.Manage_Finances
    ]);
    ctx.body = users;
  } catch (err) {
    ctx.throw(err.message);
  }
};*/

export const getUsers = async (ctx: Koa.Context) => {
  try {
    
    const users = await retrieveUsersWithFinanceCodes();
    ctx.body = users;
  } catch (err) {
    ctx.throw(err.message);
  }
};


const routerOpts: Router.IRouterOptions = {
  prefix: '/api/user'
};

const router: Router = new Router(routerOpts);

router.get('/', authorize, getUsers);

export default router;
