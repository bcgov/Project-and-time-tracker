import { IContact } from './i-contact';
import { IProject } from './i-project';

export interface IProjectContact {
  id: string;
  contact: IContact;
  project: IProject;
}
