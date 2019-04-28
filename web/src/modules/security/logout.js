import store from '@/store';

export default () => {
  const keycloakAuth = store.getters.SECURITY_AUTH;

  keycloakAuth.logout();
  store.dispatch('authLogout');
};
