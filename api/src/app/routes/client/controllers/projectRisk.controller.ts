import * as Koa from 'koa';
import * as Router from 'koa-router';
import {
  retrieveQuestions,
  retrieveProjectQuestions,
  updateRiskAnalysis
} from '../../../services/client/projectRisk.service';

import { authorize } from '../../../services/common/authorize.service';

export const getRiskQuestions = async (ctx: Koa.Context) => {
  try {
    const questions = await retrieveQuestions();
    ctx.body = questions;
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const getProjectRiskQuestions = async (ctx: Koa.Context) => {
  try {
    const questions = await retrieveProjectQuestions(ctx.params.id);
    ctx.body = questions;
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const updateProjectRiskAnalysis = async (ctx: Koa.Context) => {
  try {
    const projectId = ctx.params.id;
    await updateRiskAnalysis(ctx.request.body, projectId);
    const questions = await retrieveProjectQuestions(projectId);
    ctx.body = questions;
  } catch (err) {
    ctx.throw(err.message);
  }
};

const routerOpts: Router.IRouterOptions = {
  prefix: '/project-risk'
};

const router: Router = new Router(routerOpts);

router.get('/', authorize, getRiskQuestions);
router.get('/:id', authorize, getProjectRiskQuestions);
router.patch('/:id/update', authorize, updateProjectRiskAnalysis);

export default router;
