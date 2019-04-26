import Vue from 'vue';
import Projects from './Projects.vue';
import { shallowMount, createLocalVue, mount ,shallow} from '@vue/test-utils';

  jest.mock('./projects.styl', () => {
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
    return jest.fn().mockImplementation(() => {
       return{ data: ()=>{}};
    });
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

  describe('Projects.vue', () => {
    it('renders a message and responds correctly to user input', () => {
        const wrapper = shallowMount(Projects, {
          data: {
            color: '',
            selectedTab: ''
          }
        });
    })
  })

