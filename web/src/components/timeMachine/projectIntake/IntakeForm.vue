<template>
  <div class="intake-form">
    <snackbar ref="snackbar"></snackbar>
    <spinner ref="spinner"></spinner>
    <v-form>
      <v-container>
        <v-layout>
          <v-flex md12>
            <h1 class="intake-form-header">Project Intake Form</h1>
            <div
              class="my-3"
            >Complete the intake form to submit your project to the Procurement Services Division.</div>
            <template>
              <v-expansion-panel class="mt-4" v-model="panelStates[PROJECT_INFO].value" expand>
                <v-expansion-panel-content >
                  <!-- <v-expansion-panel-content> -->
                  <template v-slot:header>
                    <div class="primary-heading">
                      <img src="../../../images/projectinfo.svg">
                      <label class="sub-header-large">Project Information</label>
                    </div>
                  </template>
                  <v-card>
                    <v-card-text>
                      <intake-base-info
                        ref="intakeBaseInfo"
                        :project="intakeRequest"
                        :nextPanel="nextPanel"
                        :panelName="PROJECT_INFO"
                      ></intake-base-info>
                    </v-card-text>
                  </v-card>
                </v-expansion-panel-content>
              </v-expansion-panel>
              <v-expansion-panel class="mt-4" v-model="panelStates[CLIENTS_INFO].value" expand>
                <v-expansion-panel-content >
                  <template v-slot:header>
                    <div class="primary-heading">
                      <img src="../../../images/ministryinfo.svg">
                      <label class="sub-header-large">Ministry / Branch Information</label>
                    </div>
                  </template>
                  <v-card>
                    <v-card-text>
                      <!-- Only one client on the form for now, but there will be multiple in the future -->
                      <ministry-branch-info
                        ref="intakeClientInfo"
                        :ministry="intakeRequest.client"
                        :nextPanel="nextPanel"
                        :panelName="CLIENTS_INFO"
                      ></ministry-branch-info>
                    </v-card-text>
                  </v-card>
                </v-expansion-panel-content>
              </v-expansion-panel>
              <v-expansion-panel class="mt-4" v-model="panelStates[CONTACTS_INFO].value" expand>
                <v-expansion-panel-content>
                  <template v-slot:header>
                    <div class="primary-heading">
                      <img src="../../../images/contactinfo.svg">
                      <label class="sub-header-large">Contact Information</label>
                    </div>
                  </template>
                  <v-card>
                    <v-card-text>
                      <div>
                        <v-layout row wrap>
                          <v-flex xs12 md6 my-3>
                            <h3 class="v-form-container">Client Lead Contact Information</h3>
                            <project-contact-info
                              ref="projectLead"
                              :contact="getClientInfo(CLIENT_LEAD)"
                              :contactNameLabel="'Client Lead Name'"
                              :isRequired="true"
                            />
                          </v-flex>
                          <v-flex xs12 md6 my-3>
                            <h3 class="v-form-container">Executive Sponsor Contact Information</h3>
                            <project-contact-info
                              ref="projectSponsor"
                              :contact="getClientInfo(CLIENT_SPONSOR)"
                              :contactNameLabel="'Executive Sponsor Name'"
                              :isRequired="true"
                            />
                          </v-flex>
                          <v-flex xs12 md6 my-3>
                            <div>
                              <v-checkbox
                                color="primary"
                                v-model="enabled"
                                class="v-form-container"
                              >
                                <template v-slot:label>
                                  <h3>Additional Contact</h3>
                                </template>
                              </v-checkbox>
                            </div>
                            <project-additional-contact-info
                              v-if="enabled"
                              ref="projectContact"
                              :contact="getClientInfo(CLIENT_CONTACT)"
                              :contactNameLabel="'Contact Name'"
                              :isRequired="false"
                            />
                          </v-flex>
                        </v-layout>
                        <v-layout>
                          <v-flex xs12 py-2>
                            <div class="v-form-container">
                              <div class="v-form-actions">
                                <v-flex md12 mt-4>
                                  <v-btn color="default" @click="discard">Discard</v-btn>
                                  <v-btn
                                    :disabled="
                                      !(
                                        $store.state.projectInformation &&
                                        $store.state.ministryInformation &&
                                        $store.state.contactInformation
                                      )
                                    "
                                    color="primary"
                                    @click="submitForm"
                                  >Submit</v-btn>
                                </v-flex>
                              </div>
                            </div>
                          </v-flex>
                        </v-layout>
                      </div>
                    </v-card-text>
                  </v-card>
                </v-expansion-panel-content>
              </v-expansion-panel>
            </template>
          </v-flex>
        </v-layout>
      </v-container>
    </v-form>
  </div>
</template>
<script>
import assign from 'object-assign';
import Vue from 'vue';
import VeeValidate from 'vee-validate';
import { setTimeout } from 'timers';
import IntakeBaseInfo from './IntakeBaseInfo.vue';
import MinistryBranchInfo from '../common/MinistryBranchInfo.vue';
import Snackbar from '../common/Snackbar.vue';
import Spinner from '../common/Spinner.vue';
import ProjectContactInfo from '../projects/ProjectContactInfo.vue';
import ProjectAdditionalContactInfo from '../projects/ProjectAddintionalContactInfo.vue';
import './intakeform.styl';


Vue.use(VeeValidate);

const INTAKE_FORM_PANELS = {
  PROJECT_INFO: 'projectInfo',
  CLIENTS_INFO: 'clientInfo',
  CONTACTS_INFO: 'contactInfo',
};

