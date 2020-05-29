import { RfxType } from '../../models/entities/rfxType.entity';
import { getRepository, Repository } from 'typeorm';
import { IRfxType } from '../../models/interfaces';
import { ProjectRfx } from '../../models/entities/projectRfx.entity';

const projectRfxRepo = (): Repository<ProjectRfx> => {
  return getRepository(ProjectRfx);
};
const rfxTypeRepo = (): Repository<RfxType> => {
  return getRepository(RfxType);
};

export const retrieveRfxTypes = async () => {
  const repo = rfxTypeRepo();
  return await repo
    .createQueryBuilder('r')
    .orderBy('r.rfxTypeName', 'ASC')
    .getMany();
};

export const retrieveRfxTypeById = async (id: string) => {
  const repo = rfxTypeRepo();
  const res = await repo.findOne(id);
  if (!res) {
    throw Error(`rfxType not found for the id specified: ${id}`);
  }
  return res;
};
export const createRfxType = async (obj: IRfxType) => {
  const rfxType: RfxType = rfxTypeRepo().create(obj);
  await rfxTypeRepo().save(rfxType);
  return rfxType;
};

export const deleteRfxType = async (id: string) => {
  const repo = rfxTypeRepo();
  const rfxType = await repo.findOne(id);

  if (!rfxType) {
    throw Error('Rfx Type not Found');
  }
  return await repo.delete(rfxType);
};

export const checkRfxUsage = async (id: string) => {
  const repoProjectRfx = projectRfxRepo();
  const resProjectRfx = await repoProjectRfx
    .createQueryBuilder('pr')
    .innerJoinAndSelect('pr.rfxType', 'rt')
    .where('rt."id" = :id', { id: id })
    .getMany();

  if (resProjectRfx && resProjectRfx.length == 0) return false;
  return true;
};
export const updateRfxType = async (id: string, fields: any) => {
  const repo = rfxTypeRepo();
  const rfxType: RfxType = await repo.findOne(id);

  if (!rfxType) {
    throw Error('Rfx type not found');
  }
  const updatedrfxType = await repo.merge(rfxType, fields);
  await repo.save(updatedrfxType);
  return updatedrfxType;
};
