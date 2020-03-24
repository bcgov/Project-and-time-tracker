import { IProcurement } from './../../../models/interfaces/i-procurement';
import * as Koa from 'koa';
import * as Router from 'koa-router';
import {
 createProcurementLog,
 retrieveAllProcurementLog,
 updateProcLog
} from '../../../services/client/procurementlog.service';
import { authorize } from '../../../services/common/authorize.service';

// export const getContactByProjectId = async (ctx: Koa.Context) => {
//   try {
//     ctx.body = await retrieveContactByProjectId(ctx.params.id);
//   } catch (err) {
//     ctx.throw(err.message);
//   }
// };

export const saveProcurementLog = async (ctx: Koa.Context) => {
  try {
    const procurementlogs = ctx.request.body as IProcurement;
    if (!procurementlogs) { 
      return 'no data found'; 
    }
        ctx.body = await createProcurementLog(procurementlogs);

  } catch (err) {
    ctx.throw(err.message);
  }
};

export const updateProcurementLog = async (ctx: Koa.Context) => {
  try {
    const body = ctx.request.body;
    console.log(body);
    ctx.body = await updateProcLog(body.formData.id, body.formData);
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const getAllProcurementLog = async (ctx: Koa.Context) => {
  try {
    // TODO - If user is NOT admin, return only the sheets by user id?
    ctx.body = await retrieveAllProcurementLog();
  } catch (err) {
    ctx.throw(err.message);
  }
};

// const validateContacts = (contacts: IContact[]) => {
  
//   const validationErrors = [];
  
//   if (contacts && contacts.length > 0) {  
//     contacts.map(function (contact) {    
//       let contactTypeLabel = '';
//       if (contact.contactType === 'clientlead') { 
//         contactTypeLabel = 'Lead'; 
//       } else if (contact.contactType === 'clientsponsor') { 
//         contactTypeLabel = 'Sponsor'; 
//       } else { 
//         return; 
//       }

//       if (!contact.fullName) {
//         validationErrors.push(contactTypeLabel + ' Name is required.');
//       }

//       if (!contact.orgPosition) {
//         validationErrors.push(contactTypeLabel + ' Position is required.');
//       }

//       if (!contact.email) {
//         validationErrors.push(contactTypeLabel + ' Email is required.');
//       }

//       if (!contact.phoneNumber) {
//         validationErrors.push(contactTypeLabel + ' Phone Number is required.');
//       }      
//     });
//   } else {
//     validationErrors.push('Contacts not found.');
//   }

//   return validationErrors;
// };

const routerOpts: Router.IRouterOptions = {
  prefix: '/procurement'
};

const router: Router = new Router(routerOpts);

// router.get('/:id/by-project-id', authorize, getContactByProjectId);
router.post('/', authorize, saveProcurementLog);
router.get('/all', authorize, getAllProcurementLog);
router.patch('/:id', authorize, updateProcurementLog);

export default router;
