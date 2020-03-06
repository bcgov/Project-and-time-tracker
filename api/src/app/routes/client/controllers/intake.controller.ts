import * as Koa from 'koa';
import * as Router from 'koa-router';
import { createClient } from '../../../services/client/client.service';
import {
  createIntake,
  retrieveIntakes,
  retrieveIntakeById,
  updateIntake
} from '../../../services/client/intake.service';
import { IProjectIntake } from '../../../models/interfaces/i-project-intake';
import { IProjectIntakeContact } from '../../../models/interfaces/i-project-intake-contact';
import { createContact } from '../../../services/client/contact.service';
import {
  createProjectIntakeContact,
  retrieveIntakeContactByIntakeId
} from '../../../services/client/projectIntakeContacts.service';
import { createProject } from '../../../services/client/project.service';
import { IProject } from '../../../models/interfaces/i-project';
import { createProjectContact } from '../../../services/client/projectContacts.service';
import { IProjectContact } from '../../../models/interfaces/i-project-contact';
import { IContact } from '../../../models/interfaces/i-contact';
import { validateEmail } from '../../../utility/helper';
import { IAuth } from '../../../models/interfaces/i-auth';
import { authorize } from '../../../services/common/authorize.service';
import { IProjectRiskAnalysis } from '../../../models/interfaces//i-project-risk-analysis';
import { CreateRiskAnalysis } from '../../../services/client/projectRisk.service';
import { IRiskQuestions } from '../../../models/interfaces/i-risk-questions';
import { IRiskAnswers } from '../../../models/interfaces/i-risk-answers';

export const getIntakesAction = async (ctx: Koa.Context) => {
  const intakes = await retrieveIntakes();
  ctx.body = intakes;
};

