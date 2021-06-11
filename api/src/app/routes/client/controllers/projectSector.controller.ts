import * as Koa from 'koa';
import * as Router from 'koa-router';
import { 
  retrieveProjectSectors, 
  retrieveProjectSectorById 
} from '../../../services/client/projectSector.service';
import { authorize } from '../../../services/common/authorize.service';

export const getProjectSectors = async (ctx: Koa.Context) => {
  try {
    const projectSectors = await retrieveProjectSectors();
    ctx.body = projectSectors;
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const getProjectSectorById = async (ctx: Koa.Context) => {
  try {
    ctx.body = await retrieveProjectSectorById(ctx.params.id);
  } catch (err) {
    ctx.throw(err.message);
  }
};

const routerOpts: Router.IRouterOptions = {
  prefix: '/api/project-sector'
};

const router: Router = new Router(routerOpts);

router.get('/', authorize, getProjectSectors);
router.get('/:id', authorize, getProjectSectorById);

export default router;
