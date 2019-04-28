import { IProjectContact } from './../../models/interfaces/i-project-contact';
import { createClient } from './client.service';
import { IClient } from './../../models/interfaces/i-client';
import databaseConnection from './../../database/database.connection';
import IntakeData from '../../utility/mocks/intake-data';
import {
  createProjectContact,
  retrieveProjectContactById,
  updateProjectContact,
  deleteProjectContact
} from './projectContacts.service';
const request = require('supertest');
import { expect } from 'chai';
import { describe } from 'mocha';
import { retrieveMinistries } from './ministry.service';
import { retrieveProjectSectors } from './projectSector.service';
import { createContact } from './contact.service';
import { createProject } from './project.service';
import { IProject } from '../../models/interfaces';
import { IProjectSector } from '../../models/interfaces/i-project-sector';
import { IMinistry } from '../../models/interfaces/i-ministry';
import { IContact } from '../../models/interfaces/i-contact';

let projectContacts: IProjectContact;
let project: IProject;
let client: IClient;
let projectSectors: IProjectSector[];
let ministries: IMinistry[];
const contact: IContact = IntakeData.genContacts();

describe('projectContacts.service.ts', function() {
  this.enableTimeouts(false);

  before(async () => {
    await databaseConnection;
    ministries = await retrieveMinistries();
    client = await createClient(IntakeData.genClients(ministries[0]));
    projectSectors = await retrieveProjectSectors();
    project = IntakeData.genProject(
      client,
      projectSectors[0],
    );
    await createProject(project);
    await createContact(contact);
    projectContacts = IntakeData.genProjectContacts(contact, project);
  });

  it('should create a new projectContacts record', async () => {
    try {
      const res: IProjectContact = await createProjectContact(projectContacts);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });

  it('should get projectContacts record', async () => {
    try {
      const res: IProjectContact = await retrieveProjectContactById(
        projectContacts.id
      );
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });

  it('should update projectContacts record', async () => {
    try {
      const res = await updateProjectContact(projectContacts.id, {
        fullName: 'abc'
      });
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });

  it('should delete projectContacts record', async () => {
    try {
      const res = await deleteProjectContact(projectContacts.id);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });
});
