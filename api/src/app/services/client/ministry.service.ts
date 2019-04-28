import { Repository, getRepository } from 'typeorm';
import { Ministry } from '../../models/entities/ministry.entity';

const ministryRepo = (): Repository<Ministry> => {
  return getRepository(Ministry);
};

export const retrieveMinistries = async () => {
  const repo = ministryRepo();
  return await repo.find();
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
