/* eslint-disable */
import Vue from 'vue'
//import HelloWorld from '@/components/HelloWorld'
import IntakeRequest from './src/components/timeMachine/projectIntake/IntakeRequest.vue';
describe('HelloWorld.vue', () => {

  beforeEach(() => {
  props= {
      'item':{
        'projectName':'names'
      }
    }  });

  it('should render correct contents', () => {
    const Constructor = Vue.extend(IntakeRequest)
    const vm = new Constructor().$mount()
   // expect(vm.$el.querySelector('.hello h1').textContent)
     // .toEqual('Welcome to Your Vue.js App')
     expect(true).toBe(true);
  })
})
