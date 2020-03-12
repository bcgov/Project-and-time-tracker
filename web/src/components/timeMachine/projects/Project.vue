<template>
  <div class="project-form">
    <snackbar ref="snackbar"></snackbar>
    <v-form>
      <v-container>
        <v-layout>
          <v-flex md12>
            <template>
              <v-expansion-panel class="mt-3" :value="0">
                <v-expansion-panel-content>
                  <template v-slot:header>
                    <div class="primary-heading">
                      <!-- <img src="@/assets/bulb.svg"> -->
                      <label class="sub-header-large">Project Overview</label>
                    </div>
                  </template>
                  <v-card>
                    <v-card-text>
                      <project-base-info
                        ref="projectBaseInfo"
                        :project="project"
                      ></project-base-info>
                    </v-card-text>
                  </v-card>
                </v-expansion-panel-content>
              </v-expansion-panel>

              <!--

  Temporarily commented out, but will be restored after demo.

  <div>
  <v-expansion-panel class="mt-4" :value=0>
  <v-expansion-panel-content>
  <template v-slot:header>
      <div class="primary-heading">
              <label class="sub-header-large">Notes</label>
              <label class="sub-header-large">-----------To do-----------------</label>
</div>
</template>
</v-expansion-panel-content>
</v-expansion-panel>
              </div>-->
              <div>
                <v-tabs class="mt-4">
                  <v-tab ripple href="#rfx">RFx Type and Phase</v-tab>
                  <v-tab ripple href="#contacts">Contacts</v-tab>
                  <v-tab ripple href="#finance" v-if="project.client && !project.client.isNonMinistry"
                    >Finance Codes</v-tab
                  >
                  <v-tab ripple href="#risk" @click="initializeRisk()">Risk</v-tab>
                  <v-tab ripple href="#procurement">Procurement Log</v-tab>
                  <v-flex justify-end align-end>
                    <v-text-field
                      class="search-bar"
                      prepend-inner-icon="search"
                      label="Search"
                      single-line
                      hide-details
                    ></v-text-field>
                  </v-flex>
                  <!-- RFx Type and Phases -->
                  <v-tab-item value="rfx">
                    <v-expansion-panel
                      v-for="(rfx, index) in projectRfxData"
                      :key="rfx.id"
                      :value="0"
                      class="rfx-summary-panel"
                    >
                      <v-expansion-panel-content>
                        <template v-slot:header>
                          <div class="primary-heading">
                            <!-- <img src="@/assets/bulb.svg"> -->
                            <v-flex xs11>
                              <label class="sub-header-large"
                                >RFx Type and Phase #{{ index + 1 }}</label
                              >
                            </v-flex>
                            <!-- <v-flex xs2>
                                <v-btn color="primary" @click="saveProjectRfxData(index)">Save</v-btn>
                            </v-flex>-->
                          </div>
                        </template>
                        <v-card>
                          <v-card-text>
                            <project-rfx :rfxData="rfx" :project="project"></project-rfx>
                          </v-card-text>
                        </v-card>
                      </v-expansion-panel-content>
                    </v-expansion-panel>
                    <v-card>
                      <v-flex xs12>
                        <div class="v-form-actions">
                          <v-flex md12 py-3 px-4>
                            <v-btn color="primary" @click="addNewRFx">
                              <v-icon left dark>add</v-icon>Add Another RFx Type
                            </v-btn>
                          </v-flex>
                        </div>
                      </v-flex>
                    </v-card>
                  </v-tab-item>
                  <!-- Project Contacts-->
                  <v-tab-item value="contacts" class="contacts">
                    <v-card>
                      <v-card-text>
                        <div>
                          <v-layout row wrap>
                            <v-flex xs12 md6 my-3>
                              <h3 class="v-form-container">Client Lead</h3>
                              <project-contact-info
                                ref="projectLead"
                                :contact="projectContactData('clientlead')"
                                :contactNameLabel="'Client Lead Name'"
                                :isRequired="true"
                              />
                            </v-flex>
                            <v-flex xs12 md6 my-3>
                              <h3 class="v-form-container">Executive Sponsor</h3>
                              <project-contact-info
                                ref="projectSponsor"
                                :contact="projectContactData('clientsponsor')"
                                :contactNameLabel="'Executive Sponsor Name'"
                                :isRequired="true"
                              />
                            </v-flex>
                            <v-flex xs12 md6 my-3>
                              <h3 class="v-form-container">Financial Contact</h3>
                              <project-contact-info
                                ref="projectFinancier"
                                :contact="projectContactData('clientfinance')"
                                :contactNameLabel="'Client Financiar Name'"
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
                                ref="projectClient"
                                :contact="projectContactData('clientcontact')"
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
                                    <v-btn color="primary" @click="saveProjectContacts">Save</v-btn>
                                  </v-flex>
                                </div>
                              </div>
                            </v-flex>
                          </v-layout>
                        </div>
                      </v-card-text>
                    </v-card>
                  </v-tab-item>
                  <!-- Finance Codes -->
                  <v-tab-item value="finance">
                    <v-card>
                      <v-card-text>
                        <project-finance-info
                          ref="projectFinanceInfo"
                          v-if="project && project.client"
                          :financeInfo="project.client"
                        ></project-finance-info>
                        <v-flex xs12 py-2>
                          <div class="v-form-container">
                            <div class="v-form-actions">
                              <v-flex md12 mt-4>
                                <v-btn color="primary" @click="saveFinanceCodes">Save</v-btn>
                              </v-flex>
                            </div>
                          </div>
                        </v-flex>
                      </v-card-text>
                    </v-card>
                  </v-tab-item>
                  <!-- RISK -->
                  <v-tab-item value="risk">
                    <v-card>
                      <v-card-text>
                        <project-risk-assessment
                          ref="projectRiskAssessment"
                          :projectId="projectId"
                          v-if="project"
                        ></project-risk-assessment>
                      </v-card-text>
                    </v-card>
                  </v-tab-item>
                  <!-- PROCUREMENT LOG -->
                  <v-tab-item value="procurement">
                    <v-expansion-panel class="mt-4" :value="0">
                      <v-expansion-panel-content>
                        <v-container grid-list-xl fluid class="custom-manage-projects-container">
                          <v-layout>
                            <v-flex md12>
                              <h4 class="projects-header">
                                <!-- <v-icon style="margin:0 2px 5px 0">fas fa-lightbulb</v-icon
                                > -->
                                Procurement Log
                              </h4>
                            </v-flex>
                            <v-flex>
                              <v-btn color="primary">Add Log</v-btn>
                            </v-flex>
                          </v-layout>
                          <v-layout row wrap>
                            <v-flex xs12>
                              <procurement-log-table></procurement-log-table>
                            </v-flex>
                          </v-layout>
                        </v-container>
                      </v-expansion-panel-content>
                    </v-expansion-panel>
                  </v-tab-item>
                </v-tabs>
              </div>
            </template>
          </v-flex>
        </v-layout>
      </v-container>
    </v-form>
  </div>
