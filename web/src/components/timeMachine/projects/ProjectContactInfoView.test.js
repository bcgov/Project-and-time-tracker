import Vue from 'vue';
import ProjectContactInfoView from './ProjectContactInfoView.vue';
import { shallowMount, createLocalVue, mount, shallow } from '@vue/test-utils';

jest.mock('./projectcontactinfo.styl', () => {
  return {
    sizePhablet: 500,
    sizeSmallTablet: 768,
    sizeTablet: 1024,
    sizeDesktop: 1440,
    sizeLargeDesktop: 1920
  }
})

jest.mock('./../../../domain/models/Contact.dto.js', () => {
  return jest.fn().mockImplementation(() => {
    return { data: () => { } };
  });
})

jest.mock('./../../../store/index.js', () => {
  return {};
});

describe('ProjectContactInfoView.vue', () => {

  const wrapper = shallowMount(ProjectContactInfoView, {
    propsData: {
      contact: 'foo'
    },
    mocks: {
      form: {},
      $store: {
        state: {
          contactInformation: {
          }
        },
        dispatch: jest.fn()
      }
    }
  });

  it('should render the component properly', () => {
    const Constructor = Vue.extend(ProjectContactInfoView);
    expect(true).toBe(true);
  })

  describe('Watchers - contact', () => {
   
    // it("is called with the new value in other cases", () => {
    //   wrapper.vm.inputValue = "foo1";
    //   wrapper.vm.$nextTick(() => {
    //     expect(spy).toBeCalled();
    //     done();
    //   });
    // });

    it('is called with the new value in other cases', () => {
      wrapper.setData({wrapper:{contact:'foo1'}}) ;    
    })


  })



})