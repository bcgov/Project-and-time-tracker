import { ITimesheet } from './i-timesheet';

export interface ITimesheetEntry {
  id: string;
  timesheet: ITimesheet;
  hours: number;
  entryDate: Date;
  comments: string;
}
