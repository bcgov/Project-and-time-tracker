import { RfxPhase } from '../../models/entities/rfxPhase.entity';
import { getRepository, Repository } from 'typeorm';

const rfxPhaseRepo = (): Repository<RfxPhase> => {
  return getRepository(RfxPhase);
};

export const retrieveRfxPhases = async () => {
  const repo = rfxPhaseRepo();
  return await repo.createQueryBuilder('r').getMany();
};

export const retrieveRfxPhaseById = async (id: string) => {
  const repo = rfxPhaseRepo();
  const res = await repo.findOne(id);
  if (!res) {
    throw Error(`rfxPhase not found for the id specified: ${id}`);
  }
  return res;
};
