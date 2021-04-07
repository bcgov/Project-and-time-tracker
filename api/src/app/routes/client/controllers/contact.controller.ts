import { IContact } from './../../../models/interfaces/i-contact';
import * as Koa from 'koa';
import * as Router from 'koa-router';
import {
  updateContact,
  createContact,
  retrieveContactByProjectId,
  deleteContact
} from '../../../services/client/contact.service';
import { authorize } from '../../../services/common/authorize.service';
import { 
  createProjectContact, 
  retrieveProjectContactsByContactId, 
  deleteProjectContact 
} from '../../../services/client/projectContacts.service';
import { IProjectContact } from '../../../models/interfaces/i-project-contact';

export const getContactByProjectId = async (ctx: Koa.Context) => {
  try {
    ctx.body = await retrieveContactByProjectId(ctx.params.id);
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const saveContactAction = async (ctx: Koa.Context) => {
  try {
    const contacts = ctx.request.body as IContact[];
    let isClientContactExist = false;
    if (!contacts) { 
      return 'no data found'; 
    }
    
    const validationErrors = validateContacts(contacts);
    
    if (validationErrors.length > 0) {
      ctx.throw(validationErrors.join(','));
      return;
    }

    for (let index = 0; index < contacts.length; index++) {
      if (contacts[index].contactType === 'clientcontact') {
        isClientContactExist = true;
      }
      if (!contacts[index].id || contacts[index].id === undefined) {
        contacts[index].id = undefined;
        contacts[index].contactType = 'clientcontact';
        const createdContact = await createContact(contacts[index]);
        await createProjectContact(<IProjectContact> {
          contact: { id: createdContact.id },
          project: { id: ctx.params.id }
        });
      } else {
        const contact: IContact = contacts[index];
        await updateContact(contact.id, {
          fullName: contact.fullName,
          orgPosition: contact.orgPosition,
          orgName: contact.orgName,
          email: contact.email,
          phoneNumber: contact.phoneNumber,
          roleName: contact.roleName
        });
      }
    }
    if (!isClientContactExist) {
      const myContacts: IContact[] = await retrieveContactByProjectId(ctx.params.id);
      const clientContacts: IContact[] = myContacts.filter(item => (item.contactType === 'clientcontact'));
      for (const contact of clientContacts) {
        const projectContacts = await retrieveProjectContactsByContactId(contact.id);
        for (const projectContact of projectContacts) {
          await deleteProjectContact(projectContact.id);
          await deleteContact(contact.id);
        }
      }
    }
    ctx.body = await retrieveContactByProjectId(ctx.params.id);
  } catch (err) {
    ctx.throw(err.message);
  }
};

// Allow partially updating some contact fields
// Specifically used for updating "Rate" in admin section.
export const updateContactActionPartial = async (ctx: Koa.Context) => {
  try {
    const contact = ctx.request.body as Partial<IContact>;
    ctx.body = await updateContact(ctx.params.id, contact);
  } catch (err) {
    ctx.throw(err.message);
  }
};

const validateContacts = (contacts: IContact[]) => {
  
  const validationErrors = [];
  
  if (contacts && contacts.length > 0) {  
    contacts.map(function (contact) {    
      let contactTypeLabel = '';
      if (contact.contactType === 'clientlead') { 
        contactTypeLabel = 'Lead'; 
      } else if (contact.contactType === 'clientsponsor') { 
        contactTypeLabel = 'Sponsor'; 
      } else { 
        return; 
      }

      if (!contact.fullName) {
        validationErrors.push(contactTypeLabel + ' Name is required.');
      }

      if (!contact.orgPosition) {
        validationErrors.push(contactTypeLabel + ' Position is required.');
      }

      if (!contact.email) {
        validationErrors.push(contactTypeLabel + ' Email is required.');
      }

      if (!contact.phoneNumber) {
        validationErrors.push(contactTypeLabel + ' Phone Number is required.');
      }      
    });
  } else {
    validationErrors.push('Contacts not found.');
  }

  return validationErrors;
};

const routerOpts: Router.IRouterOptions = {
  prefix: '/contact'
};

const router: Router = new Router(routerOpts);

router.get('/:id/by-project-id', authorize, getContactByProjectId);
router.patch('/:id', authorize, saveContactAction);
router.patch('/:id/partial', authorize, updateContactActionPartial);

export default router;
