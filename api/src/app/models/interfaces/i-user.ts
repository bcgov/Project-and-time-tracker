import { IContact } from './i-contact';

export interface IUser {
    id: string;
    referenceId: string;
    contact: IContact;
    role: string;
    isActive: boolean;
}
