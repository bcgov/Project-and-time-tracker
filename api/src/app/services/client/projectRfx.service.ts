import { ProjectRfx } from './../../models/entities/projectRfx.entity';
import { getRepository, Repository } from 'typeorm';
import { IProjectRfx } from '../../models/interfaces/i-project-rfx';

const projectRfxRepo = (): Repository<ProjectRfx> => {
  return getRepository(ProjectRfx);
};

export const createProjectRfx = async (obj: IProjectRfx | IProjectRfx[]) => {
  if (Array.isArray(obj)) {
    const arr: any = [];
    for (let index = 0; index < obj.length; index++) {
      arr.push(await createProjectRfx(obj[index]));
    }
    return arr;
  }
  
  const projectRfx: ProjectRfx = projectRfxRepo().create(obj);
  projectRfx.dateCreated = new Date();
  projectRfx.dateModified = new Date();
  await projectRfxRepo().save(projectRfx);
  return projectRfx;
};

export const updateProjectRfx = async (id: string, fields: any) => {
  const repo = projectRfxRepo();
  const projectRfx: ProjectRfx = await repo.findOne(id);

  if (!projectRfx) {
    throw Error('projectRfx not found');
  }
  const updatedProjectRfx = await repo.merge(projectRfx, fields);
  updatedProjectRfx.dateModified = new Date();

  await repo.save(updatedProjectRfx);
  return updatedProjectRfx;
};

export const deleteProjectRfx = async (id: string) => {
  const repo = projectRfxRepo();
  const projectRfx = await repo.findOne(id);

  if (!projectRfx) {
    throw Error('projectRfx not found');
  }
  return await repo.delete(projectRfx);
};

export const retrieveProjectRfxById = async (id: string | string[]) => {
  const repo = projectRfxRepo();
  if (Array.isArray(id)) {
    const arr: any = [];
    for (let index = 0; index < id.length; index++) {
      arr.push(await retrieveProjectRfxById(id[index]));
    }
    return arr;
  }
  const res = await repo.findOne(id);
  if (!res) {
    throw Error(`projectRfx not found for the id specified: ${id}`);
  }
  return res;
};

export const retrieveProjectRfxByProjectId = async (id: string) => {
  const repo = projectRfxRepo();
  
  const res = await repo
                      .createQueryBuilder('pr')
                      .where('pr."projectId" = :id', { id: id })
                      .innerJoinAndSelect('pr.rfxPhase', 'rp')
                      .innerJoinAndSelect('pr.rfxType', 'rt')
                      .getMany();
  return res;
};

export const retrieveProjectRfxs = async () => {
  const repo = projectRfxRepo();
  return await repo.find();
};
