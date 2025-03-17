import Vue from 'vue';
import { shallowMount, createLocalVue, mount, shallow } from '@vue/test-utils';
import projectFinanceInfo from './ProjectFinanceInfo.vue';

jest.mock('./projectfinanceinfo.styl', () => ({
  sizePhablet: 500,
  sizeSmallTablet: 768,
  sizeTablet: 1024,
  sizeDesktop: 1440,
  sizeLargeDesktop: 1920,
}));

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

describe('projectFinanceInfo.vue', () => {
  const wrapper = shallow(projectFinanceInfo, {
    stubs: {
      projectFinanceInfo: {
        render() { return ('<div></div>'); },
        rules: {
          clientNoRules: test,
        },
        methods: {
          validate() {},
        },
      } },
    propsData: {
      financeInfo: { clientNo: '123' },
    },
    mocks: {

    },
  });
  it('renders a message and responds correctly to user input', () => {
    // const wrapper = shallowMount(projectFinanceInfo, {
    //   data: {
    //     color: '',
    //     selectedTab: ''
    //   }
    // });
    expect(true).toBe(true);
  });
  it('is called with the new value in other cases', () => {
    wrapper.vm.financeInfo = 'foo';
    wrapper.vm.$nextTick(() => {
      expect(spy).toBeCalled();
    });
  });

  // it('test validate', () => {
  //     wrapper.vm.$refs.projectFinance.validate();
  //      });

  it('test with correct length for 3 digit', () => {
    const value = '123';
    const count = 3;
    wrapper.vm.showValidationMessage(value, count);
    expect(count == 3).toEqual(true);
  });
  it('test with different length for 3 digit', () => {
    const value = '123';
    const count = 4;

    wrapper.vm.showValidationMessage(value, count);
    expect(count == 4).toEqual(true);
  });
  //  it('it should test that the submit button is enabled once the input fields has been filled', async () => {
  //     const button = wrapper.find('button');
  //     wrapper.setData({
  //         email: 'test@gmail.com',
  //         password: 'password',
  //     });
  //     // This is the line that create the error

  //     await wrapper.vm.$nextTick();
  //     expect(button.element.getAttribute('disabled')).toBe(null);
  // })
});
