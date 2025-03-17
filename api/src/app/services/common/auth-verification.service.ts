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
      //console.log('Validate Token');
      //console.log('validateToken response', { response });

      if (response.status !== 200) {
        // if the request status isn't "OK", the token is invalid
        ctx.status = HttpStatus.UNAUTHORIZED;
        console.log(`Keycloak request failed with HTTP code: ${response.status}`);
      } else {
        // the token is valid pass request onto your next function
        const data: any = await response.json();
        //console.log(data);
        const authorizationData: any = decodeKeycloakToken(
          ctx.headers.authorization
        );
        //console.log(authorizationData);
        // const permissions = authorizationData.resource_access[keycloakConfig.resourceName].roles;
        const authData = <IAuth>{
          fullName: data.given_name +' '+ data.family_name,
          referenceId: data.sub,
          role: [],
          // permissions: permissions
        };

        /* console.log("authData: ");
        console.log(authData); */

        if (
          !(
            authorizationData.client_roles
          )
        ) {
          throw Error('roles are not configured.');
        }
        const roles = ['PSB_Admin', 'PSB_Intake_User', 'PSB_User', 'User', 'Manage_Finances'];
        roles.forEach((role) => 
        {
          if (authorizationData.client_roles.includes(role)) {
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
        //console.log('state.auth', ctx.state.auth)
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


const verifyAndCreateOrUpdateUser = async (authData: IAuth, data: any) => {
  // console.log("verifyAndCreateOrUpdateUser");
  const user = await retrieveUserByReferenceId(data.sub);
  if (!user) {
    console.log(
      'ARC - User does not exist, creating contact with name: ',
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

