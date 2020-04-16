import { getRepository, Repository } from 'typeorm';
import { Project } from '../../models/entities';
import { Client } from '../../models/entities';
import { IProject } from '../../models/interfaces/i-project';
import { IClient } from '../../models/interfaces/i-client';

const projectRepo = (): Repository<Project> => {
  return getRepository(Project);
};

const clientRepo = (): Repository<Client> => {
  return getRepository(Client);
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

export const updateProject = async (
  id: string,
  fields: any,
  clientFilds: any = null
) => {
  const repo = projectRepo();
  const project: Project = await repo.findOne(id);

  if (!project) {
    throw Error('project not found');
  }
  const updatedProject = await repo.merge(project, fields);
  updatedProject.dateModified = new Date();

  await repo.save(updatedProject);
  if (clientFilds) {
    const repoClient = clientRepo();
    const client: Client = await repoClient.findOne(clientFilds.id);

    if (!client) {
      throw Error('client not found');
    }
    const updatedClient = await repoClient.merge(client, clientFilds);
    updatedClient.dateModified = new Date();

    await repoClient.save(updatedClient);
  }
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
    .leftJoinAndSelect('c.ministry', 'm')
    .leftJoinAndSelect('p.mou', 'o')
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
    .leftJoin('c.ministry', 'm')
    .leftJoinAndSelect('p.mou', 'o')
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
      'o.name',
      'o.id',
      'p.isReprocurement',
      'c.isNonMinistry',
      'p.dateOfReprocurement',
      'p.previousContractBackground',
      'p.projectFailImpact',
      'p.projectSuccess',
      'p.otherProjectSectorName',
      'c.nonMinistryName',
      'p.mouAmount',
      'p.teamWideProject'
    ])
    .where('p.is_archived IS NULL OR p.is_archived = :is_archived', {
      is_archived: false
    })
    .getMany();
};

export const retrieveArchivedProjects = async () => {
  const repo = projectRepo();
  return await repo
    .createQueryBuilder('p')
    .innerJoin('p.client', 'c')
    .innerJoin('c.ministry', 'm')
    .leftJoinAndSelect('p.mou', 'o')
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
      'p.isReprocurement',
      'p.isMinistry',
      'p.dateOfReprocurement',
      'p.previousContractBackground',
      'p.projectFailImpact',
      'p.projectSuccess',
      'p.otherProjectSectorName',
      'o.name',
      'p.teamWideProject'
    ])
    .where('p.is_archived = :is_archived', { is_archived: true })
    .getMany();
};

export const retrieveAllProjects = async () => {
  const repo = projectRepo();
  return await repo
    .createQueryBuilder('p')
    .innerJoin('p.client', 'c')
    .leftJoin('c.ministry', 'm')
    .leftJoinAndSelect('p.mou', 'o')
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
      'o.name',
      'o.id',
      'p.isReprocurement',
      'c.isNonMinistry',
      'p.dateOfReprocurement',
      'p.previousContractBackground',
      'p.projectFailImpact',
      'p.projectSuccess',
      'p.otherProjectSectorName',
      'c.nonMinistryName',
      'p.mouAmount',
      'p.teamWideProject'
    ])
    .where('(p.is_archived IS NULL OR p.is_archived = :is_archived)', {
      is_archived: false
    })
    .getMany();
};
export const retrieveProjectsByUserId = async (userId: string) => {
  const repo = projectRepo();
  return await repo
    .createQueryBuilder('p')
    .innerJoin('p.client', 'c')
    .leftJoin('c.ministry', 'm')
    .leftJoinAndSelect('p.mou', 'o')
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
      'o.name',
      'o.id',
      'p.isReprocurement',
      'c.isNonMinistry',
      'p.dateOfReprocurement',
      'p.previousContractBackground',
      'p.projectFailImpact',
      'p.projectSuccess',
      'p.otherProjectSectorName',
      'c.nonMinistryName',
      'p.teamWideProject'
    ])
    .where(
      '(p.is_archived IS NULL OR p.is_archived = :is_archived) AND (p."leadUserId" = :userId OR p."backupUserId" = :userId)',
      {
        is_archived: false,
        userId
      }
    )
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
      'ps',
      'p.dateModified',
      'p.completionDate',
      'c.orgDivision',
      'm.ministryName',
      'p.leadUserId',
      'p.backupUserId',
      'p.mouAmount',
      'p.isReprocurement',
      'p.isMinistry',
      'p.dateOfReprocurement',
      'p.previousContractBackground',
      'p.projectFailImpact',
      'p.projectSuccess',
      'p.otherProjectSectorName',
      'p.teamWideProject'
    ])

    //   From merge conflict, this line replaced below
    //     .where('p."leadUserId" = :userId OR p."backupUserId" = :userId', {
    //       userId: userId
    //     })
    .where(
      'p."is_archived" = :is_archived, {is_archived : true}) AND p."leadUserId" = :userId OR p."backupUserId" = :userId',
      { userId: userId }
    )
    .getMany();
};
