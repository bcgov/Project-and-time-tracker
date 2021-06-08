import * as Koa from 'koa';
import * as Router from 'koa-router';
import * as HttpStatus from 'http-status-codes';

export const verify = async (ctx: Koa.Context) => {
  // Verification will be done in the middleware. Just using the route to hit the request.
  ctx.status = HttpStatus.OK;
  ctx.body = 'success';
};

const routerOpts: Router.IRouterOptions = {
  prefix: 'api/auth'
};

const router: Router = new Router(routerOpts);

router.get('/verify', verify);

export default router;
