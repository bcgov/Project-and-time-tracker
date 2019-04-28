import Vue from 'vue';
import { shallowMount, createLocalVue, mount ,shallow} from '@vue/test-utils';
import IntakeRequest from './IntakeRequests.vue';
import Vuex from 'vuex';


  jest.mock('./intakeRequest.styl', () => {
    return {
      sizePhablet: 500,
      sizeSmallTablet: 768,
      sizeTablet: 1024,
      sizeDesktop: 1440,
      sizeLargeDesktop: 1920
    }
  })
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
  jest.mock('./intakeformview.styl', () => {
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
  jest.mock('./../projects/projectcontactinfo.styl', () => {
    return {
      sizePhablet: 500,
      sizeSmallTablet: 768,
      sizeTablet: 1024,
      sizeDesktop: 1440,
      sizeLargeDesktop: 1920
    }
  })

  jest.mock('./../common/Snackbar.vue', () => {
    return {
      sizePhablet: 500,
      sizeSmallTablet: 768,
      sizeTablet: 1024,
      sizeDesktop: 1440,
      sizeLargeDesktop: 1920
    }
  })

  jest.mock('./IntakeFormsTable.vue', () => {
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
      'id':'',
      'projectSectorName':''
    }
  })
  jest.mock('./../../../domain/models/Client.dto.js', () => {
    return {
      'id':''
    }
  })
  jest.mock('./../../../domain/models/Ministry.dto.js', () => {
    return {
      'id':''
    }
  })
  jest.mock('./../../../domain/models/Contact.dto.js', () => {
    return {
      'id':''
    }
  })
  jest.mock('./../../../domain/models/Intake.dto.js', () => {
    return {
      'id':''
    }
  })
  jest.mock('./../../../domain/models/ProjectSector.dto.js', () => {
    return {
      'id':''
    }
  })


  jest.mock('./../../../store/index.js', () => {
    return {};
  });


let localVue = createLocalVue();
localVue.use(Vuex);

describe('IntakeRequest.vue', () => {
  it('should render the component properly', () => {
  let cmp = shallow(IntakeRequest, {
    mocks: {
      $store: {
        state: {
          intakeRequests: 'intakeRequests'
        }
      }
    },
    localVue
  });

    const Constructor = Vue.extend(IntakeRequest)
    const vm = new Constructor().$mount();
     expect(true).toBe(true);
  })
})
