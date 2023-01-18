import { Client } from './../../models/entities/client.entity';
import { getRepository, Repository } from 'typeorm';
import { IClient } from '../../models/interfaces/i-client';
import { Project } from '../../models/entities/project.entity';

const clientRepo = (): Repository<Client> => {
  return getRepository(Client);
};

export const createClient = async (obj: IClient | IClient[]) => {
  if (Array.isArray(obj)) {
    const arr: any = [];
    for (let index = 0; index < obj.length; index++) {
      arr.push(await createClient(obj[index]));      
    }
    return arr;
  }

  const client: Client = clientRepo().create(obj);
  client.dateCreated = new Date();
  client.dateModified = new Date();
  await clientRepo().save(client);
  return client;
};

export const updateClient = async (id: string, fields: any) => {
  const repo = clientRepo();
  const client: Client = await repo.findOne(id);

  if (!client) {
    throw Error('client not found');
  }
  const updatedClient = await repo.merge(client, fields);
  updatedClient.dateModified = new Date();

  await repo.save(updatedClient);
  return updatedClient;
};

export const deleteClient = async (id: string) => {
  const repo = clientRepo();
  const client = await repo.findOne(id);

  if (!client) {
    throw Error('client not found');
  }
  return await repo.delete(client);
};

export const retrieveClientById = async (id: string | string[]) => {
  const repo = clientRepo();
  if (Array.isArray(id)) {
    const arr: any = [];
    for (let index = 0; index < id.length; index++) {
      arr.push(await retrieveClientById(id[index]));      
    }
    return arr;
  }
  const res = await repo.findOne(id);
  if (!res) {
    throw Error(`client not found for the id specified: ${id}`);
  }
  return res;
};

export const retrieveClientByProjectId = async (id: string) => {
  const repo = clientRepo();
  const res = await repo
    .createQueryBuilder('c')
    .leftJoinAndSelect(Project, 'p', 'p."clientId" = c.id')
    .where('p.id = :id', { id: id })
    .getOne();
  if (!res) { 
    throw Error(`client not found for the id specified: ${id}`);
  }
  return res;
};

export const retrieveClients = async () => {
  const repo = clientRepo();
  return await repo.find();
};

export const validateFinanceCodes = (client: IClient) => {
  
  const validationErrors = [];

  // Business validation: Start.
  if (client.clientNo?.toString().length !== 3) {
    validationErrors.push('Client No should be exactly 3 characters.');
  }
  if (client.responsibilityCenter?.toString().length !== 5) {
    validationErrors.push('Responsibility Center should be exactly 5 characters.');
  }
  if (client.serviceCenter?.toString().length !== 5) {
    validationErrors.push('Service Center should be exactly 5 characters.');
  }
  if (client.stob?.toString().length !== 4) {
    validationErrors.push('STOB should be exactly 4 characters.');
  }
  if (client.projectCode?.toString().length !== 7) {
    validationErrors.push('Project Code should be exactly 7 characters.');
  }
  // Business validation: End.

  return validationErrors;
};
