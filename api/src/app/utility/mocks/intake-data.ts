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
import { IFinanceCodes } from '../../models/interfaces/i-finance-codes';
import { ContactType } from '../../models/entities';
import { ProjectCategory } from '../../models/entities';
import { IMOU } from '../../models/interfaces/i-mou';
// import { IDocuments } from '../../models/interfaces/i-documents';
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
  clientNo: chance.string(),
  responsibilityCenter: chance.string(),
  serviceCenter: chance.string(),
  stob: chance.string(),
  projectCode: chance.string(),

  ministry,

  isNonMinistry: false,
  nonMinistryName: null,
  billingCount: 0,

  orgDivision: chance.word({ length: 4 }),
  email: chance.email(),
  addressLine1: chance.address(),
  addressLine2: null,
  city: chance.city(),
  province: chance.province(),
  country: chance.country(),
  postalCode: chance.postal()
});

  // export const genDocuments = (): IDocuments => ({
  //   id: chance.guid(),
  //   mimetype: chance.name(),
  //   data: null,
  //   version: chance.string()
  // });
  const genFinanceCodes = (): IFinanceCodes => ({
  id: chance.guid(),
  financeName: chance.word(),
  clientNo: chance.string({ length: 6 }),
  responsibilityCenter: chance.string({ length: 4 }),
  serviceCenter: chance.string({ length: 4 }),
  stob: chance.string({ length: 4 }),
  projectCode: chance.string({ length: 6 })
});

  export const genContacts = (): IContact => ({
  id: chance.guid(),
  contactType: 'clientlead' as ContactType, // or ContactType.ClientLead if enum
  userId: chance.guid(),

  fullName: chance.name(),
  orgName: chance.company(),
  orgPosition: chance.profession(),
  email: chance.email(),
  phoneNumber: chance.phone(),

  addressLine1: chance.address(),
  addressLine2: chance.string(),
  city: chance.city(),
  province: chance.province(),
  country: chance.country(),
  postalCode: chance.postal(),

  roleName: 'Client Lead',
  financeCodes: genFinanceCodes()
});

export const genProjectIntake = (
  client: IClient,
  projectSector: IProjectSector,
  contacts: IContact[]
): IProjectIntake => ({
  id: chance.guid(),
  projectName: chance.name(),

  client,
  projectSector,
  contacts,

  projectIntakeCategory: {
    id: chance.guid()
  },

  projectIntakeServices: {
    id: chance.guid()
  },

  risk: [],

  commodityCode: chance.string({ length: 3 }),
  estimatedCompletionDate: chance.date(),
  estimatedContractValue: chance.integer(),
  mouAmount: chance.integer(),

  description: chance.sentence(),
  status: genIntakeStatus(),

  createdUserId: chance.guid(),
  isReprocurement: chance.bool(),
  dateOfReprocurement: chance.date(),
  previousContractBackground: chance.string(),
  projectFailImpact: chance.string(),
  projectSuccess: chance.string(),

  // ✅ required flags / metrics
  otherProjectSectorName: '',
  isNonMinistry: false,
  intakeRiskLevel: 0,
  riskScore: 0,
  isSPOEngagement: false,
  IntakeriskScore: 0,
  psbRiskScore: 0
});

  export const genProject = (
  client: IClient,
  projectSector: IProjectSector
): IProject => ({
  id: chance.guid(),
  projectName: chance.name(),

  client,
  projectSector,

  commodityCode: chance.string({ length: 3 }),
  dueDate: chance.date(),
  completionDate: chance.date(),
  contractValue: chance.integer(),
  mouAmount: chance.integer({ min: 0, max: 99999 }),

  description: chance.sentence(),

  leadUserId: chance.guid(),
  backupUserId: chance.guid(),       // ✅ must be string
  createdUserId: chance.guid(),

  isReprocurement: chance.bool(),
  dateOfReprocurement: chance.date(),
  previousContractBackground: chance.string(),
  projectFailImpact: chance.string(),
  projectSuccess: chance.string(),

  // ✅ required by IProject
  teamWideProject: chance.bool(),

  mou: {
    id: chance.guid(),
    name: chance.word(),
    billingCount: chance.integer({ min: 0, max: 10 })
  },

  categoryId: ProjectCategory.CSA
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
  rfxName: chance.name(),
  rfxOverview: chance.sentence(),
  clientResponsibilities: chance.sentence(),
  psdResponsibilities: chance.sentence()
});

  export const genTimesheet = (
  projectRfx: IProjectRfx,
  project: IProject,
  mou: IMOU,
  entries: ITimesheetEntry[]
): ITimesheet => ({
  id: chance.guid(),

  projectRfx,
  project,
  mou,

  startDate: chance.date(),
  endDate: chance.date(),

  userId: chance.guid(),
  createdUserId: chance.guid(),

  entries,

  // ✅ required by ITimesheet
  hoursAccured: chance.integer({ min: 0, max: 80 }),
  batchEntryComments: chance.sentence(),
  deleted: false,
  is_locked: false,
  documentNo: chance.string({ length: 8 })
});

  export const genTimesheetEntry = (
  timesheet: ITimesheet
): ITimesheetEntry => ({
  id: chance.guid(),
  timesheet,

  // ✅ billable
  hoursBillable: chance.integer({ min: 0, max: 12 }),
  commentsBillable: chance.sentence(),

  // ✅ non‑billable
  hoursUnBillable: chance.integer({ min: 0, max: 12 }),
  commentsUnBillable: chance.sentence(),

  entryDate: chance.date(),

  // ✅ expenses
  expenseAmount: chance.integer({ min: 0, max: 500 }),
  expenseComment: chance.sentence(),

  // ✅ revenue
  revenueAmount: chance.integer({ min: 0, max: 2000 }),
  revenueHours: chance.integer({ min: 0, max: 12 }),
  revenueComment: chance.sentence(),

  expenseCategory: chance.word(),
  amountBilled: chance.integer({ min: 0, max: 2000 })
});
}

export default IntakeData;
