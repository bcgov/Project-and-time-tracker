const shouldDisplayItem = (item, router, auth, userRoles) => {
  // If the menu item has no URL just render it
  if (!(Object.prototype.hasOwnProperty.call(item, 'href'))) return true;

  const { routes } = router.options;
  // Ignore unsecured routes
  if (routes instanceof Array) {
    const securedRoutes = routes.filter((route) => {
      // Ignore routes with no meta
      if (!(Object.prototype.hasOwnProperty.call(route, 'meta'))) return false;
      // Ignore routes with no required auth
      if (!(route.meta.requiresAuth === true)) return false;

      return true;
    });

    // Filter item route from secured routes
    const itemRoutes = securedRoutes.filter((route) => {
      // Ignore secured routes that don't have any roles specified, we're not going to render them
      if (!(route.meta.roles instanceof Array)) return false;
      if (!(route.exact)) return false; // Ignore nested routes requiring params, they're out of scope
      return (route.path === item.href);
    });

    const itemRoute = (itemRoutes instanceof Array && itemRoutes.length > 0) ? itemRoutes[0] : undefined;
    if (itemRoute === undefined) return true; // It's okay to display, no secured route was referenced

    let isAuthorized = false;
    for (let idx = 0; idx < itemRoute.meta.roles.length; idx++) {
      if (userRoles && userRoles.includes(itemRoute.meta.roles[idx])) {
        isAuthorized = true;
        break;
      }
    }

    return isAuthorized;
  }
  return false;
};

const menuItems = [
  {
    header: '',
  },
  // {
  //   href: '/dashboard',
  //   title: 'Dashboard',
  //   icon: 'dashboard',
  // },
  {
    href: '/intake-intro',
    title: 'New Intake Request',
    icon: 'post_add ',
  },
  {
    href: '/intake-requests',
    title: 'Intake Requests',
    icon: 'inbox',
  },
  {
    href: '/projects',
    title: 'Projects',
    icon: 'folder',
  },
  {
    href: '/timesheets',
    title: 'Timesheets',
    icon: 'timelapse',
  },
  {
    href: '/finance',
    title: 'Finance',
    icon: 'attach_money',
  },
  {
    divider: true,
  },
  {
    href: '/admin',
    title: 'Admin',
    icon: 'lock_open',
  },
  {
    header: 'System',
  },
  {
    href: '/logout',
    title: 'Logout',
    icon: 'exit_to_app',
  },
];

export { shouldDisplayItem };

export default menuItems;
