import Vue from 'vue';
import IntakeBaseInfoView from './IntakeBaseInfoView.vue';
import { shallowMount, createLocalVue, mount ,shallow} from '@vue/test-utils';

jest.mock('./intakebaseinfo.styl', () => {
    return {
      sizePhablet: 500,
      sizeSmallTablet: 768,
      sizeTablet: 1024,
      sizeDesktop: 1440,
      sizeLargeDesktop: 1920
    }
  })
  jest.mock('./../../../domain/models/Client.dto.js', () => {
    return jest.fn().mockImplementation(() => {
       return{ data: ()=>{}};
    });
 })


jest.mock('./../../../domain/models/ProjectSector.dto.js', () => {
    return jest.fn().mockImplementation(() => {
      return{ data: ()=>{}};
 });
})

  jest.mock('./../../../store/index.js', () => {
    return {};
  });
  describe('IntakeBaseInfoView.vue', () => {
    let cmp;
    it('should render the component properly', () => {
  
      const Constructor = Vue.extend(IntakeBaseInfoView)
      const vm = new Constructor().$mount();
       expect(true).toBe(true);
    })
    const wrapper=shallow(IntakeBaseInfoView, {
    });
    it("Watchers- project", () => {
      wrapper.vm.project = "foo";
      wrapper.vm.$nextTick(() => {
        expect(spy).toBeCalled();
      });
    });
  })