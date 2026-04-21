import Koa from 'koa';
import Router from 'koa-router';

const router = new Router({
  prefix: '/health'
});

/**
 * Liveness probe
 * - Is the process alive?
 * - No dependencies
 * - Must be extremely reliable
 */
const live = async (ctx: Koa.Context) => {
  ctx.status = 200;
  ctx.body = { status: 'alive' };
};

/**
 * Readiness probe
 * - Is the app ready to receive traffic?
 * - You MAY check dependencies here if required
 */
const ready = async (ctx: Koa.Context) => {
  ctx.status = 200;
  ctx.body = { status: 'ready' };
};

router.get('/live', live);
router.get('/ready', ready);

export default router;