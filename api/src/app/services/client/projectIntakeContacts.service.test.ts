
import { createIntake } from './intake.service';
import { IProjectSector } from './../../models/interfaces/i-project-sector';
import { IClient } from './../../models/interfaces/i-client';
import { IProjectIntakeContact } from './../../models/interfaces/i-project-intake-contact';
import databaseConnection from './../../database/database.connection';
import IntakeData from '../../utility/mocks/intake-data';
import {
  createProjectIntakeContact,
  retrieveProjectIntakeContactById,
  updateProjectIntakeContact,
  deleteProjectIntakeContact
} from './projectIntakeContacts.service';
import { expect } from 'chai';
import { describe } from 'mocha';
import { retrieveProjectSectors } from './projectSector.service';
import { createClient } from './client.service';
import { retrieveMinistries } from './ministry.service';
import { createContact } from './contact.service';
import { IMinistry } from '../../models/interfaces/i-ministry';
import { IContact } from '../../models/interfaces/i-contact';
import { IProjectIntake } from '../../models/interfaces/i-project-intake';

let projectIntakeContact: IProjectIntakeContact;
let intake: IProjectIntake;
let client: IClient;
let projectSectors: IProjectSector[];
let ministries: IMinistry[];
const contacts: IContact[] = [IntakeData.genContacts()];

describe('projectIntakeContacts.service.ts', function() {
  this.enableTimeouts(false);

  before(async () => {
    await databaseConnection;
    // create IProjectIntakeContact object from nested objects
    ministries = await retrieveMinistries();
    client = await createClient(IntakeData.genClients(ministries[0]));
    projectSectors = await retrieveProjectSectors();
    await createContact(contacts[0]);
    intake = IntakeData.genProjectIntake(client, projectSectors[0], contacts);
    await createIntake(intake);
    projectIntakeContact = IntakeData.genProjectIntakeContact(contacts[0], intake);
  });

  it('should create a new projectIntakeContacts record', async () => {
    try {
      const res: IProjectIntakeContact = await createProjectIntakeContact(
        projectIntakeContact
      );
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });

  it('should get projectIntakeContacts record', async () => {
    try {
      const res: IProjectIntakeContact = await retrieveProjectIntakeContactById(
        projectIntakeContact.id
      );
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });

  it('should update projectIntakeContacts record', async () => {
    try {
      const res = await updateProjectIntakeContact(
        projectIntakeContact.id,
        {
          fullName: 'abc'
        }
      );
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });

  it('should delete projectIntakeContacts record', async () => {
    try {
      const res = await deleteProjectIntakeContact(projectIntakeContact.id);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });
});
