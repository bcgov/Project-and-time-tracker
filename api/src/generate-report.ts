import app from './app/app';
import databaseConnection from './app/database/database.connection';
import { DB_CONFIG } from './app/config/settings';
import { retrieveUsers } from './app/services/client/user.service';

export const ready = false;

// All Entries for time and expenses from <DATE> to today.
// Fields needed include:

// PSB Staff Name
// MOU
// Hours per day, or week, or month (whatever is easiest, ideally smaller timeframe though, (days weeks))
// Expense, amount, type (Legal, Fee, etc)
 

const init = () => {
  console.log('Generating report...')
    
  console.log({DB_CONFIG});

  databaseConnection
    .then(() => {
      console.log('DB Connection established');


      console.log('dbConnection', { databaseConnection })
      const allUsers = retrieveUsers()

      console.log({ allUsers })
    })
    // .catch(console.error);
    .catch(error => {
        console.error('db connection error', { error })
    });
};


init();
export default init;
