import { ITimesheet } from './i-timesheet';

export interface ITimesheetEntry {
  id: string;
  timesheet: ITimesheet;
  hoursBillable: number;
  commentsBillable: string;
  hoursUnBillable: number;
  commentsUnBillable: string;
  entryDate: Date;
  expenseAmount: number;
  expenseComment: string;
  revenueAmount: number;
  revenueComment: string;
  expenseCategory: string;
  amountBilled: number;
}
