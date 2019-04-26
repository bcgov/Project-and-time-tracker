import { ProjectDocuments } from './../../models/entities/projectDocuments.entity';
import * as Koa from 'koa';
import { getRepository, Repository } from 'typeorm';
import * as HttpStatus from 'http-status-codes';

export const getProjectDocuments = async (ctx: Koa.Context) => {
  const projectDocumentsRepo: Repository<ProjectDocuments> = getRepository(ProjectDocuments);
  const projectDocuments = await projectDocumentsRepo.find();

  ctx.body = {
    data: { projectDocuments },
  };
};

export const getProjectDocumentsById = async (ctx: Koa.Context) => {
  const projectDocumentsRepo: Repository<ProjectDocuments> = getRepository(ProjectDocuments);

  const projectDocuments = await projectDocumentsRepo.findOne(ctx.params.projectDocuments_id);

  if (!projectDocuments) {
    ctx.throw(HttpStatus.NOT_FOUND);
  }

  ctx.body = {
    data: { projectDocuments },
  };
};

export const createProjectDocuments = async (ctx: Koa.Context) => {
  const projectDocumentsRepo: Repository<ProjectDocuments> = getRepository(ProjectDocuments);

  const data = ctx.request.body;
  if (!data) {
    return 'No Data Found';
  }
  const projectDocuments: ProjectDocuments = projectDocumentsRepo.create(ctx.request.body) as any;

  await projectDocumentsRepo.save(projectDocuments);
  ctx.body = {
    data: { projectDocuments },
  };
};

export const deleteProjectDocuments = async (ctx: Koa.Context) => {
  const projectDocumentsRepo: Repository<ProjectDocuments> = getRepository(ProjectDocuments);

  const projectDocuments = await projectDocumentsRepo.findOne(ctx.params.projectDocuments_id);

  if (!projectDocuments) {
    ctx.throw(HttpStatus.NOT_FOUND);
  }

  await projectDocumentsRepo.delete(projectDocuments);

  ctx.status = HttpStatus.NO_CONTENT;
};

export const updateProjectDocuments = async (ctx: Koa.Context) => {
  const projectDocumentsRepo: Repository<ProjectDocuments> = getRepository(ProjectDocuments);

  const projectDocuments: ProjectDocuments = await projectDocumentsRepo.findOne(ctx.params.projectDocuments_id);

  if (!projectDocuments) {
    ctx.throw(HttpStatus.NOT_FOUND);
  }

  const updatedProjectDocuments = await projectDocumentsRepo.merge(projectDocuments, ctx.request.body);

  projectDocumentsRepo.save(updatedProjectDocuments);

  ctx.body = {
    data: { projectDocuments: updatedProjectDocuments },
  };
};
