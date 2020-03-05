import { IClient } from './i-client';
import { IContact } from './i-contact';
import { IProjectSector } from './i-project-sector';
import { IProjectIntakeCategory } from './i-project-intake-category';
import { IProjectIntakeServices } from './i-project-intake-services';
import { IntakeStatus } from '../entities/projectIntake.entity';

export interface IProjectIntake {
  id: string;
  projectName: string;
  client: IClient;
  projectSector: IProjectSector;
  projectIntakeCategory: IProjectIntakeCategory;
  projectIntakeServices: IProjectIntakeServices;
  commodityCode: string;
  estimatedCompletionDate: Date;
  estimatedContractValue: number;
  mouAmount: number;
  description: string;
  status: IntakeStatus;
  contacts: IContact[];
  createdUserId: string;
  isReprocurement: boolean;
  dateOfReprocurement: Date;
  previousContractBackground: string;
  projectFailImpact: string;
  projectSuccess: string;
  riskScore: number;
  riskLevel: number;
}
