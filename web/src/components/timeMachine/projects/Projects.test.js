import Vue from 'vue';
import { shallowMount, createLocalVue, mount, shallow } from '@vue/test-utils';
import Projects from './Projects.vue';

jest.mock('./projects.styl', () => ({
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

describe('Projects.vue', () => {
  it('renders a message and responds correctly to user input', () => {
    const wrapper = shallowMount(Projects, {
      data: {
        color: '',
        selectedTab: '',
      },
    });
  });
});
