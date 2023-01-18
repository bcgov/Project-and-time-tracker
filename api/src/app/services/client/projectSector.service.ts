import { Repository, getRepository } from 'typeorm';
import { ProjectSector } from '../../models/entities/projectSector.entity';

const projectSectorRepo = (): Repository<ProjectSector> => {
  return getRepository(ProjectSector);
};

export const retrieveProjectSectors = async () => {
  const repo = projectSectorRepo();
  return await repo
    .createQueryBuilder('s')
    .orderBy('s.projectSectorName', 'ASC')
    .getMany();
};

export const retrieveProjectSectorById = async (id: string) => {
  const repo = projectSectorRepo();
  const res = await repo.findOne(id);
  if (!res) {
    throw Error(`projectSector not found for the id specified: ${id}`);
  }
  return res;
};
