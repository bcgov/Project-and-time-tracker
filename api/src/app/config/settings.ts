import {ENV_CONFIG} from './env-config';

const env = process.env.environment || 'local';

/** Configurations with respect to the environments chosen */
export const ENVIRONMENT_CONFIG = ENV_CONFIG[env];

/** DB Configurations with respect to the database type chosen in the environment */
export const DB_CONFIG = process.env.environment ? {
    type: process.env.db_type,
    host: process.env.db_host,
    port: process.env.db_port,
    username: process.env.db_username,
    password: process.env.db_password,
    database: process.env.db_name,
    synchronize: process.env.db_synchronize
} : ENVIRONMENT_CONFIG.database['postgresdb'];

// console.log('DB_Config - ', { DB_CONFIG });


// ARC TODO - Use process.env to store keycloak creds on server
// https://cli.vuejs.org/guide/mode-and-env.html#example-staging-mode
export const keycloakConfig = {
    url: process.env.kc_authServerUrl || ENVIRONMENT_CONFIG.keyCloak.authServerUrl,
    realmName: process.env.kc_realm || ENVIRONMENT_CONFIG.keyCloak.realm,
    resourceName: process.env.kc_resource || ENVIRONMENT_CONFIG.keyCloak.resource
};

// console.log('Keycloak config', {keycloakConfig});