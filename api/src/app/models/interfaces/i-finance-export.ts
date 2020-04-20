import { IFinanceExportDetail } from './i-finance-export-detail';

export interface IFinanceExport {
  id: string;
  documentNo: string;
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
  projectId: string;
  projectName: string;
  details: IFinanceExportDetail[];
}
