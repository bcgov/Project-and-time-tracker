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
            realm: 'standard',
            resource: 'time-machine-4338',
            authServerUrl: 'https://dev.loginproxy.gov.bc.ca/auth'
        }
    },
};
