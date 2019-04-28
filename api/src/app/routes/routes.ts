import projectController from './client/controllers/project.controller';
import intakeController from './client/controllers/intake.controller';
import ministryController from './client/controllers/ministry.controller';
import projectSectorController from './client/controllers/projectSector.controller';
import clientController from './client/controllers/client.controller';
import contractController from './client/controllers/contact.controller';
import projectRfxController from './client/controllers/projectRfx.controller';
import rfxTypeController from './client/controllers/rfxType.controller';
import rfxPhaseController from './client/controllers/rfxPhase.controller';
import timesheetController from './client/controllers/timesheet.controller';
import userController from './client/controllers/user.controller';
import authController from './client/controllers/auth.controller';

export const appRoutes = [
  projectController.routes(),
  intakeController.routes(),
  ministryController.routes(),
  projectSectorController.routes(),
  clientController.routes(),
  contractController.routes(),
  projectRfxController.routes(),
  rfxTypeController.routes(),
  rfxPhaseController.routes(),
  timesheetController.routes(),
  userController.routes(),
  authController.routes(),
];

export const allowedMethods = [
  projectController.allowedMethods(),
  intakeController.allowedMethods(),
  ministryController.allowedMethods(),
  projectSectorController.allowedMethods(),
  clientController.allowedMethods(),
  contractController.allowedMethods(),
  projectRfxController.allowedMethods(),
  rfxTypeController.allowedMethods(),
  rfxPhaseController.allowedMethods(),
  timesheetController.allowedMethods(),
  userController.allowedMethods(),
  authController.allowedMethods()
];
