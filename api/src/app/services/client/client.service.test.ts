import { IMinistry } from './../../models/interfaces/i-ministry';
import { IClient } from './../../models/interfaces/i-client';
import databaseConnection from './../../database/database.connection';
import IntakeData from '../../utility/mocks/intake-data';
import {
  createClient,
  retrieveClientById,
  updateClient,
  deleteClient
} from './client.service';
import { retrieveMinistries } from './ministry.service';
const request = require('supertest');
import { expect } from 'chai';
import { describe } from 'mocha';

let clients: IClient[];

describe('client.service.ts', function() {
  this.enableTimeouts(false);

  before(async () => {
    await databaseConnection;
    const ministries: IMinistry[] = await retrieveMinistries();
    clients = [IntakeData.genClients(ministries[0])];
  });

  it('should create a new client record', async () => {
    try {
      const res = await createClient(clients[0]);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });

  it('should get client record', async () => {
    try {
      const res = await retrieveClientById(clients[0].id);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });

  it('should update client record', async () => {
    try {
      const res = await updateClient(clients[0].id, {
        city: 'abc'
      });
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });

  it('should delete client record', async () => {
    try {
      const res = await deleteClient(clients[0].id);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });
});
