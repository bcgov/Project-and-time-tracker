import { shallowMount, createLocalVue, mount ,shallow} from '@vue/test-utils';

import Vuex from 'vuex';
import VueRouter from "vue-router";
import ProjectContactInfoView from './../projects/ProjectContactInfoView.vue';
import AddNewTimeRecord from './AddNewTimeRecord.vue';
// jest.mock('./intakeformview.styl', () => {
//     return {
//       sizePhablet: 500,
//       sizeSmallTablet: 768,
//       sizeTablet: 1024,
//       sizeDesktop: 1440,
//       sizeLargeDesktop: 1920
//     }
//   });
  jest.mock('./addnewtimerecord.styl', () => {
    return {
      sizePhablet: 500,
      sizeSmallTablet: 768,
      sizeTablet: 1024,
      sizeDesktop: 1440,
      sizeLargeDesktop: 1920
    }
  });
  
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

  jest.mock('./../common/confirm.styl', () => {
    return {
      sizePhablet: 500,
      sizeSmallTablet: 768,
      sizeTablet: 1024,
      sizeDesktop: 1440,
      sizeLargeDesktop: 1920
    }
  })
  jest.mock('./../common/spinner.styl', () => {
    return {
      sizePhablet: 500,
      sizeSmallTablet: 768,
      sizeTablet: 1024,
      sizeDesktop: 1440,
      sizeLargeDesktop: 1920
    }
  })

  jest.mock('./../../../domain/models/TimesheetEntry.dto.js', () => {
    return {
      'id':'',
      'projectSectorName':''
    }
  })
  jest.mock('./../../../domain/models/RFx.dto.js', () => {
    return {
      'id':'',
      'projectSectorName':''
    }
  })
  jest.mock('./../../../domain/models/RFxPhase.dto.js', () => {
    return {
      'id':'',
      'projectSectorName':''
    }
  })
  jest.mock('./../../../domain/models/Project.dto.js', () => {
    return {
      'id':'',
      'projectSectorName':''
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


let localVuex = createLocalVue();
localVuex.use(Vuex);
let localVue = createLocalVue();
localVue.use(VueRouter);

describe('AddNewTimeRecord.vue', () => {
  let mockRouter={
                exact: true,
                path: '/authorize',
                name: 'authorize',
                component: AddNewTimeRecord,
                currentRoute:{id:'./addnewTimeRecord'},
                meta: { requiresAuth: true, roles: ['PSB_User', 'PSB_Admin', 'User'] },
                id:1
              };


  const wrapper=shallowMount(AddNewTimeRecord, {
                $data:{
                  valid:true
                },
                stubs: {
                  form: { 
                    data:{
                      form:[]
                    },
                    form:[],
                    render() { return ('<div></div>') },
                    methods: {
                      resetValidation() {}
                    }
                  }
                },
                propsData: {
                  id: 1
                },
                mocks: {
                  form:{
                    hour:1
                  },
                  $store: {
                    state: {
                      users: {  
                        "id":"ea0c87aa-f426-40a8-98cb-4a4f60a883fd",
                        "referenceId":"123",
                        "commodityCode":"xdv",
                        "estimatedCompletionDate":"2019-04-29",
                        "estimatedContractValue":34,
                        "mouAmount":44,
                        "description":"xdv",
                        "status":"approved",
                        "projectId":"4e474f0d-8e48-43cb-b085-39dddeff91c7",
                        "createdUserId":"566c374e-ea35-4c03-abc1-52f36e2514da",
                        "approverUserId":"566c374e-ea35-4c03-abc1-52f36e2514da",
                        "dateCreated":"2019-04-16T15:15:51.676Z",
                        "dateModified":"2019-04-16T15:25:06.414Z",
                        "client":{  
                           "id":"e048e463-c97c-45e7-9a33-b26f43ae6baa",
                           "clientNo":null,
                           "responsibilityCenter":null,
                           "serviceCenter":null,
                           "stob":null,
                           "projectCode":null,
                           "orgDivision":"xdv",
                           "email":"",
                           "addressLine1":"sd",
                           "addressLine2":"sxvd",
                           "city":"sdfv",
                           "province":"",
                           "country":"",
                           "postalCode":"sdv",
                           "dateCreated":"2019-04-16T15:15:50.715Z",
                           "dateModified":"2019-04-16T15:15:50.715Z",
                           "ministry":{  
                              "id":"b15ee92e-5131-4f4e-bd9e-443e8f6b81b5",
                              "ministryName":"Health"
                           }
                        },
                        "projectSector":{  
                           "id":"5e3804cf-c2ae-41de-8bf9-c5d134d4c093",
                           "projectSectorName":"Information Technology / Information Management"
                        },
                        "contacts":[  
                           {  
                              "id":"2e7dcdc9-2b3c-4430-b0c7-a3a91782b877",
                              "contactType":"clientlead",
                              "fullName":"gtyj",
                              "orgName":"zxc",
                              "orgPosition":"zsc",
                              "email":"zxd@dfg.ghn",
                              "phoneNumber":"1111111111",
                              "addressLine1":"",
                              "addressLine2":"",
                              "city":"",
                              "province":"",
                              "country":"",
                              "postalCode":"",
                              "dateCreated":"2019-04-16T15:15:52.627Z",
                              "dateModified":"2019-04-16T15:31:08.485Z"
                           },
                           {  
                            "id":"2e7dcdc9-2b3c-4430-b0c7-a3a91782b877",
                            "contactType":"clientlead",
                            "fullName":"gtyj",
                            "orgName":"zxc",
                            "orgPosition":"zsc",
                            "email":"zxd@dfg.ghn",
                            "phoneNumber":"1111111111",
                            "addressLine1":"",
                            "addressLine2":"",
                            "city":"",
                            "province":"",
                            "country":"",
                            "postalCode":"",
                            "dateCreated":"2019-04-16T15:15:52.627Z",
                            "dateModified":"2019-04-16T15:31:08.485Z"
                         },
                           {  
                              "id":"9859d222-909b-4458-86a7-2d960006c14b",
                              "contactType":"clientsponsor",
                              "fullName":"xdf",
                              "orgName":"zxc",
                              "orgPosition":"zxdc",
                              "email":"dsvf@dfg.gvb",
                              "phoneNumber":"1111111111",
                              "addressLine1":"",
                              "addressLine2":"",
                              "city":"",
                              "province":"",
                              "country":"",
                              "postalCode":"",
                              "dateCreated":"2019-04-16T15:15:53.591Z",
                              "dateModified":"2019-04-16T15:31:10.521Z"
                           }
                        ]
                     }
                    },
                    dispatch: jest.fn()
                  },
                  $router:mockRouter
                }
              });
              

  it('test closeDialog', () => {
    wrapper.vm.closeDialog();
    expect(wrapper.vm.dialog).toEqual(false);
  });

  it('test timeSheetEntry(enteredHours)', () => {
    var enteredHours=25;
    wrapper.vm.timeSheetEntry(enteredHours);
    expect(wrapper.vm.form.hour).toEqual(24);
  });

  // it('test reset', () => {
  //   wrapper.vm.$refs = {
  //     form:{}
  //   }
  //   wrapper.vm.reset();
  //  // expect(wrapper.vm.dialog).toEqual(false);
  //});
})
