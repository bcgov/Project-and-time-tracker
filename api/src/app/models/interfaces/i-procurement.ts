import { ContactType } from '../entities/contact.entity';
import { IProject } from './i-project';

export interface IProcurement {
  id: string;
  riskOwner: string;
  descriptionOfIssue: string;
  logType: string;
  notificationMethod: string;
  phaseImpactName: string;
  clientDecision: string;
  dateToClient: Date;
  followUpDate: Date;
  projectId: string;
  isResolved: boolean;
  userId: string;
}
