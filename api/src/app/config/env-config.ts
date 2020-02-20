export  const ENV_CONFIG =  {
    local: {
        'database': {
            'postgresdb': {
                'type': 'postgres',
                // 'host': 'timemachinedev.cu9f5va0d5zo.us-east-1.rds.amazonaws.com',
                // 'port': 5432,
                // 'username': 'timeTrackerAdmin',
                // 'password': 'T1meTrack3r#567',
                // 'database': 'timeMachineDev',
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
            authServerUrl: 'http://iam.aot-technologies.com/auth',
            adminUserName: 'dev_admin',
            adminPassword: 'aot123'
        }
    },
};
