import { IMinistry } from './i-ministry';

export interface IClient {
  id: string;
  clientNo: string;
  responsibilityCenter: string;
  serviceCenter: string;
  stob: string;
  projectCode: string;
  ministry?: IMinistry;
  orgDivision: string;
  email: string;
  addressLine1: string;
  addressLine2: string;
  city: string;
  province: string;
  country: string;
  postalCode: string;
  isNonMinistry: boolean;
  nonMinistryName: string;
  billingCount: number;
}
