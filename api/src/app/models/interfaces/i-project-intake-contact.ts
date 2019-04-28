import { IContact } from './i-contact';
import { IProjectIntake } from './i-project-intake';

export interface IProjectIntakeContact {
  id: string;
  contact: IContact;
  projectIntake: IProjectIntake;
}
