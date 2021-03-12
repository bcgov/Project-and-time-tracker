import * as Koa from 'koa';
import * as Router from 'koa-router';
import {
  retrieveProjects,
  retrieveProjectById,
  updateProject,
  retrieveProjectsByUserId,
  retrieveArchivedProjects,
  retrieveTimesheetProjects,
  retrieveTimesheetProjectsOld,
  retrieveExportedPdfs,
  retrieveDischargedPdfs,
  downloadpdf,
  retrieveAllProjects,
  retrieveMouProjectsByUserId,
  retrieveFinanceData,
  retrieveFinanceDataOld,
  dischargeFinanceRecord,
  reinstateFinanceRecord,
  reGenerateFinanceRecord,
  getProjectCategories
} from '../../../services/client/project.service';
import { IProject } from '../../../models/interfaces/i-project';
import { retrieveClientByProjectId } from '../../../services/client/client.service';
import { Role } from '../../roles';
import { IAuth } from '../../../models/interfaces/i-auth';
import { authorize, isInRoles } from '../../../services/common/authorize.service';
import { createMOU } from '../../../services/client/mou.service';

export const getProjects = async (ctx: Koa.Context) => {
  try {
    const auth = ctx.state.auth as IAuth;
    ctx.body = await retrieveProjectsByUserId(auth.userId);
  } catch (err) {
    ctx.throw(err.message);
  }
};
export const getAllProjects = async (ctx: Koa.Context) => {
  try {
    const auth = ctx.state.auth as IAuth;
    ctx.body = await retrieveAllProjects();
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const getmouProjects = async (ctx: Koa.Context) => {
  try {
    ctx.body = await retrieveMouProjectsByUserId(ctx.params.id);
  } catch (err) {
    ctx.throw(err.message);
  }
};

// Calling separate method for archived projects
export const getArchivedProjects = async (ctx: Koa.Context) => {
  try {
    const auth = ctx.state.auth as IAuth;
    ctx.body = await retrieveArchivedProjects();
  } catch (err) {
    ctx.throw(err.message);
  }
};
export const timesheetProjects = async (ctx: Koa.Context) => {
  try {
    const auth = ctx.state.auth as IAuth;
    const obj = ctx.request.body as any;
    ctx.body = await retrieveTimesheetProjects(obj);
  } catch (err) {
    ctx.throw(err.message);
  }
};
export const timesheetProjectsOld = async (ctx: Koa.Context) => {
  try {
    const auth = ctx.state.auth as IAuth;
    const obj = ctx.request.body as any;
    const result = await retrieveTimesheetProjectsOld(obj);
    ctx.body = result;
  } catch (err) {
    ctx.throw(err.message);
  }
};
export const exportedPdfs = async (ctx: Koa.Context) => {
  try {
    const auth = ctx.state.auth as IAuth;
    const obj = ctx.request.body as any;
    ctx.body = await retrieveExportedPdfs(obj);
  } catch (err) {
    ctx.throw(err.message);
  }
};
export const dischargedPdfs = async (ctx: Koa.Context) => {
  try {
    const auth = ctx.state.auth as IAuth;
    const obj = ctx.request.body as any;
    ctx.body = await retrieveDischargedPdfs(obj);
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const downloadFinancePdf = async (ctx: Koa.Context) => {
  try {
    const auth = ctx.state.auth as IAuth;
    const obj = ctx.request.body as any;
    ctx.body = await downloadpdf(obj);
  } catch (err) {
    ctx.throw(err.message);
  }
};
export const dischargeFinancePdf = async (ctx: Koa.Context) => {
  try {
    const auth = ctx.state.auth as IAuth;
    const obj = ctx.request.body as any;
    ctx.body = await dischargeFinanceRecord(obj);
  } catch (err) {
    ctx.throw(err.message);
  }
};
export const reGenerateFinancePdf = async (ctx: Koa.Context) => {
  try {
    const auth = ctx.state.auth as IAuth;
    const obj = ctx.request.body as any;
    ctx.body = await reGenerateFinanceRecord(obj);
  } catch (err) {
    ctx.throw(err.message);
  }
};
export const reinstateFinancePdf = async (ctx: Koa.Context) => {
  try {
    const auth = ctx.state.auth as IAuth;
    const obj = ctx.request.body as any;
    ctx.body = await reinstateFinanceRecord(obj);
  } catch (err) {
    ctx.throw(err.message);
  }
};
export const getfinanceExport = async (ctx: Koa.Context) => {
  try {
    const auth = ctx.state.auth as IAuth;
    const obj = ctx.request.body as any;
    ctx.body = await retrieveFinanceData(obj, auth.userId);
  } catch (err) {
    ctx.throw(err.message);
  }
};
export const getfinanceExportOld = async (ctx: Koa.Context) => {
  try {
    const auth = ctx.state.auth as IAuth;
    const obj = ctx.request.body as any;
    ctx.body = await retrieveFinanceDataOld(obj, auth.userId);
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const getProjectById = async (ctx: Koa.Context) => {
  try {
    ctx.body = await retrieveProjectById(ctx.params.id);
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const updateProjectAction = async (ctx: Koa.Context) => {
  try {
    const auth = ctx.state.auth as IAuth;
    const project = ctx.request.body as IProject;
    if (!project) {
      ctx.throw('no data found');
      return;
    }

    const validationErrors = validateProject(project);
    if (validationErrors.length > 0) {
      ctx.throw(validationErrors.join(','));
      return;
    }

    // See if mou exists, if so assign ID
    // See if MOU doesn't exist.  Can happen if user doesn't press 'Enter' and just clicks on save for a new MOU
    let mou = project.mou;
    if (typeof project.mou === 'string') {
      // It's a new MOU w/o ID, instead of an object
      // Create new MOU
      mou = await createMOU({ name: project.mou });
    }

    let updatingFields = {
      projectName: project.projectName,
      completionDate: project.completionDate,
      contractValue: project.contractValue,
      mouAmount: project.mouAmount || 0,
      description: project.description,
      leadUserId: project.leadUserId ? project.leadUserId : undefined,
      backupUserId: project.backupUserId,
      modifiedUserId: auth.userId,
      dateOfReprocurement: project.dateOfReprocurement,
      teamWideProject: project.teamWideProject,
      isReprocurement: project.isReprocurement,
      previousContractBackground: project.previousContractBackground,
      projectFailImpact: project.projectFailImpact,
      projectSuccess: project.projectSuccess,
      mou: mou,
    };
  
    // Check if the user has permission to update the categoryId.
    const canEditProjectCategories = isInRoles(auth, [Role.PSB_Admin, Role.PSB_Intake_User]);
    if(canEditProjectCategories){
      updatingFields['categoryId'] = project.categoryId;
    }
    
    const updatingClient = {
      id: project.client.id,
      isNonMinistry: project.client.isNonMinistry,
      nonMinistryName: project.client.nonMinistryName,
      ministry: project.client.ministry,
    };

    const client = await retrieveClientByProjectId(ctx.params.id);
    if (!project.client.isNonMinistry) {
      if (project.leadUserId || project.backupUserId) {
        if (
          !(
            client.clientNo &&
            client.clientNo.length > 0 &&
            client.responsibilityCenter &&
            client.responsibilityCenter.length > 0 &&
            client.serviceCenter &&
            client.serviceCenter.length > 0 &&
            client.stob &&
            client.stob.length > 0 &&
            client.projectCode &&
            client.projectCode.length > 0
          )
        ) {
          ctx.throw(
            'Project Lead/Backup cannot be assigned without providing all Finance Codes. Please fill the Finance Codes.'
          );
          return;
        }
      }
    }

    await updateProject(ctx.params.id, updatingFields, updatingClient);

    ctx.body = 'success';
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const archiveProjectAction = async (ctx: Koa.Context) => {
  try {
    await updateProject(ctx.params.id, {
      is_archived: ctx.request.body.is_archived,
    });
    ctx.body = 'success';
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const assignLeadAction = async (ctx: Koa.Context) => {
  try {
    const obj = ctx.request.body as any;
    if (!obj) {
      ctx.throw('no data found');
      return;
    }

    await updateProject(ctx.params.id, {
      leadUserId: obj.userId,
    });

    ctx.body = 'success';
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const assignBackupAction = async (ctx: Koa.Context) => {
  try {
    const obj = ctx.request.body as any;
    if (!obj) {
      ctx.throw('no data found');
      return;
    }

    await updateProject(ctx.params.id, {
      backupUserId: obj.userId,
    });

    ctx.body = 'success';
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const getCategories = async (ctx: Koa.Context) => {
  try {
    ctx.body = getProjectCategories();
  } catch (err) {
    ctx.throw(err.message);
  }
};

const validateProject = (project: IProject) => {
  const validationErrors = [];

  if (!project.projectName) {
    validationErrors.push('Project Name is required.');
  }

  if (!project.completionDate) {
    validationErrors.push('Project Deadline is required.');
  }

  if (!(project.contractValue && project.contractValue > 0)) {
    validationErrors.push('Contract Amount is required.');
  }

  return validationErrors;
};

const routerOpts: Router.IRouterOptions = {
  prefix: '/project',
};

const router: Router = new Router(routerOpts);

router.get('/', authorize, getProjects);
router.get('/all', authorize, getAllProjects);
router.get('/:id/by-user-id', authorize, getmouProjects);
router.get('/archived', authorize, getArchivedProjects);
router.get('/categories', authorize, getCategories);
router.post('/timesheetprojects', authorize, timesheetProjects);
router.post('/timesheetprojectsOld', authorize, timesheetProjectsOld);
router.post('/exportedPdfs', authorize, exportedPdfs);
router.post('/dischargedPdfs', authorize, dischargedPdfs);
router.post('/downloadFinancePdf', authorize, downloadFinancePdf);
router.post('/dischargeFinanceRecord', authorize, dischargeFinancePdf);
router.post('/reGenerateFinanceRecord', authorize, reGenerateFinancePdf);
router.post('/reinstateFinanceRecord', authorize, reinstateFinancePdf);

router.post('/finance', authorize, getfinanceExport);
router.post('/financeOld', authorize, getfinanceExportOld);
router.get('/:id', authorize, getProjectById);
router.patch('/:id', authorize, updateProjectAction);
router.patch('/:id/archive', authorize, archiveProjectAction);

// router.delete('/:id', deleteProjectAction); TODO: Implement in the 2nd phase of development.
router.post('/:id/assign-lead', authorize, assignLeadAction);
router.post('/:id/assign-backup', authorize, assignBackupAction);

export default router;
