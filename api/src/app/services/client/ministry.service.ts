import { Repository, getRepository, IsNull } from 'typeorm';
import { Ministry } from '../../models/entities/ministry.entity';

const ministryRepo = (): Repository<Ministry> => {
  return getRepository(Ministry);
};

// Excludes archived
export const retrieveMinistries = async () => {
  const repo = ministryRepo();
  return await repo
    .createQueryBuilder('m')
    .orderBy('m.ministryName', 'ASC')
    .where('m.is_archived IS NULL OR m.is_archived = :val', { val: false })
    .getMany();
};

// Both archived and unarchived
export const retrieveAllMinistries = async () => {
  const repo = ministryRepo();
  return repo.find();
};

export const retrieveMinistryById = async (id: string) => {
  const repo = ministryRepo();
  const res = await repo.findOne(id);
  if (!res) {
    throw Error(`ministry not found for the id specified: ${id}`);
  }
  return res;
};

export const createMinistry = async (obj) => {
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
  const ministry: Ministry = await repo.findOne(input.id);

  if (!ministry) {
    throw Error('Ministry not found');
  }

  const updatedMinistry = await repo.save(input);
  return updatedMinistry;
};
