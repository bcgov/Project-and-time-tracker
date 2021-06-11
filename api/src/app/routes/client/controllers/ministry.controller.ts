import * as Koa from 'koa';
import * as Router from 'koa-router';
import { 
  retrieveMinistries, 
  retrieveMinistryById, 
  updateMinistry,
  retrieveAllMinistries,
  createMinistry
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


export const getAllMinistries = async (ctx: Koa.Context) => {
  try { 
    const ministries = await retrieveAllMinistries();
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

export const updateMinistryActionById = async (ctx: Koa.Context) => {
  try {
    const ministry = ctx.request.body;
    console.log('updateMinistryAction called', { ministry });
    const ret = await updateMinistry(ministry);
    console.log('updateMinistryAction done', {ret})
    ctx.body = 'success';
  } catch (err) {
    ctx.throw(err.message)
  }
}

export const addMinistry = async (ctx: Koa.Context) => {
  try {
    const ministryName = ctx.request.body;
    await createMinistry(ministryName);
    ctx.body = 'success';
  } catch (err) {
    ctx.throw(err.message)
  }
}

const routerOpts: Router.IRouterOptions = {
  prefix: '/api/ministry'
};

const router: Router = new Router(routerOpts);

router.get('/', authorize, getMinistries);
router.post('/', authorize, addMinistry);
router.get('/all', authorize, getAllMinistries);
router.get('/:id', authorize, getMinistryById);
router.patch('/:id/update', authorize, updateMinistryActionById);

export default router;
