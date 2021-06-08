import * as Koa from 'koa';
import * as Router from 'koa-router';
import {
  retrieveRfxPhases,
  retrieveRfxPhaseById,
  updateRfxPhase,
  deleteRfxPhase,
  createRfxPhase,
  checkRfxUsage,
} from '../../../services/client/rfxPhase.service';
import { authorize } from '../../../services/common/authorize.service';
import { IRfxPhase } from '../../../models/interfaces';

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
export const saveRfxPhase = async (ctx: Koa.Context) => {
  try {
    const rfxPhase = ctx.request.body as IRfxPhase;
    if (!rfxPhase) {
      return 'no data found';
    }
    ctx.body = await createRfxPhase(rfxPhase);
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const rfxPhaseUpdate = async (ctx: Koa.Context) => {
  try {
    const body = ctx.request.body;
    console.log(body);
    ctx.body = await updateRfxPhase(body.RfxPhase.id, body.RfxPhase);
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const rfxPhaseDelete = async (ctx: Koa.Context) => {
  try {
    const res = await checkRfxUsage(ctx.params.id);
    if (!res) {
      await deleteRfxPhase(ctx.params.id);
      ctx.body = 'SUCCESS';
    } else {
      ctx.body = 'ERROR';
    }
  } catch (err) {
    ctx.throw(err.message);
  }
};

const routerOpts: Router.IRouterOptions = {
  prefix: 'api/rfx-phase',
};

const router: Router = new Router(routerOpts);
router.post('/', authorize, saveRfxPhase);
router.get('/', authorize, getRfxPhases);
router.get('/:id', authorize, getRfxPhaseById);
router.patch('/:id', authorize, rfxPhaseUpdate);
router.delete('/:id', authorize, rfxPhaseDelete);

export default router;
