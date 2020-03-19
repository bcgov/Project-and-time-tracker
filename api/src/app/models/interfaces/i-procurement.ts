import { ContactType } from '../entities/contact.entity';
import { IProject } from './i-project';

export interface IProcurement {
  id: string;
  riskOwner: string;
  descriptionOfIssue: string;
  logTypeId: string;
  notificationId: string;
  phaseImpactId: string;
  clientDecisionId: string;
  dateToClient: Date;
  followUpDate: Date;
  project: IProject;
}
