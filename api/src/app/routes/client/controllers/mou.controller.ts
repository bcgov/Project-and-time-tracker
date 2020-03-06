import * as Koa from 'koa';
import * as Router from 'koa-router';
import { authorize } from '../../../services/common/authorize.service';
import { retrieveMOUs, createMOU } from '../../../services/client/mou.service';

export const getMOUs = async (ctx: Koa.Context) => {
    try {
        const rfxTypes = await retrieveMOUs();
        ctx.body = rfxTypes;
    } catch (err) {
        ctx.throw(err.message);
    }
};

export const createMOUAction = async (ctx: Koa.Context) => {
    try {
        ctx.body = await createMOU(ctx.request.body);
    } catch (err) {
        ctx.throw(err.message);
    }
};


const routerOpts: Router.IRouterOptions = {
    prefix: '/MOU'
};

const router: Router = new Router(routerOpts);

router.get('/', authorize, getMOUs);
router.post('/', authorize, createMOUAction);

export default router;
