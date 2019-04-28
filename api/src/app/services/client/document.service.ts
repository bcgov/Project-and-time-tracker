import { Document } from './../../models/entities/document.entity';
import * as Koa from 'koa';
import { getRepository, Repository } from 'typeorm';
import * as HttpStatus from 'http-status-codes';

export const getDocuments = async (ctx: Koa.Context) => {
  const documentRepo: Repository<Document> = getRepository(Document);
  const documents = await documentRepo.find();

  ctx.body = {
    data: { documents },
  };
};

export const getDocumentById = async (ctx: Koa.Context) => {
  const documentRepo: Repository<Document> = getRepository(Document);

  const document = await documentRepo.findOne(ctx.params.document_id);

  if (!document) {
    ctx.throw(HttpStatus.NOT_FOUND);
  }

  ctx.body = {
    data: { document },
  };
};

export const createDocument = async (ctx: Koa.Context) => {
  const documentRepo: Repository<Document> = getRepository(Document);

  const data = ctx.request.body;
  if (!data) {
    return 'No Data Found';
  }
  const document: Document = documentRepo.create(ctx.request.body) as any;

  await documentRepo.save(document);
  ctx.body = {
    data: { document },
  };
};

export const deleteDocument = async (ctx: Koa.Context) => {
  const documentRepo: Repository<Document> = getRepository(Document);

  const document = await documentRepo.findOne(ctx.params.document_id);

  if (!document) {
    ctx.throw(HttpStatus.NOT_FOUND);
  }

  await documentRepo.delete(document);

  ctx.status = HttpStatus.NO_CONTENT;
};

export const updateDocument = async (ctx: Koa.Context) => {
  const documentRepo: Repository<Document> = getRepository(Document);

  const document: Document = await documentRepo.findOne(ctx.params.document_id);

  if (!document) {
    ctx.throw(HttpStatus.NOT_FOUND);
  }

  const updatedDocument = await documentRepo.merge(document, ctx.request.body);

  documentRepo.save(updatedDocument);

  ctx.body = {
    data: { document: updatedDocument },
  };
};
