import { IMinistry } from './../../models/interfaces/i-ministry';
import databaseConnection from './../../database/database.connection';
import {
    retrieveMinistries,
    retrieveMinistryById
} from './ministry.service';
const request = require('supertest');
import { expect } from 'chai';
import { describe } from 'mocha';

let ministry: IMinistry;

describe('ministry.service.ts', function() {
  this.enableTimeouts(false);

  before(async () => {
    await databaseConnection;
  });

  it('should get all ministry record', async () => {
    try {
      const res: IMinistry[] = await retrieveMinistries();
      ministry = res[0];
      expect(res).to.a('array');
    } catch (err) {
      throw err;
    }
  });

  it('should get ministry record', async () => {
    try {
      const res: IMinistry = await retrieveMinistryById(ministry.id);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });
});
