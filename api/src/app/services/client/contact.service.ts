import { Contact } from './../../models/entities/contact.entity';
import { getRepository, Repository } from 'typeorm';
import { IContact } from '../../models/interfaces/i-contact';
import { ProjectContacts } from '../../models/entities/projectContacts.entity';

const contactRepo = (): Repository<Contact> => {
  return getRepository(Contact);
};

export const createContact = async (obj: IContact | IContact[]) => {
  if (Array.isArray(obj)) {
    const arr: any = [];
    for (let index = 0; index < obj.length; index++) {
      arr.push(await createContact(obj[index]));
    }
    return arr;
  }
  
  const contact: Contact = contactRepo().create(obj);
  contact.dateCreated = new Date();
  contact.dateModified = new Date();
  await contactRepo().save(contact);
  return contact;
};

export const updateContact = async (id: string, fields: any) => {
  const repo = contactRepo();
  const contact: Contact = await repo.findOne(id);

  if (!contact) {
    throw Error('contact not found');
  }
  const updatedContact = await repo.merge(contact, fields);
  updatedContact.dateModified = new Date();

  await repo.save(updatedContact);
  return updatedContact;
};

export const deleteContact = async (id: string) => {
  const repo = contactRepo();
  const contact = await repo.findOne(id);

  if (!contact) {
    throw Error('contact not found');
  }
  return await repo.delete(contact);
};

export const retrieveContactById = async (id: string | string[]) => {
  const repo = contactRepo();
  if (Array.isArray(id)) {
    const arr: any = [];
    for (let index = 0; index < id.length; index++) {
      arr.push(await retrieveContactById(id[index]));      
    }
    return arr;
  }
  const res = await repo.findOne(id);
  if (!res) {
    throw Error(`contact not found for the id specified: ${id}`);
  }
  return res;
};

export const retrieveContactByProjectId = async (id: string) => {
  const repo = contactRepo();
  const res = await repo
    .createQueryBuilder('c')
    .leftJoinAndSelect(ProjectContacts, 'pc', 'pc."contactId" = c.id')
    .where('pc."projectId" = :id', { id: id })
    .getMany();
  if (!res) {
    throw Error(`contact not found for the id specified: ${id}`);
  }
  return res;
};

export const retrieveContacts = async () => {
  const repo = contactRepo();
  const res = await repo.find();
  if (!res) {
    throw Error('no contacts found');
  }
  return res;
};
