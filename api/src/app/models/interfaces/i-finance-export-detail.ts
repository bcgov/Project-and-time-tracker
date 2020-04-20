import { IFinanceExport } from './i-finance-export';

export interface IFinanceExportDetail {
  id: string;
  FinanceExport: IFinanceExport;
  entryDate: Date;
  description: string;
  type: string;
  resource: string;
  user: string;
  hours: number;
  rate: number;
  amount: number;
}
