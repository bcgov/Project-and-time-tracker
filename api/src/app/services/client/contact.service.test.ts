import { IContact } from './../../models/interfaces/i-contact';
import databaseConnection from './../../database/database.connection';
import IntakeData from '../../utility/mocks/intake-data';
import {
  createContact,
  retrieveContactById,
  updateContact,
  deleteContact
} from './contact.service';
import { expect } from 'chai';
import { describe } from 'mocha';

const contacts = [IntakeData.genContacts()] as IContact[];

describe('contact.service.ts', function() {
  this.enableTimeouts(false);

  before(async () => {
    await databaseConnection;
  });

  it('should create a new contact record', async () => {
    try {
      const res: IContact = await createContact(contacts[0]);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });

  it('should get contact record', async () => {
    try {
      const res: IContact = await retrieveContactById(contacts[0].id);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });

  it('should update contact record', async () => {
    try {
      const res: IContact = await updateContact(contacts[0].id, {
        fullName: 'abc'
      });
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });

  it('should delete contact record', async () => {
    try {
      const res = await deleteContact(contacts[0].id);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });
});
