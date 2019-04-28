import app from './app/app';
import databaseConnection from './app/database/database.connection';

export const ready = false;

const PORT: number = Number(process.env.PORT) || 3000;
const init = () => {
  databaseConnection
    .then(() => {
      console.log('run');
      console.log('Connection established.');
      if (!ready) {
        app.listen(PORT);
      }
      console.log('App Started on ' + PORT);
      return (this.ready = true);
    })
    .catch(console.error);
};
init();
export default init;
