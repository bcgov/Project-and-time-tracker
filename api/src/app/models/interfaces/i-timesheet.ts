import { IProjectRfx } from './i-project-rfx';
import { IProject } from './i-project';
import { IRfxPhase } from './i-rfx-phase';
import { ITimesheetEntry } from './i-timesheet-entry';

export interface ITimesheet {
  id: string;
  projectRfx: IProjectRfx;
  project: IProject;
  rfxPhase: IRfxPhase;
  startDate: Date;
  endDate: Date;
  userId: string;
  isBillable: boolean;
  createdUserId: string;
  entries: ITimesheetEntry[];
}
