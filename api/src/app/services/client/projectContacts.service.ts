import { ProjectContacts } from './../../models/entities/projectContacts.entity';
import { getRepository, Repository } from 'typeorm';
import { IProjectContact } from '../../models/interfaces/i-project-contact';

const projectContactRepo = (): Repository<ProjectContacts> => {
  return getRepository(ProjectContacts);
};

export const createProjectContact = async (obj: IProjectContact | IProjectContact[]) => {
  if (Array.isArray(obj)) {
    const arr: any = [];
    for (let index = 0; index < obj.length; index++) {
      arr.push(await createProjectContact(obj));
    }
    return arr;
  }
  
  const projectContacts: ProjectContacts = projectContactRepo().create(obj);
  await projectContactRepo().save(projectContacts);
  return projectContacts;
};

export const updateProjectContact = async (id: string, fields: any) => {
  const repo = projectContactRepo();
  const projectContact: ProjectContacts = await repo.findOne(id);

  if (!projectContact) {
    throw Error('projectContact not found');
  }
  const updatedProjectContact = await repo.merge(projectContact, fields);

  await repo.save(updatedProjectContact);
  return updatedProjectContact;
};

export const deleteProjectContact = async (id: string) => {
  const repo = projectContactRepo();
  const projectContact = await repo.findOne(id);

  if (!projectContact) {
    throw Error('projectContact not found');
  }

  return await repo.delete(projectContact);
};

export const retrieveProjectContactById = async (id: string | string[]) => {
  const repo = projectContactRepo();
  if (Array.isArray(id)) {
    const arr: any = [];
    for (let index = 0; index < id.length; index++) {
      arr.push(await retrieveProjectContactById(id[index]));
    }
    return arr;
  }
  const res = await repo.findOne(id);
  if (!res) {
    throw Error(`projectContact not found for the id specified: ${id}`);
  }
  return res;
};

export const retrieveProjectContacts = async () => {
  const repo = projectContactRepo();
  return await repo.find();
};

export const retrieveProjectContactsByProjectId = async (id: string) => {
  const repo = projectContactRepo();
  return await repo.find({
    where: {
      project: {id}
    }
  });
};
export const retrieveProjectContactsByContactId = async (id: string) => {
  const repo = projectContactRepo();
  return await repo.find({
    where: {
      contact: {id}
    }
  });
};