export const getIntakeByIdAction = async (ctx: Koa.Context) => {
  try {
    ctx.body = await retrieveIntakeById(ctx.params.id);
    const intakeContacts = await retrieveIntakeContactByIntakeId(ctx.params.id);
    const contacts = [];
    intakeContacts.map(function(intakeContact) {
      contacts.push(intakeContact.contact);
    });
    ctx.body.contacts = contacts;
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const updateIntakeByIdAction = async (ctx: Koa.Context) => {
  try {
    const body = ctx.request.body;
    ctx.body = await updateIntake(ctx.params.id, body);
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const createIntakeAction = async (ctx: Koa.Context) => {
  try {
    const projectIntake = ctx.request.body as IProjectIntake;
    if (!projectIntake) {
      ctx.throw('no data Found');
      return;
    }

    const validationErrors = validateIntakeForm(projectIntake);

    if (validationErrors.length > 0) {
      ctx.throw(validationErrors.join(','));
      return;
    }
    projectIntake.client.id = undefined;
    projectIntake.mouAmount = projectIntake.mouAmount || 0;
    const client = await createClient(projectIntake.client);
    projectIntake.client.id = client.id;
    projectIntake.status = 'submitted';
    projectIntake.id = undefined;

    const auth = ctx.state.auth as IAuth;
    projectIntake.createdUserId = auth.userId;

    const intake = await createIntake(projectIntake);
    projectIntake.id = intake.id;

    const contacts = [];
    for (let index = 0; index < projectIntake.contacts.length; index++) {
      projectIntake.contacts[index].id = undefined;
      contacts.push(await createContact(projectIntake.contacts[index]));
    }

    const projectIntakeContacts: IProjectIntakeContact[] = [];
    contacts.map(function(contact: any) {
      projectIntakeContacts.push(<IProjectIntakeContact>{
        projectIntake: <IProjectIntake>{ id: intake.id },
        contact: <IContact>{ id: contact.id }
      });
    });

    await createProjectIntakeContact(projectIntakeContacts);

    const projectRiskAnalysis: IProjectRiskAnalysis[] = [];
    projectIntake.risk.map(function(risk: any) {
      projectRiskAnalysis.push(<IProjectRiskAnalysis>{
        id: undefined,
        question: <IRiskQuestions>{ id: risk.questionId },
        answer: <IRiskAnswers>{ id: risk.answerId },
        intake: <IProjectIntake>{ id: intake.id },
        score: risk.score
      });
    });

    await CreateRiskAnalysis(projectRiskAnalysis);

    ctx.body = intake;
    ctx.body.contacts = contacts;
  } catch (err) {
    ctx.throw(err.message);
  }
};

export const updateApproveStatus = async (ctx: Koa.Context) => {
  try {
    const auth = ctx.state.auth as IAuth;

    const intake = await retrieveIntakeById(ctx.params.id);
    const newProject: IProject = {
      id: undefined,
      projectName: intake.projectName,
      client: intake.client,
      projectSector: intake.projectSector,
      commodityCode: intake.commodityCode,
      dueDate: null,
      completionDate: intake.estimatedCompletionDate,
      contractValue: intake.estimatedContractValue,
      mouAmount: intake.mouAmount,
      description: intake.description,
      leadUserId: null,
      backupUserId: null,
      createdUserId: auth.userId,
      isReprocurement: intake.isReprocurement,
      dateOfReprocurement: intake.dateOfReprocurement,
      previousContractBackground: intake.previousContractBackground,
      projectFailImpact: intake.projectFailImpact,
      projectSuccess: intake.projectSuccess
    };
    const projectData = await createProject(newProject);

    const intakeContacts = await retrieveIntakeContactByIntakeId(ctx.params.id);
    intakeContacts.map(function(intakeContact) {
      createProjectContact(<IProjectContact>{
        project: { id: projectData.id },
        contact: { id: intakeContact.contact.id }
      });
    });

    await updateIntake(ctx.params.id, {
      status: 'approved',
      projectId: projectData.id,
      approverUserId: auth.userId
    });
    ctx.body = {
      projectId: projectData.id
    };
  } catch (err) {
    ctx.throw(err.message);
  }
};

const validateIntakeForm = (intake: IProjectIntake) => {
  const validationErrors = [];
  if (intake.client) {
    const client = intake.client;

    // Business validation: Start.
    if (client.clientNo && client.clientNo.toString().length !== 3) {
      validationErrors.push('Client No should be a 3 digit number.');
    }
    if (
      client.responsibilityCenter &&
      client.responsibilityCenter.toString().length !== 5
    ) {
      validationErrors.push(
        'Responsibility Center should be a 5 digit number.'
      );
    }
    if (client.serviceCenter && client.serviceCenter.toString().length !== 5) {
      validationErrors.push('Service Center should be a 5 digit number.');
    }
    if (client.stob && client.stob.toString().length !== 4) {
      validationErrors.push('STOB should be a 4 digit number.');
    }
    if (client.projectCode && client.projectCode.toString().length !== 7) {
      validationErrors.push('Project Code should be a 7 digit number.');
    }
    // Business validation: End.

    if (!(client.ministry && client.ministry.id) && !client.isNonMinistry) {
      validationErrors.push('Ministry is required.');
    }

    if (!client.orgDivision) {
      validationErrors.push('Branch is required.');
    }

    if (!client.addressLine1) {
      validationErrors.push('Address is required.');
    }

    if (!client.city) {
      validationErrors.push('City is required.');
    }

    if (!client.postalCode) {
      validationErrors.push('Postal Code is required.');
    }
  } else {
    validationErrors.push('Client details not found.');
  }

  if (!intake.projectName) {
    validationErrors.push('Project Name is required.');
  }

  if (!intake.estimatedCompletionDate) {
    validationErrors.push('Estimated Value of Completion is required.');
  }

  if (!intake.previousContractBackground && intake.isReprocurement) {
    validationErrors.push('Background from the previous contract is required.');
  }
  if (!intake.projectFailImpact) {
    validationErrors.push(
      ' Potential impact if this project fails is required.'
    );
  }
  if (!intake.projectSuccess) {
    validationErrors.push('success look like for this project is required.');
  }

  if (!intake.dateOfReprocurement && intake.isReprocurement) {
    validationErrors.push('Date of Reprocurement is required.');
  }
  if (intake.estimatedContractValue <= 0) {
    validationErrors.push('Estimated value of contract cannot be zero.');
  } else if (!intake.estimatedContractValue) {
    validationErrors.push('Estimated value of contract is required.');
  }

  if (!(intake.projectSector && intake.projectSector.id)) {
    validationErrors.push('Project Sector is required.');
  }

  if (intake.contacts) {
    intake.contacts.map(function(contact) {
      let contactTypeLabel = '';
      if (contact.contactType === 'clientlead') {
        contactTypeLabel = 'Lead';
      } else if (contact.contactType === 'clientsponsor') {
        contactTypeLabel = 'Sponsor';
      } else {
        if (contact.email && !validateEmail(contact.email)) {
          validationErrors.push(contactTypeLabel + ' Email is not valid.');
        }
        return;
      }

      if (!contact.fullName) {
        validationErrors.push(contactTypeLabel + ' Name is required.');
      }

      if (!contact.orgPosition) {
        validationErrors.push(
          contactTypeLabel + ' Position Title is required.'
        );
      }

      if (!contact.email) {
        validationErrors.push(contactTypeLabel + ' Email is required.');
      } else if (!validateEmail(contact.email)) {
        validationErrors.push(contactTypeLabel + ' Email is not valid.');
      }

      if (!contact.phoneNumber) {
        validationErrors.push(contactTypeLabel + ' Phone Number is required.');
      }
    });
  } else {
    validationErrors.push('Contacts not found.');
  }

  return validationErrors;
};

const routerOpts: Router.IRouterOptions = {
  prefix: '/intake'
};

const router: Router = new Router(routerOpts);

router.get('/', authorize, getIntakesAction);
router.get('/:id', authorize, getIntakeByIdAction);
router.patch('/:id', authorize, updateIntakeByIdAction);
router.post('/', authorize, createIntakeAction);
router.post('/:id/approve', authorize, updateApproveStatus);

export default router;



