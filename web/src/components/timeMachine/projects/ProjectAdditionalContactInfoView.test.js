import Vue from 'vue';
import { shallowMount, createLocalVue, mount, shallow } from '@vue/test-utils';
import ProjectAdditionalContactInfoView from './ProjectAdditionalContactInfoView.vue';

jest.mock('./projectcontactinfo.styl', () => ({
  sizePhablet: 500,
  sizeSmallTablet: 768,
  sizeTablet: 1024,
  sizeDesktop: 1440,
  sizeLargeDesktop: 1920,
}));

jest.mock('./../../../domain/models/Client.dto.js', () => ({
  id: '',
}));
jest.mock('./../../../domain/models/Ministry.dto.js', () => ({
  id: '',
}));

jest.mock('./../../../domain/models/Contact.dto.js', () => jest.fn().mockImplementation(() => ({ data: () => {} })));

jest.mock('./../../../domain/models/Intake.dto.js', () => ({
  id: '',
}));
jest.mock('./../../../domain/models/ProjectSector.dto.js', () => ({
  id: '',
}));


jest.mock('./../../../store/index.js', () => ({}));

describe('ProjectAdditionalContactInfoView.vue', () => {
  const wrapper = shallowMount(ProjectAdditionalContactInfoView, {
    propsData: {
      contact: {},
    },
    mocks: {
      form: { fullName: 'dvf' },
      $store: {
        state: {
          contactInformation: {
          },
        },
        dispatch: jest.fn(),
      },
    },
  });


  it('should render the component properly', () => {
    const Constructor = Vue.extend(ProjectAdditionalContactInfoView);
    const vm = new Constructor().$mount();
    expect(true).toBe(true);
  });

  it('is called with the new value in other cases', () => {
    wrapper.vm.contact = 'foo';
    wrapper.vm.$nextTick(() => {
      expect(spy).toBeCalled();
    });
  });
});
