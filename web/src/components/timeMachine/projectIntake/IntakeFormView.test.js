import { shallowMount, createLocalVue, mount ,shallow} from '@vue/test-utils';
import IntakeFormView from './IntakeFormView.vue';
import Vuex from 'vuex';
import VueRouter from "vue-router";
import Index from "./../../../store/index.js";
import ProjectContactInfoView from './../projects/ProjectContactInfoView.vue';

jest.mock('./intakeformview.styl', () => {
    return {
      sizePhablet: 500,
      sizeSmallTablet: 768,
      sizeTablet: 1024,
      sizeDesktop: 1440,
      sizeLargeDesktop: 1920
    }
  });
  jest.mock('./intakebaseinfo.styl', () => {
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

describe('IntakeFormView.vue', () => {
  let mockRouter={
                exact: true,
                path: '/authorize',
                name: 'authorize',
                component: IntakeFormView,
                currentRoute:{ params: { id:1 } },
                meta: { requiresAuth: true, roles: ['PSB_User', 'PSB_Admin', 'User'] },
                id:1
              };


  const wrapper=shallowMount(IntakeFormView, {
                propsData: {
                  id: 1
                },
                mocks: {
                  $store: {
                    state: {
                      activeIntakeRequest: {  
                        "id":"ea0c87aa-f426-40a8-98cb-4a4f60a883fd",
                        "projectName":"dvf",
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

              // const wrapper = mount(IntakeFormView, {
              //   created: {
              //     fetchData() {
              //       return true
              //     }
              //   }
              // })

              
  it('check the child component reference is correct for project Lead', () => {
    const projLead = wrapper.find({ref:'projectLead'})
    expect(projLead.is(ProjectContactInfoView)).toBe(true);
  });
  it('check the child component reference is correct for projectSponsor', () => {
    const projSp = wrapper.find({ref:'projectSponsor'})
    expect(projSp.is(ProjectContactInfoView)).toBe(true);
  });
  it('check the child component reference is correct for projectContact', () => {
    const projCon = wrapper.find({ref:'projectContact'})
    expect(projCon.exists).toBeTruthy();
  });

  it('test getClientInfo', () => {
     var infoType="clientlead";
     
    wrapper.vm.getClientInfo(infoType);
    expect(wrapper.vm.enabled).toEqual(true);
  });


  
  it('test getClientInfo with less than 3 contacts', () => {
  
    const wrapper1=shallowMount(IntakeFormView, {
                propsData: {
                  id: 1
                },
                mocks: {
                  $store: {
                    state: {
                      activeIntakeRequest: {  
                        "id":"ea0c87aa-f426-40a8-98cb-4a4f60a883fd",
                        "projectName":"dvf",
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

    var infoType="clientlead";
    wrapper1.vm.getClientInfo(infoType);
    expect(wrapper1.vm.enabled).toEqual(false);
 });
})
