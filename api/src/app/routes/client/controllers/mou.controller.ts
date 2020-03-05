import * as Koa from 'koa';
import * as Router from 'koa-router';
import { authorize } from '../../../services/common/authorize.service';
import { retrieveMOUs } from '../../../services/client/mou.service';

export const getMOUs = async (ctx: Koa.Context) => {
    try {
        const rfxTypes = await retrieveMOUs();
        ctx.body = rfxTypes;
    } catch (err) {
        ctx.throw(err.message);
    }
};

export const createMOU = async (ctx: Koa.Context) => {
    try {
        console.log('createMOU called')
        ctx.body = await createMOU(ctx.params.id);
    } catch (err) {
        ctx.throw(err.message);
    }
};


const routerOpts: Router.IRouterOptions = {
    prefix: '/MOU'
};

const router: Router = new Router(routerOpts);

router.get('/', authorize, getMOUs);
router.post('/', authorize, createMOU);

export default router;
