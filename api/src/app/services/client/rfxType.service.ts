import { RfxType } from '../../models/entities/rfxType.entity';
import { getRepository, Repository } from 'typeorm';

const rfxTypeRepo = (): Repository<RfxType> => {
  return getRepository(RfxType);
};
  
export const  retrieveRfxTypes = async () => {
  const repo = rfxTypeRepo();
  return await repo.find();
};

export const retrieveRfxTypeById = async (id: string) => {
  const repo = rfxTypeRepo();
  const res = await repo.findOne(id);
  if (!res) {
    throw Error(`rfxType not found for the id specified: ${id}`);
  }
  return res;
};
