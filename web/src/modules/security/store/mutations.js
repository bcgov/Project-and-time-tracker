import * as types from './types';

export default {
  [types.SECURITY_AUTH](state, keycloakAuth) {
    if (keycloakAuth) {
      state.auth = keycloakAuth;
      sessionStorage.setItem('keycloak_token', keycloakAuth.token);
      localStorage.setItem('keycloak_user', JSON.stringify(keycloakAuth.idTokenParsed));
    } else {
      sessionStorage.removeItem('keycloak_token');
    }
  },
};
