import { IFinanceExportDetail } from './i-finance-export-detail';

export interface IFinanceJSON {
  id: string;
  documentNo: string;
  projectId: string;
  dateCreated: Date;
  createdUserId: string;
  lineDesc: string;
  sap: string;
  reference: string;
  contact: string;
  organisation: string;
  fees: number;
  expenses: number;
  totalAmount: number;
  clientNo: string;
  responsibilityCenter: string;
  serviceCenter: string;
  stob: string;
  projectCode: string;
  projectName: string;
  details: IFinanceExportDetail[];
}
