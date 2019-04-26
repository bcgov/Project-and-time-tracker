import { createClient } from './client.service';
import { IRfxType } from './../../models/interfaces/i-rfx-type';
import { IRfxPhase } from './../../models/interfaces/i-rfx-phase';
import { IProjectRfx } from './../../models/interfaces/i-project-rfx';
import { ITimesheet } from './../../models/interfaces/i-timesheet';
import databaseConnection from './../../database/database.connection';
import IntakeData from '../../utility/mocks/intake-data';
import {
  createTimesheet,
  retrieveTimesheetById,
  updateTimesheet,
  deleteTimesheet
} from './timesheet.service';
import { expect } from 'chai';
import { describe } from 'mocha';
import { retrieveMinistries } from './ministry.service';
import { retrieveRfxPhases } from './rfxPhase.service';
import { retrieveRfxTypes } from './rfxType.service';
import { retrieveProjectSectors } from './projectSector.service';
import { createProject } from './project.service';
import { createProjectRfx } from './projectRfx.service';
import { IProject } from '../../models/interfaces';
import { IClient } from '../../models/interfaces/i-client';
import { IProjectSector } from '../../models/interfaces/i-project-sector';
import { IMinistry } from '../../models/interfaces/i-ministry';

let timesheet: ITimesheet;
let projectRfx: IProjectRfx;
let project: IProject;
let client: IClient;
let projectSectors: IProjectSector[];
let ministries: IMinistry[];
let rfxPhases: IRfxPhase[];
let rfxTypes: IRfxType[];

describe('timesheet.service.ts', function() {
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
    await createProjectRfx(projectRfx);
    timesheet = IntakeData.genTimesheet(projectRfx, project, rfxPhases[0], []);
  });

  it('should create a new timesheet record', async () => {
    try {
      const res = await createTimesheet(timesheet);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });

  it('should get timesheet record', async () => {
    try {
      const res = await retrieveTimesheetById(timesheet.id);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });

  it('should update timesheet record', async () => {
    try {
      const res = await updateTimesheet(timesheet.id, {
        fullName: 'abc'
      });
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });

  it('should delete timesheet record', async () => {
    try {
      const res = await deleteTimesheet(timesheet.id);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });
});
