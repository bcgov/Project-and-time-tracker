import { shallowMount, createLocalVue, mount, shallow } from '@vue/test-utils';
import Vuex from 'vuex';
import VueRouter from 'vue-router';
import IntakeForm from './IntakeForm.vue';

jest.mock('./intakeform.styl', () => ({
  sizePhablet: 500,
  sizeSmallTablet: 768,
  sizeTablet: 1024,
  sizeDesktop: 1440,
  sizeLargeDesktop: 1920,
}));

jest.mock('./intakeformview.styl', () => ({
  sizePhablet: 500,
  sizeSmallTablet: 768,
  sizeTablet: 1024,
  sizeDesktop: 1440,
  sizeLargeDesktop: 1920,
}));
jest.mock('./intakebaseinfo.styl', () => ({
  sizePhablet: 500,
  sizeSmallTablet: 768,
  sizeTablet: 1024,
  sizeDesktop: 1440,
  sizeLargeDesktop: 1920,
}));
jest.mock('./../projects/projectfinanceinfo.styl', () => ({
  sizePhablet: 500,
  sizeSmallTablet: 768,
  sizeTablet: 1024,
  sizeDesktop: 1440,
  sizeLargeDesktop: 1920,
}));
jest.mock('./../projects/projectcontactinfo.styl', () => ({
  sizePhablet: 500,
  sizeSmallTablet: 768,
  sizeTablet: 1024,
  sizeDesktop: 1440,
  sizeLargeDesktop: 1920,
}));

jest.mock('./../common/confirm.styl', () => ({
  sizePhablet: 500,
  sizeSmallTablet: 768,
  sizeTablet: 1024,
  sizeDesktop: 1440,
  sizeLargeDesktop: 1920,
}));
jest.mock('./../common/spinner.styl', () => ({
  sizePhablet: 500,
  sizeSmallTablet: 768,
  sizeTablet: 1024,
  sizeDesktop: 1440,
  sizeLargeDesktop: 1920,
}));
jest.mock('./../common/Snackbar.vue', () => ({
  sizePhablet: 500,
  sizeSmallTablet: 768,
  sizeTablet: 1024,
  sizeDesktop: 1440,
  sizeLargeDesktop: 1920,
}));

jest.mock('./../../../domain/models/ProjectSector.dto.js', () => ({
  id: '',
  projectSectorName: '',
}));
jest.mock('./../../../domain/models/Client.dto.js', () => ({
  id: '',
}));
jest.mock('./../../../domain/models/Ministry.dto.js', () => ({
  id: '',
}));
jest.mock('./../../../domain/models/Contact.dto.js', () => ({
  id: '',
}));
jest.mock('./../../../domain/models/Intake.dto.js', () => ({
  id: '',
}));
jest.mock('./../../../domain/models/ProjectSector.dto.js', () => ({
  id: '',
}));
jest.mock('./../../../store/index.js', () => ({}));


const localVuex = createLocalVue();
localVuex.use(Vuex);
const localVue = createLocalVue();
localVue.use(VueRouter);

