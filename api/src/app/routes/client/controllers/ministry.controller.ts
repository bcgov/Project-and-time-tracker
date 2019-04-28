import * as Koa from 'koa';
import * as Router from 'koa-router';
import { 
  retrieveMinistries, 
  retrieveMinistryById 
} from '../../../services/client/ministry.service';
import { authorize } from '../../../services/common/authorize.service';

export const getMinistries = async (ctx: Koa.Context) => {
  try { 
    const ministries = await retrieveMinistries();
    ctx.body = ministries;
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const getMinistryById = async (ctx: Koa.Context) => {
  try {
    ctx.body = await retrieveMinistryById(ctx.params.id);
  } catch (err) {
    ctx.throw(err.message);
  }
};

const routerOpts: Router.IRouterOptions = {
  prefix: '/ministry'
};

const router: Router = new Router(routerOpts);

router.get('/', authorize, getMinistries);
router.get('/:id', authorize, getMinistryById);

export default router;
