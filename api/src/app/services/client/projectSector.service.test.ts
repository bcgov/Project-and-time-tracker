import databaseConnection from './../../database/database.connection';
import {
    retrieveProjectSectors,
    retrieveProjectSectorById
} from './projectSector.service';
import { expect } from 'chai';
import { describe } from 'mocha';
import { IProjectSector } from '../../models/interfaces/i-project-sector';

let projectSector: IProjectSector;

describe('projectSector.service.ts', function() {
  this.enableTimeouts(false);

  before(async () => {
    await databaseConnection;
  });

  it('should get all projectSector record', async () => {
    try {
      const res: IProjectSector[] = await retrieveProjectSectors();
      projectSector = res[0];
      expect(res).to.a('array');
    } catch (err) {
      throw err;
    }
  });

  it('should get projectSector record', async () => {
    try {
      const res: IProjectSector = await retrieveProjectSectorById(projectSector.id);
      expect(res).to.a('object');
    } catch (err) {
      throw err;
    }
  });
});
