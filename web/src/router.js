import Vue from 'vue';
import Router from 'vue-router';
import security from '@/modules/security';
import store from '@/store';
/* import Dashboard from './components/dashboard/Dashboard.vue'; */
import Authorize from './components/login/Authorize.vue';
import Project from './components/timeMachine/projects/Project.vue';
import TimeMachineIntakeForm from './components/timeMachine/projectIntake/IntakeForm.vue';
import TimeMachineIntakeIntro from './components/timeMachine/projectIntake/IntakeIntroduction.vue';
import TimeMachineFinanceExport from './components/timeMachine/projects/ProjectFinanceExport.vue';
import TimeMachineIntakeRequests from './components/timeMachine/projectIntake/IntakeRequests.vue';
import TimeMachineIntakeSuccess from './components/timeMachine/projectIntake/IntakeSuccess.vue';
import TimeMachineProjects from './components/timeMachine/projects/Projects.vue';
import TimeMachineTimesheets from './components/timeMachine/timesheets/Timesheets.vue';
import AdminMain from './components/timeMachine/admin/AdminMain.vue';
import AdminMinistries from './components/timeMachine/admin/AdminMinistries.vue';
import AdminFinanceCodes from './components/timeMachine/admin/AdminFinanceCodes.vue';
import AdminHourlyRates from './components/timeMachine/admin/HourlyRates.vue';
import AdminRevenueRates from './components/timeMachine/admin/RevenueRates.vue';
import AdminRemoveMOU from './components/timeMachine/admin/RemoveMOU.vue';
import AdminRfxType from './components/timeMachine/admin/AdminRfxType.vue';
import AdminRfxPhase from './components/timeMachine/admin/AdminRfxPhase.vue';
import Unauthorized from './components/error/Unauthorized.vue';

Vue.use(Router);

