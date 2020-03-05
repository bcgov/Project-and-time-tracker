import { IClient } from './i-client';
import { IProjectSector } from './i-project-sector';

export interface IProject {
  id: string;
  projectName: string;
  client: IClient;
  projectSector: IProjectSector;
  commodityCode: string;
  dueDate: Date;
  completionDate: Date;
  contractValue: number;
  mouAmount: number;
  description: string;

  leadUserId: string;
  backupUserId: string;
  createdUserId: string;
  isReprocurement: boolean;
  dateOfReprocurement: Date;
  previousContractBackground: string;
  projectFailImpact: string;
  projectSuccess: string;
}
