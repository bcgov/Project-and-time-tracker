import { ProjectIntakeContacts } from './../../models/entities/projectIntakeContacts.entity';
import { getRepository, Repository } from 'typeorm';
import { IProjectIntakeContact } from '../../models/interfaces/i-project-intake-contact';

const intakeContactRepo = (): Repository<ProjectIntakeContacts> => {
  return getRepository(ProjectIntakeContacts);
};

export const createProjectIntakeContact = async (obj: IProjectIntakeContact | IProjectIntakeContact[]) => {
  if (Array.isArray(obj)) {
    const arr: any = [];
    for (let index = 0; index < obj.length; index++) {
      arr.push(await createProjectIntakeContact(obj[index]));
    }
    return arr;
  }
  
  const intakeContacts: ProjectIntakeContacts = intakeContactRepo().create(obj);
  await intakeContactRepo().save(intakeContacts);
  return intakeContacts;
};

export const updateProjectIntakeContact = async (id: string, fields: any) => {
  const repo = intakeContactRepo();
  const intakeContact: ProjectIntakeContacts = await repo.findOne(id);

  if (!intakeContact) {
    throw Error('intakeContact not found');
  }
  const updatedIntakeContact = await repo.merge(intakeContact, fields);

  await repo.save(updatedIntakeContact);
  return updatedIntakeContact;
};

export const deleteProjectIntakeContact = async (id: string) => {
  const repo = intakeContactRepo();
  const intakeContact = await repo.findOne(id);

  if (!intakeContact) {
    throw Error('intakeContact not found');
  }
  return await repo.delete(intakeContact);
};

export const retrieveProjectIntakeContactById = async (id: string | string[]) => {
  const repo = intakeContactRepo();
  if (Array.isArray(id)) {
    const arr: any = [];
    for (let index = 0; index < id.length; index++) {
      arr.push(await retrieveProjectIntakeContactById(id[index]));
    }
    return arr;
  }
  const res = await repo.findOne(id);
  if (!res) {
    throw Error(`intakeContact not found for the id specified: ${id}`);
  }
  return res;
};

export const retrieveIntakeContactByIntakeId = async (id: string) => {
  const repo = intakeContactRepo();
  
  const res = await repo
                      .createQueryBuilder('ic')
                      .innerJoinAndSelect('ic.contact', 'c')
                      .where('ic."projectIntakeId" = :id', { id: id })
                      .getMany();
  if (!res) {
    throw Error(`intakeContact not found for the id specified: ${id}`);
  }
  return res;
};

export const retrieveProjectIntakeContacts = async () => {
  const repo = intakeContactRepo();
  return await repo.find();
};
