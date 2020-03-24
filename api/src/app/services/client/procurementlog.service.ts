import { getRepository, Repository } from 'typeorm';
import { IProcurement } from '../../models/interfaces/i-procurement';
import { ProcurementLog } from '../../models/entities/procurement.entity';
import { Project } from '../../models/entities';

const procurementLogRepo = (): Repository<ProcurementLog> => {
  return getRepository(ProcurementLog);
};

export const createProcurementLog = async (obj: IProcurement) => {
  const procurement: ProcurementLog = procurementLogRepo().create(obj);
  await procurementLogRepo().save(procurement);
  return procurement;
};

export const retrieveAllProcurementLog = async () => {
  const repo = procurementLogRepo();
  return await repo
    .createQueryBuilder('p')
    .getMany();
};
// export const updateContact = async (id: string, fields: any) => {
//   const repo = contactRepo();
//   const contact: Contact = await repo.findOne(id);

//   if (!contact) {
//     throw Error('contact not found');
//   }
//   const updatedContact = await repo.merge(contact, fields);
//   updatedContact.dateModified = new Date();

//   await repo.save(updatedContact);
//   return updatedContact;
// };

// export const deleteContact = async (id: string) => {
//   const repo = contactRepo();
//   const contact = await repo.findOne(id);

//   if (!contact) {
//     throw Error('contact not found');
//   }
//   return await repo.delete(contact);
// };

// export const retrieveContactById = async (id: string | string[]) => {
//   const repo = contactRepo();
//   if (Array.isArray(id)) {
//     const arr: any = [];
//     for (let index = 0; index < id.length; index++) {
//       arr.push(await retrieveContactById(id[index]));      
//     }
//     return arr;
//   }
//   const res = await repo.findOne(id);
//   if (!res) {
//     throw Error(`contact not found for the id specified: ${id}`);
//   }
//   return res;
// };
export const updateProcLog = async (id: string, fields: any) => {
  const repo = procurementLogRepo();
  const proclog: ProcurementLog = await repo.findOne(id);

  if (!proclog) {
    throw Error('procurement log not found');
  }
  const updatedIntake = await repo.merge(proclog, fields);
  // updatedIntake.dateModified = new Date();

  await repo.save(updatedIntake);
  return updatedIntake;
};

export const retrieveProcurementLogsByProjectId = async (id: string) => {
  const repo = procurementLogRepo();
  const res = await repo
    .createQueryBuilder('pl')
    .leftJoinAndSelect(Project, 'p', 'p."id" = pl.projectId')
    .where('pl."projectId" = :id', { id: id })
    .getMany();
  if (!res) {
    throw Error(`contact not found for the id specified: ${id}`);
  }
  return res;
};

// export const retrieveContacts = async () => {
//   const repo = contactRepo();
//   const res = await repo.find();
//   if (!res) {
//     throw Error('no contacts found');
//   }
//   return res;
// };
