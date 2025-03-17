import Vue from 'vue';
import { shallowMount, createLocalVue, mount, shallow } from '@vue/test-utils';
import Vuex from 'vuex';
import IntakeRequest from './IntakeRequests.vue';


jest.mock('./intakeRequest.styl', () => ({
  sizePhablet: 500,
  sizeSmallTablet: 768,
  sizeTablet: 1024,
  sizeDesktop: 1440,
  sizeLargeDesktop: 1920,
}));
jest.mock('./intakeformtable.styl', () => ({
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
jest.mock('./intakeformview.styl', () => ({
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

jest.mock('./../common/Snackbar.vue', () => ({
  sizePhablet: 500,
  sizeSmallTablet: 768,
  sizeTablet: 1024,
  sizeDesktop: 1440,
  sizeLargeDesktop: 1920,
}));

jest.mock('./IntakeFormsTable.vue', () => ({
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


const localVue = createLocalVue();
localVue.use(Vuex);

describe('IntakeRequest.vue', () => {
  it('should render the component properly', () => {
    const cmp = shallow(IntakeRequest, {
      mocks: {
        $store: {
          state: {
            intakeRequests: 'intakeRequests',
          },
        },
      },
      localVue,
    });

    const Constructor = Vue.extend(IntakeRequest);
    const vm = new Constructor().$mount();
    expect(true).toBe(true);
  });
});
