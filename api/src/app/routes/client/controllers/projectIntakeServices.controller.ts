import * as Koa from 'koa';
import * as Router from 'koa-router';
import { 
  retrieveProjectIntakeServices, 
  retrieveProjectIntakeServicesById 
} from '../../../services/client/projectIntakeServices.service';
import { authorize } from '../../../services/common/authorize.service';

export const getProjectIntakeServices = async (ctx: Koa.Context) => {
  try {
    const projectIntakeServices = await retrieveProjectIntakeServices();
    ctx.body = projectIntakeServices;
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const getProjectIntakeServicesById = async (ctx: Koa.Context) => {
  try {
    ctx.body = await retrieveProjectIntakeServicesById(ctx.params.id);
  } catch (err) {
    ctx.throw(err.message);
  }
};

const routerOpts: Router.IRouterOptions = {
  prefix: '/project-intake-service'
};

const router: Router = new Router(routerOpts);

router.get('/', authorize, getProjectIntakeServices);
router.get('/:id', authorize, getProjectIntakeServicesById);

export default router;
