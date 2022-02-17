import { IFinanceCodes } from './../../../models/interfaces/i-finance-codes';
import * as Koa from 'koa';
import * as Router from 'koa-router';
import {
  createFinanceCodes,
  retrieveAllFinanceCodes,
  updatFinanceCodes,deleteFinanceCodes
} from '../../../services/client/financeCode.service';
import { authorize } from '../../../services/common/authorize.service';

export const saveFinanceCodes = async (ctx: Koa.Context) => {
  try {
    const financecodes = ctx.request.body as IFinanceCodes;
    if (!financecodes) { 
      return 'no data found'; 
    }
        ctx.body = await createFinanceCodes(financecodes);

  } catch (err) {
    ctx.throw(err.message);
  }
};

export const updateFinanceCode = async (ctx: Koa.Context) => {
  try {
    const body = ctx.request.body;
    console.log(body);
    ctx.body = await updatFinanceCodes(body.FinanceCodes.id, body.FinanceCodes);
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const getAllFinanceCodes = async (ctx: Koa.Context) => {
  try {
    // TODO - If user is NOT admin, return only the sheets by user id?
    ctx.body = await retrieveAllFinanceCodes();
  } catch (err) {
    ctx.throw(err.message);
  }
};
export const deleteFinanceCode = async (ctx: Koa.Context) => {
  try {
    await deleteFinanceCodes(ctx.params.id);
    ctx.body = 'success';
  } catch (err) {
    ctx.throw(err.message);
  }
};

const routerOpts: Router.IRouterOptions = {
  prefix: '/api/financecode'
};

const router: Router = new Router(routerOpts);

// router.get('/:id/by-project-id', authorize, getContactByProjectId);
router.post('/', authorize, saveFinanceCodes);
router.get('/all', authorize, getAllFinanceCodes);
router.patch('/:id', authorize, updateFinanceCode);
router.delete('/:id', authorize, deleteFinanceCode);
export default router;
