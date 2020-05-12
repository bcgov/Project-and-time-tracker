import { IFinanceCodes } from './../../../models/interfaces/i-finance-codes';
import * as Koa from 'koa';
import * as Router from 'koa-router';
import {
  createFinanceCodes,
  retrieveAllFinanceCodes,
  updatFinanceCodes
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
    ctx.body = await updatFinanceCodes(body.procurementlog.id, body.procurementlog);
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


const routerOpts: Router.IRouterOptions = {
  prefix: '/financecode'
};

const router: Router = new Router(routerOpts);

// router.get('/:id/by-project-id', authorize, getContactByProjectId);
router.post('/', authorize, saveFinanceCodes);
router.get('/:id', authorize, getAllFinanceCodes);
router.patch('/:id', authorize, updateFinanceCode);

export default router;
