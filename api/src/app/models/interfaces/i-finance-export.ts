export interface IFinanceExport {
  id: string;
  documentNo: string;
  exportData: string;
  projectId: string;
  dateCreated: Date;
  createdUserId: string;
  documentPath: string;
  totalAmount: number;
  monthStartDate: Date;
}