const routes = [
  // Main app
  {
    exact: true,
    path: '/',
    name: 'main',
    redirect: '/authorize',
    meta: { requiresAuth: true },
    // route level code-splitting
    // this generates a separate chunk (filename.[hash].js) for this route
    // which is lazy-loaded when the route is visited
  },
  {
    exact: true,
    path: '/authorize',
    name: 'authorize',
    component: Authorize,
    meta: {
      requiresAuth: true,
      roles: ['PSB_User', 'PSB_Admin', 'User', 'PSB_Intake_User', 'manage_finances'],
    },
  },
  // {
  //   exact: true,
  //   path: '/intake-intro',
  //   name: 'dashboard',
  //   component: TimeMachineIntakeIntro,
  //   meta: { requiresAuth: true, roles: ['PSB_User', 'PSB_Admin'] },
  // },
  {
    exact: true,
    path: '/intake-intro',
    name: 'timemachineIntakeIntroduction',
    component: TimeMachineIntakeIntro,
    meta: { requiresAuth: true, roles: ['User', 'PSB_Admin', 'PSB_User', 'PSB_Intake_User'] },
  },
  {
    exact: true,
    path: '/finance',
    name: 'timemachineFinance',
    component: TimeMachineFinanceExport,
    meta: { requiresAuth: true, roles: ['manage_finances'] },
    // Uncomment this for adding finance role to admin
    // meta: { requiresAuth: true, roles: ["PSB_Admin", "manage_finances"] }
  },
  {
    exact: true,
    path: '/intake',
    name: 'timeMachineIntakeForm',
    component: TimeMachineIntakeForm,
    meta: { requiresAuth: true, roles: ['User', 'PSB_Admin', 'PSB_User', 'PSB_Intake_User'] },
  },
  {
    path: '/intake/:id',
    name: 'timeMachineIntakeFormDetails',
    component: TimeMachineIntakeForm,
    meta: { requiresAuth: true, roles: ['PSB_Admin', 'PSB_Intake_User'] },
  },
  {
    exact: true,
    path: '/intake-success',
    name: 'TimeMachineIntakeSuccess',
    component: TimeMachineIntakeSuccess,
    meta: { requiresAuth: true, roles: ['User', 'PSB_Admin', 'PSB_User', 'PSB_Intake_User'] },
  },
  {
    exact: true,
    path: '/intake-requests',
    name: 'timeMachineIntakeRequests',
    component: TimeMachineIntakeRequests,
    meta: { requiresAuth: true, roles: ['PSB_Admin', 'PSB_Intake_User'] },
  },
  {
    exact: true,
    path: '/projects',
    name: 'timeMachineProjects',
    component: TimeMachineProjects,
    meta: { requiresAuth: true, roles: ['PSB_User', 'PSB_Admin', 'PSB_Intake_User'] },
  },
  {
    exact: true,
    path: '/archived',
    name: 'archived',
    component: TimeMachineProjects,
    meta: { requiresAuth: true, roles: ['PSB_User', 'PSB_Admin', 'PSB_Intake_User'] },
  },
  {
    path: '/project',
    name: 'project',
    component: Project,
    meta: { requiresAuth: true, roles: ['PSB_User', 'PSB_Admin', 'PSB_Intake_User'] },
  },
  {
    path: '/project/:id',
    name: 'projectDetails',
    component: Project,
    meta: { requiresAuth: true, roles: ['PSB_User', 'PSB_Admin', 'PSB_Intake_User'] },
  },
  {
    exact: true,
    path: '/timesheets',
    name: 'timeMachineTimesheets',
    component: TimeMachineTimesheets,
    meta: { requiresAuth: true, roles: ['PSB_User', 'PSB_Admin', 'PSB_Intake_User'] },
  },
  {
    path: '/timesheets/:id',
    name: 'timeMachineTimesheetsDetails',
    component: TimeMachineTimesheets,
    meta: { requiresAuth: true, roles: ['PSB_User', 'PSB_Admin', 'PSB_Intake_User'] },
  },
  {
    exact: true,
    path: '/export',
    name: 'export',
    component: null,
    meta: { requiresAuth: true, roles: ['PSB_User', 'PSB_Admin', 'PSB_Intake_User'] },
  },
  {
    exact: true,
    path: '/admin',
    name: 'admin',
    component: AdminMain,
    meta: { requiresAuth: true, roles: ['PSB_Admin'] },
  },
  {
    exact: true,
    path: '/admin/ministries',
    name: 'admin-ministries',
    component: AdminMinistries,
    meta: { requiresAuth: true, roles: ['PSB_Admin'] },
  },
  {
    exact: true,
    path: '/admin/financecodes',
    name: 'admin-finance-codes',
    component: AdminFinanceCodes,
    meta: { requiresAuth: true, roles: ['PSB_Admin'] },
  },
  {
    exact: true,
    path: '/admin/hourly-rates',
    name: 'admin-hourly-rates',
    component: AdminHourlyRates,
    meta: { requiresAuth: true, roles: ['PSB_Admin'] },
  },
  {
    exact: true,
    path: '/admin/revenue-rates',
    name: 'admin-revenue-rates',
    component: AdminRevenueRates,
    meta: { requiresAuth: true, roles: ['PSB_Admin'] },
  },
  {
    exact: true,
    path: '/admin/remove-mou',
    name: 'admin-remove-mou',
    component: AdminRemoveMOU,
    meta: { requiresAuth: true, roles: ['PSB_Admin'] },
  },
  {
    exact: true,
    path: '/admin/rfx-phase',
    name: 'admin-rfx-phase',
    component: AdminRfxPhase,
    meta: { requiresAuth: true, roles: ['PSB_Admin'] },
  },
  {
    exact: true,
    path: '/admin/rfx-type',
    name: 'admin-rfx-type',
    component: AdminRfxType,
    meta: { requiresAuth: true, roles: ['PSB_Admin'] },
  },
  // Error routes
  {
    path: '/unauthorized',
    name: 'Unauthorized',
    props: true,
    component: Unauthorized,
  },
];

const router = new Router({
  mode: 'history',
  base: '/',
  routes,
});

router.beforeEach((to, from, next) => {
  if (to.path === '/logout') {
    router.push({ path: '/' }); // set default path before logout. this is required if the user tries to login with different role user, to redirect to the default page.
    security.logout();
  }

  if (to.meta.requiresAuth) {
    const { auth } = store.state.security;
    if (!auth.authenticated) {
      const isAuthPage = to.name === 'authorize';
      security.init(next, to.meta.roles, isAuthPage);
    } else if (to.meta.roles) {
      if (security.roles(to.meta.roles)) {
        next();
      } else {
        next({ name: 'Unauthorized' });
      }
    } else {
      next();
    }
  } else {
    next();
  }
});

export default router;
