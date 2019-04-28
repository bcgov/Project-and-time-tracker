import * as Koa from 'koa';
import * as Router from 'koa-router';
import {
  retrieveRfxPhases,
  retrieveRfxPhaseById
} from '../../../services/client/rfxPhase.service';
import { authorize } from '../../../services/common/authorize.service';

export const getRfxPhases = async (ctx: Koa.Context) => {
  try {
    const rfxPhases = await retrieveRfxPhases();
    ctx.body = rfxPhases;
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const getRfxPhaseById = async (ctx: Koa.Context) => {
  try {
    ctx.body = await retrieveRfxPhaseById(ctx.params.id);
  } catch (err) {
    ctx.throw(err.message);
  }
};

const routerOpts: Router.IRouterOptions = {
  prefix: '/rfx-phase'
};

const router: Router = new Router(routerOpts);

router.get('/', authorize, getRfxPhases);
router.get('/:id', authorize, getRfxPhaseById);

export default router;
