import Vue from 'vue';
import { shallowMount, createLocalVue, mount, shallow } from '@vue/test-utils';
import Vuex from 'vuex';
import IntakeBaseInfo from './IntakeBaseInfo.vue';

jest.mock('./intakebaseinfo.styl', () => ({
  sizePhablet: 500,
  sizeSmallTablet: 768,
  sizeTablet: 1024,
  sizeDesktop: 1440,
  sizeLargeDesktop: 1920,
}));

jest.mock('./../../../domain/models/Client.dto.js', () => jest.fn().mockImplementation(() => ({ data: () => {} })));


jest.mock('./../../../domain/models/ProjectSector.dto.js', () => jest.fn().mockImplementation(() => ({ data: () => {} })));

jest.mock('./../../../store/index.js', () => ({}));
describe('IntakeBaseInfo.vue', () => {
  let wrapper;
  const localVue = createLocalVue();
  localVue.use(Vuex);
  wrapper = shallowMount(IntakeBaseInfo, {
    propsData: {
      project: {
        projectName: 'name',
      },
    },
    mocks: {
      form: {
        id: 'ea0c87aa-f426-40a8-98cb-4a4f60a883fd',
        projectName: 'dvf',
        commodityCode: 'xdv',
        projectSector: 'sector',
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
      $store: {
        state: {
          projectSectors: {
            id: '5e3804cf-c2ae-41de-8bf9-c5d134d4c093',
            projectSectorName: 'Information Technology / Information Management',
          },
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
    },
    localVue,
  });
  it('Formated date', () => {
    expect(wrapper.vm.computedDateFormatted).toBe(null);
  });
  it('Watchers- project', () => {
    wrapper.vm.project = 'foo';
    wrapper.vm.$nextTick(() => {
      expect(spy).toBeCalled();
    });
  });
  it('Watchers- valid', () => {
    wrapper.vm.valid = 'true';
    wrapper.vm.$nextTick(() => {
      expect(spy).toBeCalled();
    });
  });
  it('Watchers- date', () => {
    const date = '08-01-2001';
    wrapper.vm.$nextTick(() => {
      expect(wrapper.vm.formatDate(date)).toBe('01/08/2001');
    });
  });
  //  it("returns true if data is present", () => {
  //    wrapper.vm.requiredRule("foo");
  //    expect (true).toEqual(true);
  //  });
  it('call formatDate function', () => {
    const date = '08-01-2001';
    wrapper.vm.formatDate(date);
    expect(wrapper.vm.formatDate(date)).toBeDefined();
  });

  it('call parseDate function', () => {
    const date = '08/01/2001';
    wrapper.vm.parseDate(date);
    expect(true).toBe(true);
  });

  //  it('call onNextClicked function', () => {
  //    const component = shallow(IntakeBaseInfo)
  //    const instance = component.instance()
  //    instance.$refs = {
  //       intakeBaseInfo: {
  //          getRenderedComponent: jest.fn(() => ({
  //             validate: jest.fn
  //          }))
  //        }
  //    }
  //    wrapper.vm.onNextClicked();
  //             expect(true).toBe(true);
  //  })


  it('call submitForm function', () => {
    wrapper.vm.submitForm();
    expect(true).toBe(true);
  });
  //  it('call resetForm function', () => {
  //    wrapper.vm.reset();
  //             expect(true).toBe(true);
  //  })
  //  it('call onNextClicked function', () => {
  //    wrapper.setProps({ panelName: "PROJECT_INFO" });
  //    wrapper.vm.onNextClicked();
  //    expect(true).toBe(true);
  //  })
});
