import * as Koa from 'koa';
import * as Router from 'koa-router';
import {
  retrieveRfxTypes,
  retrieveRfxTypeById,
  updateRfxType,
  deleteRfxType,
  createRfxType,
  checkRfxUsage,
} from '../../../services/client/rfxType.service';
import { authorize } from '../../../services/common/authorize.service';
import { IRfxType } from '../../../models/interfaces';
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

export const saveRfxType = async (ctx: Koa.Context) => {
  try {
    const rfxType = ctx.request.body as IRfxType;
    if (!rfxType) {
      return 'no data found';
    }
    ctx.body = await createRfxType(rfxType);
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const rfxTypeUpdate = async (ctx: Koa.Context) => {
  try {
    const body = ctx.request.body;
    console.log(body);
    ctx.body = await updateRfxType(body.RfxType.id, body.RfxType);
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const rfxTypeDelete = async (ctx: Koa.Context) => {
  try {
    const res = await checkRfxUsage(ctx.params.id);
    if (!res) {
      await deleteRfxType(ctx.params.id);
      ctx.body = 'SUCCESS';
    } else {
      ctx.body = 'ERROR';
    }
  } catch (err) {
    ctx.throw(err.message);
  }
};

const routerOpts: Router.IRouterOptions = {
  prefix: 'api/rfx-type',
};

const router: Router = new Router(routerOpts);
router.post('/', authorize, saveRfxType);
router.get('/', authorize, getRfxTypes);
router.get('/:id', authorize, getRfxTypeById);
router.patch('/:id', authorize, rfxTypeUpdate);
router.delete('/:id', authorize, rfxTypeDelete);
export default router;