const CLIENT_INFO_TYPES = {
  CLIENT_LEAD: 'clientlead',
  CLIENT_SPONSOR: 'clientsponsor',
  CLIENT_CONTACT: 'clientcontact',
};

export default {
  components: {
    IntakeBaseInfo,
    MinistryBranchInfo,
    ProjectContactInfo,
    ProjectAdditionalContactInfo,
    Snackbar,
    Spinner,
  },
  $_veeValidate: {
    validator: 'new',
  },
  data() {
    return {
      projectInformation: this.$store.state.projectInformation,
      ministryInformation: this.$store.state.ministryInformation,
      contactInformation: this.$store.state.contactInformation,
      valid: false,
      enabled: false,
      ...INTAKE_FORM_PANELS,
      panelStates: {
        [INTAKE_FORM_PANELS.PROJECT_INFO]: { value: [true] },
        [INTAKE_FORM_PANELS.CLIENTS_INFO]: { value: [false] },
        [INTAKE_FORM_PANELS.CONTACTS_INFO]: { value: [false] },
      },
      ...CLIENT_INFO_TYPES,
    };
  },
  computed: {
    intakeRequest() {
      return this.$store.state.activeIntakeRequest;
    },
  },
  methods: {
    fetchData() {
      const { params } = this.$router.currentRoute;
      const id = params.id || undefined;

      if (!(id === undefined)) {
        this.$store.dispatch('fetchIntakeRequest', { id: params.id });
      } else {
        this.$store.dispatch('clearActiveIntakeRequest');
      }
    },
    prevPanel(panelName) {
      const panelNames = Object.keys(this.panelStates);
      const panelCount = panelNames.length;
      const panelIdx = panelNames.indexOf(panelName);
      const nextPanelIdx = (panelIdx + 1) % panelCount;
      this.panelStates[panelNames[nextPanelIdx]].value = [true];
    },
    nextPanel(panelName) {
      const panelNames = Object.keys(this.panelStates);
      const panelCount = panelNames.length;
      const panelIdx = panelNames.indexOf(panelName);
      const nextPanelIdx = (panelIdx + 1) % panelCount;
      this.panelStates[panelNames[nextPanelIdx]].value = [true];

      const panels = document.querySelectorAll('.v-expansion-panel');
      const scrollOffset = panels[nextPanelIdx].offsetTop;

      setTimeout(() => {
        window.scrollTo({
          top: scrollOffset,
          behavior: 'smooth',
        });
      }, 400);
    },
    async submitForm() {
      this.$refs.projectLead.onNextClicked();
      this.$refs.projectSponsor.onNextClicked();
      const formData = assign({}, this.$refs.intakeBaseInfo.form, {
        client: this.$refs.intakeClientInfo.form,
        contacts: [],
      });
      const projectLead = this.$refs.projectLead.form || undefined;
      const projectSponsor = this.$refs.projectSponsor.form || undefined;
      let projectContact;
      if (this.enabled) projectContact = this.$refs.projectContact.form || undefined;
      // Set types - this could be done dynamically later, but definitely out of scope
      // and doing so wouldn't match the user interface that has been approved
      if (projectLead !== undefined) {
        projectLead.contactType = CLIENT_INFO_TYPES.CLIENT_LEAD;
      }

      if (projectSponsor !== undefined) {
        projectSponsor.contactType = CLIENT_INFO_TYPES.CLIENT_SPONSOR;
      }

      if (projectContact !== undefined) {
        projectContact.contactType = CLIENT_INFO_TYPES.CLIENT_CONTACT;
      }

      const contacts = [projectLead, projectSponsor, projectContact].filter(
        contact => contact !== undefined,
      );

      if (contacts instanceof Array && contacts.length > 0) {
        if (formData.contacts instanceof Array) {
          formData.contacts = formData.contacts.concat(contacts);
        }
      }

      if (
        this.$store.state.projectInformation
        && this.$store.state.ministryInformation
        && this.$store.state.contactInformation
      ) {
        this.$refs.spinner.open();
        formData.estimatedContractValue = parseFloat(formData.estimatedContractValue);
        formData.mouAmount = parseFloat(formData.mouAmount);

        this.$store.dispatch('addIntakeRequest', formData).then(
          () => {
            this.$refs.snackbar.displaySnackbar(
              'success',
              'Project Intake Form Submited.',
            );
            this.$refs.spinner.close();
            this.$router.push('intake-success');
          },
          (err) => {
            this.$refs.spinner.close();
            if (err && err.response && err.response.data) {
              const { message } = err.response.data.error;
              this.$refs.snackbar.displaySnackbar('error', message);
            } else {
              this.$refs.snackbar.displaySnackbar('error', 'Intake Request Error');
            }
          },

        );
      }
    },
    discard() {
      this.$refs.intakeBaseInfo.reset();
      this.$refs.intakeClientInfo.reset();
      this.$refs.projectLead.reset();
      this.$refs.projectSponsor.reset();
      this.$refs.projectContact.reset();
    },
    getClientInfo(infoType) {
      const contacts = this.$store.state.activeIntakeRequest.contacts || [];
      const clientInfo = contacts.find(contact => contact.contactType === infoType);
      return clientInfo;
    },
  },
  created() {
    this.fetchData();
  },
};
</script>

<style>
legend {
  margin-left: 1em;
}
</style>
