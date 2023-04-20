import Vuetify from 'vuetify/lib';
import { shallowMount, createLocalVue, mount,shallow } from '@vue/test-utils';
import IntakeSuccess from './IntakeSuccess.vue';


jest.mock('./intakesuccess.styl', () => {
  return {
    sizePhablet: 500,
    sizeSmallTablet: 768,
    sizeTablet: 1024,
    sizeDesktop: 1440,
    sizeLargeDesktop: 1920
  }
})

describe('IntakeSuccess.vue', () => {
  let localVue;
 
  let mockRouter=[{
    exact: true,
    path: '/authorize',
    name: 'authorize',
    component: IntakeSuccess,
    currentRoute:{id:'./intakeForm'},
    meta: { requiresAuth: true, roles: ['PSB_User', 'PSB_Admin', 'User'] },
    id:1
  }];
    localVue = createLocalVue();
    localVue.use(Vuetify, {});
  const wrapper=shallow(IntakeSuccess, {
   mocks:{ $router:mockRouter
   }
  });

  const mock = jest.fn();

  it('call logout function', () => {
    //mock("logout");
    wrapper.vm.logout();
    expect(wrapper.vm.$router.length).toBeGreaterThan(0);
  })
})
