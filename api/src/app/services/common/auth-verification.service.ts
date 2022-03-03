import * as Koa from 'koa';
import * as HttpStatus from 'http-status-codes';
import fetch from 'node-fetch';
import { keycloakConfig } from '../../config/settings';
import { URLSearchParams } from 'url';
import { decodeKeycloakToken } from '../../utility/helper';

import {
  createUser,
  retrieveUserByReferenceId,
  updateUser,
} from '../client/user.service';
import { IUser } from '../../models/interfaces/i-user';
import { createContact } from '../client/contact.service';
import { IContact } from '../../models/interfaces/i-contact';
import { IAuth } from '../../models/interfaces/i-auth';
import { IKeycloakUserByRole } from '../../models/interfaces/i-keycloak-user-fetch-by-role';

// Token validation done in the app.ts file. all the requests go through this function
export const validateToken = async (
  ctx: Koa.Context,
  next: () => Promise<any>
) => {
  try {
    const url = `${keycloakConfig.url}/realms/${keycloakConfig.realmName}/protocol/openid-connect/userinfo`;
    const urlChecker = ctx.request.url;
    //console.log('validateToken URL: ', ctx.request.url);
    // assumes bearer token is passed as an authorization header
    if (ctx.headers.authorization) {
      const options = {
        method: 'GET',
        headers: {
          // add the token you received to the userinfo request, sent to keycloak
          Authorization: ctx.headers.authorization,
          'Content-Type': 'application/json',
        },
      };

      const response = await fetch(url, options);

      // console.log('validateToken response', { response });

      if (response.status !== 200) {
        // if the request status isn't "OK", the token is invalid
        ctx.status = HttpStatus.UNAUTHORIZED;
        console.log(`Keycloak request failed with HTTP code: ${response.status}`);
      } else {
        // the token is valid pass request onto your next function
        const data: any = await response.json();

        const authorizationData: any = decodeKeycloakToken(
          ctx.headers.authorization
        );
        // const permissions = authorizationData.resource_access[keycloakConfig.resourceName].roles;
        const authData = <IAuth>{
          fullName: data.name,
          referenceId: data.sub,
          role: [],
          // permissions: permissions
        };

        if (
          !(
            authorizationData.realm_access &&
            authorizationData.realm_access.roles
          )
        ) {
          throw Error('realm roles are not configured.');
        }
        const roles = ['PSB_Admin', 'PSB_Intake_User', 'PSB_User', 'User', 'manage_finances'];
        roles.forEach((role) => 
        {
          if (authorizationData.realm_access.roles.includes(role)) {
            authData.role.push(role);
          }
        });
        
        if (urlChecker.endsWith('/auth/verify'))
        {
          await verifyAndCreateOrUpdateUser(authData, data);
        }
        else
        {
          await updateAuthData(authData,data);
        }
        ctx.state.auth = authData;
        console.log('state.auth', ctx.state.auth)
        await next();
      }
    } else {
      // there is no token, don't process request further
      ctx.status = HttpStatus.UNAUTHORIZED;
      console.log('ARC Unauthorized 2 - changed');
    }
  } catch (error) {
    ctx.status = HttpStatus.UNAUTHORIZED;
    console.log('ARC Unauthorized 3');
    throw error;
  }
};

export const retrieveKeycloakAdminToken = async () => {
  try {
    const tokenUrl = `${keycloakConfig.url}/realms/${keycloakConfig.realmName}/protocol/openid-connect/token`;

    // console.log('retrieveKeycloakAdminToken URL', { tokenUrl });

    // ARC TODO - PROBLEM IS IN THIS FUNCTION. PARAMS ARE WRONG MAYBE?

    // console.log('retrieveKeycloakAdminToken keycloak config', { keycloakConfig})

    const tokenParams = new URLSearchParams();
    tokenParams.append('username', keycloakConfig.adminUserName);
    tokenParams.append('password', keycloakConfig.adminPassword);
    tokenParams.append('grant_type', 'password');
    tokenParams.append('client_id', keycloakConfig.resourceName);

    const response = await fetch(tokenUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: tokenParams,
    });

    // console.log('retrieveKeycloakAdminToken RESPONSE', { response })

    if (response.status !== 200) {
      throw Error(response.statusText);
    }
    const data: any = await response.json();
    return data.access_token;
  } catch (err) {
    throw err;
  }
};

export const retrieveKeycloakUsersByRole = async (
  role: string,
  token: string
) => {
  try {
    const url = `${keycloakConfig.url}/admin/realms/${keycloakConfig.realmName}/roles/${role}/users`;
    const response = await fetch(url, {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
    });

    if (response.status !== 200) {
      throw Error(response.statusText);
    }
    const data: IKeycloakUserByRole[] = await response.json();
    return data;
  } catch (err) {
    throw err;
  }
};

const verifyAndCreateOrUpdateUser = async (authData: IAuth, data: any) => {
  const user = await retrieveUserByReferenceId(data.sub);
  if (!user) {
    console.log(
      'ARC - User does not exist, creating contact with nam: ',
      authData.fullName
    );
    const contact: any = await createContact(<IContact>{
      fullName: authData.fullName,
      contactType: 'user',
    });
    console.log('ARC - Created contact.  ID: ', contact.id);
    const createdUser = await createUser(<IUser>{
      referenceId: authData.referenceId,
      role: authData.role[0],
      contact: {
        id: contact.id,
      },
    });
    authData.userId = createdUser.id;
    console.log('ARC - Created user ID:', createdUser.id);
  } else {
    if (user.role?user.role:'' !== authData.role[0]) {
      await updateUser(user.id, { role: authData.role[0] });
    }
    authData.userId = user.id;
  }
};
const updateAuthData = async (authData: IAuth, data: any) => {
  const user = await retrieveUserByReferenceId(data.sub);
  authData.userId = user.id;
};

