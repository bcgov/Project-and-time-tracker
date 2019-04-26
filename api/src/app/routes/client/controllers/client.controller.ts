import * as Koa from 'koa';
import * as Router from 'koa-router';
import {
  updateClient,
  retrieveClientByProjectId
} from '../../../services/client/client.service';
import { IClient } from '../../../models/interfaces/i-client';
import { authorize } from '../../../services/common/authorize.service';

export const getClientByProjectId = async (ctx: Koa.Context) => {
  try {
    ctx.body = await retrieveClientByProjectId(ctx.params.id);
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const updateFinanceCodes = async (ctx: Koa.Context) => {
  try {
    const client = ctx.request.body as IClient;
    if (!client) { 
      ctx.throw('no data found');
      return;
    }

    const validationErrors = validateFinanceCodes(client);
    
    if (validationErrors.length > 0) {
      ctx.throw(validationErrors.join(','));
      return;
    }

    await updateClient(ctx.params.id, {
      clientNo: client.clientNo,
      responsibilityCenter: client.responsibilityCenter,
      serviceCenter: client.serviceCenter,
      stob: client.stob,
      projectCode: client.projectCode
    });

    ctx.body = 'success';
  } catch (err) {
    ctx.throw(err.message);
  }
};

const validateFinanceCodes = (client: IClient) => {
  
  const validationErrors = [];

  // Business validation: Start.
  if (client.clientNo.toString().length !== 3) {
    validationErrors.push('Client No should be a 3 digit number.');
  }
  if (client.responsibilityCenter.toString().length !== 5) {
    validationErrors.push('Responsibility Center should be a 5 digit number.');
  }
  if (client.serviceCenter.toString().length !== 5) {
    validationErrors.push('Service Center should be a 5 digit number.');
  }
  if (client.stob.toString().length !== 4) {
    validationErrors.push('STOB should be a 4 digit number.');
  }
  if (client.projectCode.toString().length !== 7) {
    validationErrors.push('Project Code should be a 7 digit number.');
  }
  // Business validation: End.

  return validationErrors;
};

const routerOpts: Router.IRouterOptions = {
  prefix: '/client'
};

const router: Router = new Router(routerOpts);

router.get('/:id/by-project-id', authorize, getClientByProjectId);
router.patch('/:id/finance-code', authorize, updateFinanceCodes);

export default router;
