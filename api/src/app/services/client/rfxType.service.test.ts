import { IRfxType } from './../../models/interfaces/i-rfx-type';
import databaseConnection from './../../database/database.connection';
import { expect } from 'chai';
import { describe } from 'mocha';
import { retrieveRfxPhases, retrieveRfxPhaseById } from './rfxPhase.service';

let rfxType: IRfxType;

describe('rfxType.service.ts', function() {
  this.enableTimeouts(false);

  before(async () => {
    await databaseConnection;
  });

  it('should get all rfxType record', async () => {
    try {
      const res: IRfxType[] = await retrieveRfxPhases();
      rfxType = res[0];
      expect(res).to.a('array');
    } catch (err) {
      throw err;
    }
  });

  it('should get rfxType record', async () => {
    try {
      const res: IRfxType = await retrieveRfxPhaseById(rfxType.id);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });
});
