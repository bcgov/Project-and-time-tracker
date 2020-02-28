import * as Koa from 'koa';
import * as Router from 'koa-router';
import {
  retrieveQuestions
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


export default router;
