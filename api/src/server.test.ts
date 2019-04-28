const request = require('supertest');
import { expect } from 'chai';
import { describe } from 'mocha';

const PORT: number = Number(process.env.PORT) || 3000;

import app from './app/app';
import databaseConnection from './app/database/database.connection';

describe('API Tests', function() {
  let server;
  this.enableTimeouts(false);

  before(async () => {
    await databaseConnection;
    server = await app.listen(PORT);
  });

  after(() => { server.close(); });

});
