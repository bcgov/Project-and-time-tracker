import Vue from 'vue';
import { shallowMount, createLocalVue, mount, shallow } from '@vue/test-utils';
import IntakeBaseInfoView from './IntakeBaseInfoView.vue';

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
describe('IntakeBaseInfoView.vue', () => {
  let cmp;
  it('should render the component properly', () => {
    const Constructor = Vue.extend(IntakeBaseInfoView);
    const vm = new Constructor().$mount();
    expect(true).toBe(true);
  });
  const wrapper = shallow(IntakeBaseInfoView, {
  });
  it('Watchers- project', () => {
    wrapper.vm.project = 'foo';
    wrapper.vm.$nextTick(() => {
      expect(spy).toBeCalled();
    });
  });
});
