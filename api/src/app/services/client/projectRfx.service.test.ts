import { createClient } from './client.service';
import { IRfxType } from './../../models/interfaces/i-rfx-type';
import { IProjectSector } from './../../models/interfaces/i-project-sector';
import { IProjectRfx } from './../../models/interfaces/i-project-rfx';
import databaseConnection from './../../database/database.connection';
import IntakeData from '../../utility/mocks/intake-data';
import {
  createProjectRfx,
  retrieveProjectRfxById,
  updateProjectRfx,
  deleteProjectRfx
} from './projectRfx.service';
import { expect } from 'chai';
import { describe } from 'mocha';
import { retrieveMinistries } from './ministry.service';
import { retrieveProjectSectors } from './projectSector.service';
import { createProject } from './project.service';
import { retrieveRfxPhases } from './rfxPhase.service';
import { retrieveRfxTypes } from './rfxType.service';
import { IProject } from '../../models/interfaces';
import { IClient } from '../../models/interfaces/i-client';
import { IMinistry } from '../../models/interfaces/i-ministry';
import { IRfxPhase } from '../../models/interfaces/i-rfx-phase';

let projectRfx: IProjectRfx;
let project: IProject;
let client: IClient;
let projectSectors: IProjectSector[];
let ministries: IMinistry[];
let rfxPhases: IRfxPhase[];
let rfxTypes: IRfxType[];

describe('projectRfx.service.ts', function() {
  this.enableTimeouts(false);

  before(async () => {
    await databaseConnection;
    ministries = await retrieveMinistries();
    rfxPhases = await retrieveRfxPhases();
    rfxTypes = await retrieveRfxTypes();
    client = await createClient(IntakeData.genClients(ministries[0]));
    projectSectors = await retrieveProjectSectors();
    project = IntakeData.genProject(
      client,
      projectSectors[0],
    );
    await createProject(project);
    projectRfx = IntakeData.genProjectRfx(project, rfxTypes[0], rfxPhases[0]);
  });

  it('should create a new projectRfx record', async () => {
    try {
      const res: IProjectRfx = await createProjectRfx(projectRfx);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });

  it('should get projectRfx record', async () => {
    try {
      const res: IProjectRfx = await retrieveProjectRfxById(projectRfx.id);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });

  it('should update projectRfx record', async () => {
    try {
      const res = await updateProjectRfx(projectRfx.id, {
        fullName: 'abc'
      });
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });

  it('should delete projectRfx record', async () => {
    try {
      const res = await deleteProjectRfx(projectRfx.id);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });
});
