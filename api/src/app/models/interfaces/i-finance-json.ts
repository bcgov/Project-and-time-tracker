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

export interface IClientAddress {
  leadUserName:string;
  orgName: string;
  phoneNumber: string;
  addressLine1: string;
  addressLine2: string;
  city: string;
  province: string;
  country: string;
  postalCode: string;
}
export interface IFinanceJSON {
  id: string;
  documentNo: string;
  projectId: string;
  dateCreated: Date;
  projectCreated: Date;
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
  mouEstimate: number;
  totalBillingToDate: number;
  prevBillAmount: number;
  balanceMou: number;
  leadUser: string;
  financeName: string;
  details: IFinanceExportDetail[];
  userFinanceCodes: IUserFinanceCodes[];
  clientAddress: IClientAddress[];
}
