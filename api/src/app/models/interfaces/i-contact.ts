import { ContactType } from '../entities/contact.entity';

export interface IContact {
  id: string;
  contactType: ContactType;
  userId?: string;
  fullName: string;
  orgName: string;
  orgPosition: string;
  email: string;
  phoneNumber: string;
  addressLine1: string;
  addressLine2: string;
  city: string;
  province: string;
  country: string;
  postalCode: string;
}
