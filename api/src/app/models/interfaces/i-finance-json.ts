import { IFinanceExportDetail } from './i-finance-export-detail';
export interface IUserFinanceCodes {
  id: string;
  financeName: string;
  clientNo: string;
  responsibilityCenter: string;
  serviceCenter: string;
  stob: string;
  projectCode: string;
  user: string;
  type: string;
  amount: number;
}
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
  mouName: string;
  projectCode: string;
  projectName: string;
  documentPath: string;
  billingCount: number;
  details: IFinanceExportDetail[];
  userFinanceCodes: IUserFinanceCodes[];
}
