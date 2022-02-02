import 'reflect-metadata';
import { createConnection, Connection, ConnectionOptions } from 'typeorm';
import { join } from 'path';
export const parentDir = join(__dirname, '..');

import { DB_CONFIG } from '../config/settings';

const dbConfig = DB_CONFIG;

const connectionOpts: ConnectionOptions = {
  type: dbConfig.type,
  host: dbConfig.host,
  port: dbConfig.port,
  username: dbConfig.username,
  password: dbConfig.password,
  database: dbConfig.database,
  synchronize: dbConfig.synchronize,
  entities: [
    `${parentDir}/**/**{.entity.ts,.entity.js}`,
  ],
};

const connection: Promise<Connection> = createConnection(connectionOpts);

export default connection;
