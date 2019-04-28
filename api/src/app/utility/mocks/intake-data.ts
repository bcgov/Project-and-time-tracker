import { ITimesheet } from './../../models/interfaces/i-timesheet';
import { IRfxType } from './../../models/interfaces/i-rfx-type';
import { IProjectRfx } from './../../models/interfaces/i-project-rfx';
import { IProjectIntakeContact } from './../../models/interfaces/i-project-intake-contact';
import { IProjectContact } from './../../models/interfaces/i-project-contact';
import { IProjectSector } from './../../models/interfaces/i-project-sector';
import { Chance } from 'chance';
import { IProjectIntake } from '../../models/interfaces/i-project-intake';
import { IClient } from '../../models/interfaces/i-client';
import { IContact } from '../../models/interfaces/i-contact';
import { IntakeStatus } from '../../models/entities/projectIntake.entity';
import { IMinistry } from '../../models/interfaces/i-ministry';
import { IDocuments } from '../../models/interfaces/i-documents';
import { IProject } from '../../models/interfaces';
import { IRfxPhase } from '../../models/interfaces/i-rfx-phase';
import { ITimesheetEntry } from '../../models/interfaces/i-timesheet-entry';
export namespace IntakeData {
  export const chance = new Chance();

  export const genIntakeStatus = (): IntakeStatus => {
    const num = chance.integer({ min: 1, max: 3 });
    switch (num) {
      case 1:
        return 'submitted';
      case 2:
        return 'approved';
      case 3:
        return 'rejected';
    }
  };

  export const genMinistry = (): IMinistry => {
    return {
      id: chance.guid()
    };
  };

  export const genClients = (ministry: IMinistry): IClient => ({
    id: chance.guid(),
    clientNo: chance.integer({ min: 3, max: 3 }),
    responsibilityCenter: chance.integer({ min: 5, max: 5 }),
    serviceCenter: chance.integer({ min: 5, max: 5 }),
    stob: chance.integer({ min: 4, max: 4 }),
    projectCode: chance.integer({ min: 7, max: 7 }),
    // end finance codes
    ministry,
    orgDivision: chance.word({ length: 4 }),
    email: chance.email(),
    addressLine1: chance.address(),
    addressLine2: null,
    city: chance.city(),
    province: chance.province(),
    country: chance.country(),
    postalCode: chance.postal()
  });

  export const genDocuments = (): IDocuments => ({
    id: chance.guid(),
    mimetype: chance.name(),
    data: null,
    version: chance.string()
  });

  export const genContacts = (): IContact => ({
    id: chance.guid(),
    userId: chance.guid(),
    contactType: 'clientlead',
    phoneNumber: chance.phone(),
    fullName: chance.name(),
    orgName: chance.company(),
    orgPosition: chance.profession(),
    email: chance.email(),
    addressLine1: chance.address(),
    addressLine2: chance.string(),
    city: chance.city(),
    province: chance.province(),
    country: chance.country(),
    postalCode: chance.postal()
  });

  export const genProjectIntake = (
    client: IClient,
    projectSector: IProjectSector,
    contacts: IContact[]
  ): IProjectIntake => ({
    contacts,
    client,
    projectSector,
    projectName: chance.name(),
    id: chance.guid(),
    commodityCode: chance.string({ min: 3, max: 3 }),
    estimatedCompletionDate: chance.date(),
    estimatedContractValue: chance.integer(),
    description: chance.sentence(),
    status: genIntakeStatus(),
    mouAmount: chance.integer(),
    createdUserId: chance.guid()
  });

  export const genProject = (
    client: IClient,
    projectSector: IProjectSector,
  ): IProject => ({
    leadUserId: chance.guid(),
    backupUserId: null,
    id: chance.guid(),
    projectName: chance.name(),
    client,
    projectSector,
    commodityCode: chance.string({ min: 3, max: 3 }),
    dueDate: chance.date(),
    completionDate: chance.date(),
    contractValue: chance.integer(),
    description: chance.sentence(),
    mouAmount: chance.integer({ min: 0, max: 99999 }),
    createdUserId: chance.guid()
  });

  export const genProjectContacts = (
    contact: IContact,
    project: IProject
  ): IProjectContact => ({
    id: chance.guid(),
    contact,
    project
  });

  export const genProjectIntakeContact = (
    contact: IContact,
    projectIntake: IProjectIntake
  ): IProjectIntakeContact => ({
    id: chance.guid(),
    contact,
    projectIntake
  });

  export const genProjectRfx = (
    project: IProject,
    rfxType: IRfxType,
    rfxPhase: IRfxPhase
  ): IProjectRfx => ({
    id: chance.guid(),
    project,
    rfxType,
    rfxPhase,
    rfxOverview: chance.sentence(),
    clientResponsibilities: chance.sentence(),
    psdResponsibilities: chance.sentence()
  });

  export const genTimesheet = (
    projectRfx: IProjectRfx,
    project: IProject,
    rfxPhase: IRfxPhase,
    entries: ITimesheetEntry[]
  ): ITimesheet => ({
    id: chance.guid(),
    projectRfx,
    project,
    rfxPhase,
    startDate: chance.date(),
    endDate: chance.date(),
    userId: chance.guid(),
    isBillable: chance.bool(),
    entries,
    createdUserId: chance.guid()
  });

  export const genTimesheetEntry = (
    timesheet: ITimesheet,
    project: IProject,
    projectRfx: IProjectRfx,
    rfxPhase: IRfxPhase
  ): ITimesheetEntry => ({
    id: chance.guid(),
    timesheet,
    projectId: project.id,
    projectRfxId: projectRfx.id,
    rfxPhaseId: rfxPhase.id,
    userId: chance.guid(),
    hoursBilled: chance.integer(),
    entryDate: new Date(chance.date()),
    startTime: null,
    endTime: null,
    comments: chance.paragraph()
  });
}

export default IntakeData;