</template>

<script>
import Vue from 'vue';
import VeeValidate from 'vee-validate';
import RFxDto from '@/domain/models/RFx.dto';
import ContactDto from '@/domain/models/Contact.dto';
import Material from 'vuetify/es5/util/colors';
import Procurementlog from './Procurementlog.vue';
import ProjectBaseInfo from './ProjectBaseInfo.vue';
import ProjectContactInfo from './ProjectContactInfo.vue';
import ProjectRfx from './ProjectRfx.vue';
import ProjectFinanceInfo from './ProjectFinanceInfo.vue';
import projectRiskAssessment from './ProjectRisk.vue';
import Snackbar from '../common/Snackbar.vue';
import ProjectAdditionalContactInfo from './ProjectAddintionalContactInfo.vue';
import ProcurementLogTable from './ProcurementLogTable.vue';

import './project.styl';

Vue.use(VeeValidate);

const CLIENT_INFO_TYPES = {
  CLIENT_CONTACT: 'clientcontact',
};

export default {
  components: {
    ProjectBaseInfo,
    ProjectContactInfo,
    ProjectRfx,
    ProjectFinanceInfo,
    Snackbar,
    ProjectAdditionalContactInfo,
    projectRiskAssessment,
    ProcurementLogTable,
  },
  $_veeValidate: { validator: 'new' },
  computed: {
    project() {
      return this.$store.state.activeProject;
    },
    projectRfxData() {
      return this.$store.state.activeProjectRfxData;
    },
  },
  data() {
    return {
      rfxData: [new RFxDto()],
      projectId: '',
      enabled: true,
      initialLoad: true,
      color: Material,
      selectedTab: 'tab-1',
    };
  },
  watch: {
    enabled() {
      if (!this.enabled) this.$refs.projectClient.reset();
    },
  },
  methods: {
    // saveProjectRfxData(index) {
    //
    //   const data = this.projectRfxData[index];
    // },
    projectContactData(contactType) {
      const contactData = this.$store.getters.getProjectContactByType(contactType);
      if (
        this.initialLoad
        && contactType === 'clientcontact'
        && this.$store.state.activeProjectContacts.length > 0
      ) {
        if (this.$store.state.activeProjectContacts.length > 2) {
          this.enabled = true;
        } else {
          this.enabled = false;
        }
        this.initialLoad = false;
      }
      return contactData && contactData.id ? contactData : new ContactDto();
    },
    fetchData() {
      const { params } = this.$router.currentRoute;
      const id = params.id || undefined;

      if (!(id === undefined)) {
        this.projectId = id;
        this.$store.dispatch('fetchProject', { id: this.projectId });
        this.$store.dispatch('fetchProjectRFxData', { id: this.projectId });
        this.$store.dispatch('fetchProjectContacts', { id: this.projectId });
        this.$store.dispatch('fetchprojectRiskAnswers', { id: this.projectId });
      }
      this.$store.dispatch('fetchintakeRiskQuestions');
    },
    formatDate(date) {
      if (!date) return null;

      const [year, month, day] = date.split('-');
      return `${month}/${day}/${year}`;
    },
    parseDate(date) {
      if (!date) return null;

      const [month, day, year] = date.split('/');
      return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
    },
    addNewRFx() {
      this.projectRfxData.push(new RFxDto());
    },
    async saveProjectContacts() {
      this.$refs.projectLead.Validate();
      this.$refs.projectSponsor.Validate();
      this.$refs.projectFinancier.Validate();
      const projectLeadForm = this.$refs.projectLead.form || undefined;
      const projectSponsorForm = this.$refs.projectSponsor.form || undefined;
      const projectFinancierForm = this.$refs.projectFinancier.form || undefined;
      const projectContactForm = this.$refs.projectClient
        ? this.$refs.projectClient.form
        : undefined;
      if (projectContactForm !== undefined) {
        projectContactForm.contactType = CLIENT_INFO_TYPES.CLIENT_CONTACT;
      }
      const contacts = [
        projectLeadForm,
        projectSponsorForm,
        projectContactForm,
        projectFinancierForm,
      ].filter(contact => contact !== undefined);
      if (contacts instanceof Array && contacts.length > 0) {
        await this.$store.dispatch('updateProjectContacts', {
          id: this.projectId,
          contacts,
        });
        this.$refs.snackbar.displaySnackbar('success', 'Saved');
      }
    },
    async saveFinanceCodes() {
      const projectFinanceForm = this.$refs.projectFinanceInfo.financeInfo || undefined;
      if (this.$refs.projectFinanceInfo.validate()) {
        if (this.project && this.project.client && this.project.client.id) {
          await this.$store
            .dispatch('updateProjectFinanceCodes', {
              id: this.project.client.id,
              financeCodes: projectFinanceForm,
            })
            .then(
              () => {
                this.$refs.snackbar.displaySnackbar('success', 'Updated');
              },
              (err) => {
                try {
                  const { message } = err.response.data.error;
                  this.$refs.snackbar.displaySnackbar('error', message);
                } catch (ex) {
                  this.$refs.snackbar.displaySnackbar('error', 'Failed to update');
                }
              },
            );
        }
      }
    },
    initializeRisk() {
      this.$refs.projectRiskAssessment.updateInitalData();
      this.$refs.projectRiskAssessment.editScreen = false;
    },
  },
  created() {
    while (this.$store.state.activeProjectContacts.length > 0) {
      this.$store.state.activeProjectContacts.pop();
    }

    this.fetchData();
  },
};
</script>
