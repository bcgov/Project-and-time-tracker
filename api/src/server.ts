import app from './app/app';
import databaseConnection from './app/database/database.connection';
import { DB_CONFIG } from './app/config/settings';

export const ready = false;

const PORT: number = Number(process.env.PORT) || 3000;
const init = () => {
  console.log(DB_CONFIG);

  databaseConnection
    .then(() => {
      console.log('run');
      console.log('Connection established.');
      if (!ready) {
        app.listen(PORT);
      }
      console.log('App Started on ' + PORT);
    })
    .catch((e)=> {
        console.log(e);
        console.error;
    });
};
init();
export default init;
