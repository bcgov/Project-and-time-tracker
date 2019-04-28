export  const ENV_CONFIG =  {
    local: {
        'database': {
            'postgresdb': {
                'type': 'postgres',
                'host': 'localhost',
                'port': 5432,
                'username': 'postgres',
                'password': 'admin',
                'database': 'timemachine',
                'synchronize': true
            }
        },
        keyCloak: {
            realm: 'Time_Tracker_dev',
            resource: 'timeMachineApp',
            authServerUrl: 'http://keycloak/auth',
            adminUserName: 'admin',
            adminPassword: 'password'
        }
    },
};
