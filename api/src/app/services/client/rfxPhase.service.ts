import { RfxPhase } from '../../models/entities/rfxPhase.entity';
import { getRepository, Repository } from 'typeorm';
import { IRfxPhase } from '../../models/interfaces';
import { IProjectRfx } from '../../models/interfaces';
import { ProjectRfx } from '../../models/entities/projectRfx.entity';

const rfxPhaseRepo = (): Repository<RfxPhase> => {
  return getRepository(RfxPhase);
};
const projectRfxRepo = (): Repository<ProjectRfx> => {
  return getRepository(ProjectRfx);
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

export const createRfxPhase = async (obj: IRfxPhase) => {
  const rfxPhase: RfxPhase = rfxPhaseRepo().create(obj);
  await rfxPhaseRepo().save(rfxPhase);
  return rfxPhase;
};

export const deleteRfxPhase = async (id: string) => {
  const repo = rfxPhaseRepo();
  const rfxPhase = await repo.findOne(id);
  if (!rfxPhase) {
    throw Error('Rfx Phase not Found');
  }
  return await repo.delete(rfxPhase);
};

export const checkRfxUsage = async (id: string) => {
  const repoProjectRfx = projectRfxRepo();
  const resProjectRfx = await repoProjectRfx
    .createQueryBuilder('pr')
    .innerJoinAndSelect('pr.rfxPhase', 'rp')
    .where('rp."id" = :id', { id: id })
    .getMany();

  if (resProjectRfx && resProjectRfx.length == 0) return false;
  return true;
};

export const updateRfxPhase = async (id: string, fields: any) => {
  const repo = rfxPhaseRepo();
  const rfxPhase: RfxPhase = await repo.findOne(id);

  if (!rfxPhase) {
    throw Error('Rfx Phase not found');
  }
  const updatedRfxPhase = await repo.merge(rfxPhase, fields);
  await repo.save(updatedRfxPhase);
  return updatedRfxPhase;
};
