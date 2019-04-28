import * as Koa from 'koa';
import * as HttpStatus from 'http-status-codes';
import * as bodyParser from 'koa-bodyparser';
import * as cors from '@koa/cors';

import { appRoutes, allowedMethods } from './routes/routes';
import { validateToken } from '../app/services/common/auth-verification.service';

const app: Koa = new Koa();

// Middleware
app.use(bodyParser());
app.use(
  cors({
    origin: '*',
    allowHeaders: ['Content-Type', 'Authorization'],
    allowMethods: 'GET, HEAD, PUT, POST, DELETE, PATCH'
  })
);

app.use(async (ctx: Koa.Context, next: () => Promise<any>) => {
  try {
    await next();
  } catch (error) {
    ctx.status =
      error.statusCode || error.status || HttpStatus.INTERNAL_SERVER_ERROR;
    error.status = ctx.status;
    ctx.body = { error };
    ctx.app.emit('error', error, ctx);
  }
});

// Authentication
app.use(validateToken);

appRoutes.forEach(itm => app.use(itm));
allowedMethods.forEach(itm => app.use(itm));

// Application error logging.
app.on('error', console.error);

export default app;
