import { IRfxPhase } from './../../models/interfaces/i-rfx-phase';
import databaseConnection from './../../database/database.connection';
import {
    retrieveRfxPhases,
    retrieveRfxPhaseById
} from './rfxPhase.service';
import { expect } from 'chai';
import { describe } from 'mocha';

let rfxPhase: IRfxPhase;

describe('rfxPhase.service.ts', function() {
  this.enableTimeouts(false);

  before(async () => {
    await databaseConnection;
  });

  it('should get all rfxPhase record', async () => {
    try {
      const res: IRfxPhase[] = await retrieveRfxPhases();
      rfxPhase = res[0];
      expect(res).to.a('array');
    } catch (err) {
      throw err;
    }
  });

  it('should get rfxPhase record', async () => {
    try {
      const res: IRfxPhase = await retrieveRfxPhaseById(rfxPhase.id);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });
});
