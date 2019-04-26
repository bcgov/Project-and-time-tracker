import { IProjectSector } from './../../models/interfaces/i-project-sector';
import { IClient } from './../../models/interfaces/i-client';
import { IProjectIntake } from './../../models/interfaces/i-project-intake';
import { IContact } from './../../models/interfaces/i-contact';
import databaseConnection from './../../database/database.connection';
import IntakeData from '../../utility/mocks/intake-data';
import {
  createIntake,
  retrieveIntakeById,
  updateIntake,
  deleteIntake
} from './intake.service';
import { expect } from 'chai';
import { describe } from 'mocha';
import { createClient } from './client.service';
import { retrieveMinistries } from './ministry.service';
import { retrieveProjectSectors } from './projectSector.service';
import { IMinistry } from '../../models/interfaces/i-ministry';

let intake: IProjectIntake;
let client: IClient;
let projectSectors: IProjectSector[];
let ministries: IMinistry[];
const contact: IContact[] = [IntakeData.genContacts()];

describe('intake.service.ts', function() {
  this.enableTimeouts(false);

  before(async () => {
    await databaseConnection;
    // create intake object from nested objects
    ministries = await retrieveMinistries();
    client = await createClient(IntakeData.genClients(ministries[0]));
    projectSectors = await retrieveProjectSectors();
    intake = IntakeData.genProjectIntake(client, projectSectors[0], contact);
  });

  it('should create a new intake record', async () => {
    try {
      const res = await createIntake(intake);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });

  it('should get intake record', async () => {
    try {
      const res = await retrieveIntakeById(intake.id);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });

  it('should update intake record', async () => {
    try {
      const res = await updateIntake(intake.id, {
        fullName: 'abc'
      });
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });

  it('should delete intake record', async () => {
    try {
      const res = await deleteIntake(intake.id);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });
});
