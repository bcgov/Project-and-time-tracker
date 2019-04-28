import { ITimesheet } from './i-timesheet';

export interface ITimesheetEntry {
  id: string;
  timesheet: ITimesheet;
  projectRfxId: string;
  projectId: string;
  rfxPhaseId: string;
  userId: string;
  hoursBilled: number;
  startTime: string;
  endTime: string;
  entryDate: Date;
  comments: string;
}
