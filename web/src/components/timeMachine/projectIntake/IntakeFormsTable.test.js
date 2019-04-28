import Vue from 'vue';
import Vuetify from 'vuetify';
import { shallowMount, createLocalVue, mount, shallow } from '@vue/test-utils';
import IntakeFormsTable from './IntakeFormsTable.vue';
import Vuex from 'vuex';

jest.mock('./intakeformtable.styl', () => {
  return {
    sizePhablet: 500,
    sizeSmallTablet: 768,
    sizeTablet: 1024,
    sizeDesktop: 1440,
    sizeLargeDesktop: 1920
  }
})
jest.mock('./intakebaseinfo.styl', () => {
  return {
    sizePhablet: 500,
    sizeSmallTablet: 768,
    sizeTablet: 1024,
    sizeDesktop: 1440,
    sizeLargeDesktop: 1920
  }
})
jest.mock('./../projects/projectfinanceinfo.styl', () => {
  return {
    sizePhablet: 500,
    sizeSmallTablet: 768,
    sizeTablet: 1024,
    sizeDesktop: 1440,
    sizeLargeDesktop: 1920
  }
})
jest.mock('./intakeformview.styl', () => {
  return {
    sizePhablet: 500,
    sizeSmallTablet: 768,
    sizeTablet: 1024,
    sizeDesktop: 1440,
    sizeLargeDesktop: 1920
  }
})
jest.mock('./../projects/projectcontactinfo.styl', () => {
  return {
    sizePhablet: 500,
    sizeSmallTablet: 768,
    sizeTablet: 1024,
    sizeDesktop: 1440,
    sizeLargeDesktop: 1920
  }
})
jest.mock('./../common/confirm.styl', () => {
  return {
    sizePhablet: 500,
    sizeSmallTablet: 768,
    sizeTablet: 1024,
    sizeDesktop: 1440,
    sizeLargeDesktop: 1920
  }
})

jest.mock('./../../../domain/models/ProjectSector.dto.js', () => {
  return {
    'id': '',
    'projectSectorName': ''
  }
})
jest.mock('./../../../domain/models/Client.dto.js', () => {
  return {
    'id': ''
  }
})
jest.mock('./../../../domain/models/Ministry.dto.js', () => {
  return {
    'id': ''
  }
})
jest.mock('./../../../domain/models/Contact.dto.js', () => {
  return {
    'id': ''
  }
})
jest.mock('./../../../domain/models/Intake.dto.js', () => {
  return {
    'id': ''
  }
})

let localVuex = createLocalVue();
localVuex.use(Vuex);

const mock = jasmine.createSpy()

const confirm = {
  render() { },
  data:{
    type:'info',
    message:'test'
  },
  methods: {
    open: jest.fn(),
    agree: jest.fn()
  }
}

const snackbar = {
  render() { },
  methods: {
    displaySnackbar: jest.fn()
  }
}

describe('IntakeFormsTable.vue', () => {
  const wrapper = shallowMount(IntakeFormsTable, {
    propsData: {
      id: 1,
      title: 'foo'
    },
    stubs: { confirm, snackbar },
    mocks: {
      $store: {
        state: {
          intakeRequests: [
            {
              "id": "4bed5bc3-27a1-4a09-a079-5384369f191d",
              "projectName": "Test17",
              "estimatedCompletionDate": "2019-04-29T18:30:00.000Z",
              "status": "submitted",
              "orgDivision": "bbe",
              "ministryName": "Education",
              "projectId": null,
              "leadUserId": null,
              "backupUserId": null
            },
            {
              "id": "ec2ecb5e-4cca-44fd-8a1b-b5e4a617551b",
              "projectName": "wedewsf",
              "estimatedCompletionDate": "2019-07-22T18:30:00.000Z",
              "status": "submitted",
              "orgDivision": "sdc",
              "ministryName": "Finance",
              "projectId": null,
              "leadUserId": "566c374e-ea35-4c03-abc1-52f36e2514da",
              "backupUserId": "0c47067c-1b1f-4c73-ad78-99e7a484bae7"
            },
          ],
          users: [
            {
              "id": "566c374e-ea35-4c03-abc1-52f36e2514da",
              "referenceId": "a4d5132b-d823-4d99-ac73-57d37d655d6a",
              "role": "PSB_Admin",
              "contact": {
                "fullName": "Test Admin"
              }
            },
            {
              "id": "0c47067c-1b1f-4c73-ad78-99e7a484bae7",
              "referenceId": "031ea633-0329-4160-9a18-77e8ccafc6e2",
              "role": "PSB_User",
              "contact": {
                "fullName": "Test User"
              }
            },
            {
              "id": "a004d753-4ff4-46e5-ac2e-f37e647409b1",
              "referenceId": "031ea633-0329-4160-9a18-77e8ccafc6e2",
              "role": "PSB_User",
              "contact": {
                "fullName": "Test User"
              }
            }
          ]

        },
        dispatch: jest.fn()
      },

    }
  });

  it('test fetchData method ', () => {
    return wrapper.vm.fetchData();
    // expect(true).toBe(true);  
  });

  it('test viewRequest method ', () => {
    wrapper.vm.viewRequest(wrapper.vm.id);
  });

  it('test approveRequest method ', () => {
    wrapper.vm.approveRequest(wrapper.vm.id);
    wrapper.vm.$refs.confirm.open(() => {
      wrapper.vm.$refs.snackbar.displaySnackbar();
    });

  });


  it('test getProjectLead method ', () => {
    wrapper.vm.getProjectLead(wrapper.vm.intakeRequests[1].leadUserId);
  });

  it('test assignLead method ', () => {
    wrapper.vm.assignLead(wrapper.vm.intakeRequests[1].leadUserId, wrapper.vm.intakeRequests[1]);
  });

  it('test getProjectBackup method ', () => {
    wrapper.vm.getProjectBackup(wrapper.vm.intakeRequests[1].backupUserId);
  });

  it('test assignBackup method ', () => {
    wrapper.vm.assignBackup(wrapper.vm.intakeRequests[1].backupUserId, wrapper.vm.intakeRequests[1]);
  });
  it('test deleteRequest method ', () => {
    wrapper.vm.deleteRequest(wrapper.vm.id);
  });

})


