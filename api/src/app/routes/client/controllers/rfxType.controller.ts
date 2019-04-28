import * as Koa from 'koa';
import * as Router from 'koa-router';
import {
  retrieveRfxTypes,
  retrieveRfxTypeById
} from '../../../services/client/rfxType.service';
import { authorize } from '../../../services/common/authorize.service';

export const getRfxTypes = async (ctx: Koa.Context) => {
  try {
    const rfxTypes = await retrieveRfxTypes();
    ctx.body = rfxTypes;
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const getRfxTypeById = async (ctx: Koa.Context) => {
  try {
    ctx.body = await retrieveRfxTypeById(ctx.params.id);
  } catch (err) {
    ctx.throw(err.message);
  }
};

const routerOpts: Router.IRouterOptions = {
  prefix: '/rfx-type'
};

const router: Router = new Router(routerOpts);

router.get('/', authorize, getRfxTypes);
router.get('/:id', authorize, getRfxTypeById);

export default router;
