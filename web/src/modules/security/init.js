/* eslint-disable */
import Keycloak from 'keycloak-js';
import store from '@/store';

const keycloakFileName = (process.env.VUE_APP_KEYCLOAK_JSON_FILENAME) ? process.env.VUE_APP_KEYCLOAK_JSON_FILENAME : 'keycloak-local';
// const keycloakAuth = new Keycloak(`/statics/${keycloakFileName}.json`);
const keycloakAuth = new Keycloak(`/${keycloakFileName}.json`);

const pageBasedOnRole = (role) => {
  let page = 'Unauthorized';
  switch (role) {
    case 'User': page = 'timeMachineIntakeForm'; break;
    case 'PSB_User': page = 'dashboard'; break;
    case 'PSB_Admin': page = 'dashboard'; break;
    default: break;
  }
  return page;
};

export default (next, roles, isLoggedIn = false) => {
  keycloakAuth
    .init({ onLoad: 'login-required', responseMode: 'query',"checkLoginIframe" : false })
    .success(() => {
      keycloakAuth.logoutUrl = `${keycloakAuth.authServerUrl}/realms/${keycloakAuth.realm}`
        + `/protocol/openid-connect/logout?redirect_uri=${document.baseURI}`;
      store.dispatch('authLogin', keycloakAuth);

      if (roles) {
        let hasAccess = false;
        let keycloakRole;
        roles.forEach((role) => {
          if (keycloakAuth.hasRealmRole(role)) {
            hasAccess = true;
            keycloakRole = role;
          }
        });

        if (hasAccess) {
          // Different landing pages for users according to role
          if (isLoggedIn) {
            const page = pageBasedOnRole(keycloakRole);
            next({ name: page });
          } else {
            next();
          }
        } else {
          next({ name: 'Unauthorized' });
        }
      } else {
        next();
      }

      setInterval(() => {
        keycloakAuth
          .updateToken(70)
          .success((refreshed) => {
            if (refreshed) {
              store.dispatch('authLogin', keycloakAuth);
            }
          })
          .error(() => {
            console.error('Failed to refresh token');
          });
      }, 60000);
    })
    .error(() => {
      console.log('failed to login');
    });
};
