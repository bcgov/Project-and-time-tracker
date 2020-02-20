import { Repository, getRepository } from 'typeorm';
import { Ministry } from '../../models/entities/ministry.entity';

const ministryRepo = (): Repository<Ministry> => {
  return getRepository(Ministry);
};

export const retrieveMinistries = async () => {
  const repo = ministryRepo();
  return await repo.find();
  // TODO - MODIFY SO THAT IS_ARCHIVE=FALSE
  // return await repo.createQueryBuilder('m')
  //                   // .where("m.is_archived = NULL", { val: null })
  //                   .getMany();
};

// Working but not fully wired up yet
export const retrieveArchivedMinistries = async () => {
  const repo = ministryRepo();
  return await repo.createQueryBuilder('m')
    .where("m.is_archived = :val", { val: true })
    .getMany();
};

export const retrieveMinistryById = async (id: string) => {
  const repo = ministryRepo();
  const res = await repo.findOne(id);
  if (!res) {
    throw Error(`ministry not found for the id specified: ${id}`);
  }
  return res;
};

export const createMinistry = async obj => {
  const repo = ministryRepo();
  const ministry = repo.create(obj);
  const ret = await repo.save(ministry);
  if (!ret) {
    throw Error('no object inserted');
  }
  return ret;
};

export const updateMinistry = async (input: Ministry) => {
  const repo = ministryRepo();
  const ministry: Ministry = await repo.findOne(input.id)

  if (!ministry){
    throw Error('Ministry not found');
  }

  const updatedMinistry = await repo.save(input);
  return updatedMinistry;
}
