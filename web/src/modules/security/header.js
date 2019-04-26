import store from '@/store';

export default () => {
  const keycloakAuth = store.getters.SECURITY_AUTH;
  return { Authorization: `Bearer ${keycloakAuth.token}` };
};
