import { IProjectRfx } from './i-project-rfx';
import { IProject } from './i-project';
import { IMOU } from './i-mou';
import { ITimesheetEntry } from './i-timesheet-entry';

export interface ITimesheet {
  id: string;
  projectRfx: IProjectRfx;
  project: IProject;
  mou: IMOU;
  expenseAmount: number;
  expenseComment: string;
  startDate: Date;
  endDate: Date;
  userId: string;
  isBillable: boolean;
  createdUserId: string;
  entries: ITimesheetEntry[];
}