describe('IntakeForm.vue', () => {
  const mockRouter = {
    exact: true,
    path: '/authorize',
    name: 'authorize',
    component: IntakeForm,
    currentRoute: { params: { id: 1 } },
    meta: { requiresAuth: true, roles: ['PSB_User', 'PSB_Admin', 'User'] },
    id: 1,
  };

  const open = jest.fn().mockImplementation(() => ({ open: () => {} }));

  const wrapper = shallow(IntakeForm, {
    stubs: {
      intakeBaseInfo: {
        data: {
          form: [],
        },
        form: [],
        render() { return ('<div></div>'); },
        methods: {
          reset() {},
        },
      },
      MinistryBranchInfo: {
        render() { return ('<div>j</div>'); },
        methods: {
          reset() {},
        },
      },
      ProjectContactInfo: {
        render() { return ('<div></div>'); },
        data: {
          form: '',
        },
        form: 'ss',
        methods: {
          reset() {},
          onNextClicked() {},
        },
      },
      ProjectAdditionalContactInfo: {
        render() { return ('<div></div>'); },
        methods: {
          reset() {},
        },
      },
      ProjectContact: {
        render() { return ('<div></div>'); },
        methods: {
          reset() {},
        },
      },
      spinner: {
        render() { return ('<div></div>'); },
        methods: {
          open() {},
        },
      },
    },
    propsData: {
      id: 1,
    },
    mocks: {
      $store: {
        state: {
          projectInformation: {
            id: 'ea0c87aa-f426-40a8-98cb-4a4f60a883fd',
            projectName: 'dvf',
          },
          contactInformation: {
            id: 'ea0c87aa-f426-40a8-98cb-4a4f60a883fd',
            projectName: 'dvf',
            commodityCode: 'xdv',
            estimatedCompletionDate: '2019-04-29',
            estimatedContractValue: 34,
          },
          ministryInformation: {
            id: 'ea0c87aa-f426-40a8-98cb-4a4f60a883fd',
            ministryName: 'dvf' },
          activeIntakeRequest: {
            id: 'ea0c87aa-f426-40a8-98cb-4a4f60a883fd',
            projectName: 'dvf',
            commodityCode: 'xdv',
            estimatedCompletionDate: '2019-04-29',
            estimatedContractValue: 34,
            mouAmount: 44,
            description: 'xdv',
            status: 'approved',
            projectId: '4e474f0d-8e48-43cb-b085-39dddeff91c7',
            createdUserId: '566c374e-ea35-4c03-abc1-52f36e2514da',
            approverUserId: '566c374e-ea35-4c03-abc1-52f36e2514da',
            dateCreated: '2019-04-16T15:15:51.676Z',
            dateModified: '2019-04-16T15:25:06.414Z',
            client: {
              id: 'e048e463-c97c-45e7-9a33-b26f43ae6baa',
              clientNo: null,
              responsibilityCenter: null,
              serviceCenter: null,
              stob: null,
              projectCode: null,
              orgDivision: 'xdv',
              email: '',
              addressLine1: 'sd',
              addressLine2: 'sxvd',
              city: 'sdfv',
              province: '',
              country: '',
              postalCode: 'sdv',
              dateCreated: '2019-04-16T15:15:50.715Z',
              dateModified: '2019-04-16T15:15:50.715Z',
              ministry: {
                id: 'b15ee92e-5131-4f4e-bd9e-443e8f6b81b5',
                ministryName: 'Health',
              },
            },
            projectSector: {
              id: '5e3804cf-c2ae-41de-8bf9-c5d134d4c093',
              projectSectorName: 'Information Technology / Information Management',
            },
            contacts: [
              {
                id: '2e7dcdc9-2b3c-4430-b0c7-a3a91782b877',
                contactType: 'clientlead',
                fullName: 'gtyj',
                orgName: 'zxc',
                orgPosition: 'zsc',
                email: 'zxd@dfg.ghn',
                phoneNumber: '1111111111',
                addressLine1: '',
                addressLine2: '',
                city: '',
                province: '',
                country: '',
                postalCode: '',
                dateCreated: '2019-04-16T15:15:52.627Z',
                dateModified: '2019-04-16T15:31:08.485Z',
              },
              {
                id: '2e7dcdc9-2b3c-4430-b0c7-a3a91782b877',
                contactType: 'clientlead',
                fullName: 'gtyj',
                orgName: 'zxc',
                orgPosition: 'zsc',
                email: 'zxd@dfg.ghn',
                phoneNumber: '1111111111',
                addressLine1: '',
                addressLine2: '',
                city: '',
                province: '',
                country: '',
                postalCode: '',
                dateCreated: '2019-04-16T15:15:52.627Z',
                dateModified: '2019-04-16T15:31:08.485Z',
              },
              {
                id: '9859d222-909b-4458-86a7-2d960006c14b',
                contactType: 'clientsponsor',
                fullName: 'xdf',
                orgName: 'zxc',
                orgPosition: 'zxdc',
                email: 'dsvf@dfg.gvb',
                phoneNumber: '1111111111',
                addressLine1: '',
                addressLine2: '',
                city: '',
                province: '',
                country: '',
                postalCode: '',
                dateCreated: '2019-04-16T15:15:53.591Z',
                dateModified: '2019-04-16T15:31:10.521Z',
              },
            ],
          },
        },
        dispatch: jest.fn(),
      },
      $router: mockRouter,
    },
  });

  it('fetchdata', () => {
    wrapper.vm.fetchData();
    expect(wrapper.vm.$router.currentRoute.params.id).toBe(1);
  });

  it('prevPanel function', () => {
    wrapper.vm.panelStates = {
      panel1: { id: 'first', value: '1' },
      panel2: { id: 'second', value: '2' },
    };
    const panelName = { id: 'first', value: '1' };
    wrapper.vm.prevPanel(panelName);
    expect(wrapper.vm.panelStates.panel1.id).toEqual(panelName.id);
  });

  it('getClientInfo', () => {
    const infoType = 'clientlead';
    wrapper.vm.getClientInfo(infoType);
    expect(wrapper.vm.$store.state.activeIntakeRequest.contacts.length).toBe(3);
  });
  it('submitForm fnctn', () => {
    wrapper.vm.submitForm();
  });

  // it('nextPanel fnctn', () => {
  //   wrapper.vm.panelStates = {
  //     'panel2':{'id':'second', 'value':'12'},
  //     'panel1':{'id':'first', 'value':'1'}
  //   }
  //   var panelName={'id':'first', 'value':'1'};
  //   wrapper.vm.nextPanel(panelName);
  //   });
});
