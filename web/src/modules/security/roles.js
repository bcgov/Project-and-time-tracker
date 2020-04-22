import store from "@/store";

export default roles => {
  const keycloakAuth = store.getters.SECURITY_AUTH;
  if (keycloakAuth.authenticated) {
    let hasAccess = false;
    roles.forEach(role => {
      if (keycloakAuth.hasRealmRole(role)) {
        hasAccess = true;
      }
    });

    return hasAccess;
  }

  return false;
};
