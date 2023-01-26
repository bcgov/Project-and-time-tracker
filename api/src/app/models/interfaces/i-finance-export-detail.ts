export interface IFinanceExportDetail {
  id: string;
  entryDate: Date;
  description: string;
  type: string;
  resource: string;
  user: string;
  hours: number;
  rate: number;
  amount: number;
}
