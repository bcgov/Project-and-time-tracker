
import * as Koa from 'koa';
import * as Router from 'koa-router';
import {
    createProjectNotes,
    retrieveAllProjectNotes,
} from '../../../services/client/projectnote.service';
import { authorize } from '../../../services/common/authorize.service';
import { ProjectNote } from '../../../models/entities/project_Note.entity';

// export const getContactByProjectId = async (ctx: Koa.Context) => {
//   try {
//     ctx.body = await retrieveContactByProjectId(ctx.params.id);
//   } catch (err) {
//     ctx.throw(err.message);
//   }
// };

export const saveProjectNotes = async (ctx: Koa.Context) => {
  try {
    const projectnotes = ctx.request.body as ProjectNote;
    if (!projectnotes) { 
      return 'no data found'; 
    }
        ctx.body = await createProjectNotes(projectnotes);

  } catch (err) {
    ctx.throw(err.message);
  }
};

export const getAllProjectNotes = async (ctx: Koa.Context) => {
  try {
    // TODO - If user is NOT admin, return only the sheets by user id?
    const res = await retrieveAllProjectNotes(ctx.params.id);
     ctx.body = res;
  } catch (err) {
    ctx.throw(err.message);
  }
};


const routerOpts: Router.IRouterOptions = {
  prefix: '/projectnotes'
};

const router: Router = new Router(routerOpts);

// router.get('/:id/by-project-id', authorize, getContactByProjectId);
router.post('/', authorize, saveProjectNotes);
router.get('/:id', authorize, getAllProjectNotes);
// router.patch('/:id', authorize, updateProcurementLog);

export default router;
