import { getRepository, Repository } from 'typeorm';
import { Project } from '../../models/entities';
import { IProject } from '../../models/interfaces/i-project';

const projectRepo = (): Repository<Project> => {
  return getRepository(Project);
};

export const createProject = async (obj: IProject | IProject[]) => {
  if (Array.isArray(obj)) {
    const arr: any = [];
    for (let index = 0; index < obj.length; index++) {
      arr.push(await createProject(obj[index]));
    }
    return arr;
  }

  const project: Project = projectRepo().create(obj);
  project.dateCreated = new Date();
  project.dateModified = new Date();
  await projectRepo().save(project);
  return project;
};

export const updateProject = async (id: string, fields: any) => {
  const repo = projectRepo();
  const project: Project = await repo.findOne(id);

  if (!project) {
    throw Error('project not found');
  }
  const updatedProject = await repo.merge(project, fields);
  updatedProject.dateModified = new Date();

  await repo.save(updatedProject);
  return updatedProject;
};

export const deleteProject = async (id: string) => {
  const repo = projectRepo();
  const project = await repo.findOne(id);

  if (!project) {
    throw Error('project not found');
  }
  return await repo.delete(project);
};

export const retrieveProjectById = async (id: string | string[]) => {
  const repo = projectRepo();
  if (Array.isArray(id)) {
    const arr: any = [];
    for (let index = 0; index < id.length; index++) {
      arr.push(await retrieveProjectById(id[index]));
    }
    return arr;
  }
  const res = await repo
    .createQueryBuilder('p')
    .innerJoinAndSelect('p.client', 'c')
    .innerJoinAndSelect('c.ministry', 'm')
    .where('p.id = :id', { id: id })
    .getOne();
  if (!res) {
    throw Error(`project not found for the id specified: ${id}`);
  }
  return res;
};

export const retrieveProjects = async () => {
  const repo = projectRepo();
  return await repo
    .createQueryBuilder('p')
    .innerJoin('p.client', 'c')
    .innerJoin('c.ministry', 'm')
    .innerJoin('p.projectSector', 'ps')
    .orderBy('p.dateModified', 'DESC')
    .select([
      'p.id',
      'p.projectName',
      'ps',
      'p.dateModified',
      'p.completionDate',
      'c.orgDivision',
      'm.ministryName',
      'p.leadUserId',
      'p.backupUserId',
      'p.mouAmount'
    ])
    .where('p.is_archived = :is_archived', {is_archived : false})
    .getMany();
};

export const retrieveArchivedProjects = async () => {
  const repo = projectRepo();
  return await repo
    .createQueryBuilder('p')
    .innerJoin('p.client', 'c')
    .innerJoin('c.ministry', 'm')
    .innerJoin('p.projectSector', 'ps')
    .orderBy('p.dateModified', 'DESC')
    .select([
      'p.id',
      'p.projectName',
      'ps',
      'p.dateModified',
      'p.completionDate',
      'c.orgDivision',
      'm.ministryName',
      'p.leadUserId',
      'p.backupUserId',
      'p.mouAmount',
    ])
    .where('p.is_archived = :is_archived', {is_archived : true})
    .getMany();
};

export const retrieveProjectsByUserId = async (userId: string) => {
  const repo = projectRepo();
  return await repo
    .createQueryBuilder('p')
    .innerJoin('p.client', 'c')
    .innerJoin('c.ministry', 'm')
    .innerJoin('p.user','u')
    .innerJoin('c.contact','uc')
    .innerJoin('p.projectSector', 'ps')
    .select([
      'p.id',
      'p.projectName',
      'ps',
      'p.dateModified',
      'u.id',
      'uc.fullName',
      'p.completionDate',
      'c.orgDivision',
      'm.ministryName',      
      'p.leadUserId',
      'p.backupUserId',
      'p.mouAmount',
    ])
    .where('p."is_archived" = :is_archived, {is_archived : false}) AND p."leadUserId" = :userId OR p."backupUserId" = :userId', { userId: userId })
    .getMany();
};
export const retrieveArchivedProjectsByUserId = async (userId: string) => {
  const repo = projectRepo();
  return await repo
    .createQueryBuilder('p')
    .innerJoin('p.client', 'c')
    .innerJoin('c.ministry', 'm')
    .innerJoin('p.projectSector', 'ps')
    .select([
      'p.id',
      'p.projectName',
      'ps', 'p.dateModified',
      'p.completionDate',
      'c.orgDivision',
      'm.ministryName',
      'p.leadUserId',
      'p.backupUserId',
      'p.mouAmount'
    ])

//   From merge conflict, this line replaced below
//     .where('p."leadUserId" = :userId OR p."backupUserId" = :userId', {
//       userId: userId
//     })
    .where('p."is_archived" = :is_archived, {is_archived : true}) AND p."leadUserId" = :userId OR p."backupUserId" = :userId', { userId: userId })
    .getMany();
};
