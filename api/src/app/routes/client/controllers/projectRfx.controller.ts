import * as Koa from 'koa';
import * as Router from 'koa-router';
import {
  updateProjectRfx,
  createProjectRfx,
  deleteProjectRfx,
  retrieveProjectRfxByProjectId
} from '../../../services/client/projectRfx.service';
import { IProjectRfx } from '../../../models/interfaces/i-project-rfx';
import { authorize } from '../../../services/common/authorize.service';

export const getProjectRfxByProjectId = async (ctx: Koa.Context) => {
  try {
    ctx.body = await retrieveProjectRfxByProjectId(ctx.params.id);
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const createProjectRfxAction = async (ctx: Koa.Context) => {
  try {
    const projectRfx = ctx.request.body as IProjectRfx;
    if (!projectRfx) {
      ctx.throw('no data found');
      return;
    }

    const validationErrors = validateProjectRfx(projectRfx);
    if (validationErrors.length > 0) {
      ctx.throw(validationErrors.join(','));
      return;
    }

    projectRfx.id = undefined;
    ctx.body = await createProjectRfx(projectRfx);
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const updateProjectRfxAction = async (ctx: Koa.Context) => {
  try {
    const projectRfx = ctx.request.body as IProjectRfx;
    if (!projectRfx) {
      return 'no data found';
    }
    const validationErrors = validateProjectRfx(projectRfx);
    if (validationErrors.length > 0) {
      ctx.throw(validationErrors.join(','));
      return;
    }

    await updateProjectRfx(ctx.params.id, projectRfx);

    ctx.body = 'success';
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const deleteProjectRfxAction = async (ctx: Koa.Context) => {
  try {
    await deleteProjectRfx(ctx.params.id);

    ctx.body = 'success';
  } catch (err) {
    ctx.throw(err.message);
  }
};

const validateProjectRfx = (projectRfx: IProjectRfx) => {
  const validationErrors = [];

  if (!(projectRfx.rfxType && projectRfx.rfxType.id)) {
    validationErrors.push('Rfx Type is required.');
  }
  if (!(projectRfx.rfxPhase && projectRfx.rfxPhase.id)) {
    validationErrors.push('Current Phase is required.');
  }
  if (!(projectRfx.project && projectRfx.project.id)) {
    validationErrors.push('Project is required.');
  }
  if (!projectRfx.rfxName) {
    validationErrors.push('Rfx Name is required.');
  }
  if (!projectRfx.rfxOverview) {
    validationErrors.push('Summary of RFx is required.');
  }
  if (!projectRfx.clientResponsibilities) {
    validationErrors.push('Client Responsibilities is required.');
  }
  if (!projectRfx.psdResponsibilities) {
    validationErrors.push('PSD Responsibilities is required.');
  }
  return validationErrors;
};

const routerOpts: Router.IRouterOptions = {
  prefix: '/api/project-rfx'
};

const router: Router = new Router(routerOpts);

router.get('/:id/by-project-id', authorize, getProjectRfxByProjectId);
router.post('/', authorize, createProjectRfxAction);
router.patch('/:id', authorize, updateProjectRfxAction);
router.delete('/:id', authorize, deleteProjectRfxAction);

export default router;
