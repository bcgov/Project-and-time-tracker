<template>
  <div class="intake-form">
    <snackbar ref="snackbar"></snackbar>
    <spinner ref="spinner"></spinner>
    <v-form>
      <v-layout>
        <v-flex md12 class="intake-form-header-div">
          <h1 class="intake-form-header">Intake Form</h1>
          <div class="intake-sub-header">Complete the intake form to submit your project</div>
        </v-flex>
      </v-layout>
      <v-container>
        <v-stepper v-model="e1" alt-labels>
          <v-stepper-header>
            <v-stepper-step
              @click="checkedit(e1)"
              :editable="isEditPInnfo"
              edit-icon="1"
              :complete="e1 > 1"
              step="1"
            >
              Project
              <br />Information
            </v-stepper-step>
            <v-divider class="first-divider"></v-divider>
            <v-divider class="second-divider"></v-divider>
            <v-stepper-step
              @click="checkedit(e1)"
              :editable="isEditMBInfo"
              edit-icon="2"
              :complete="e1 > 2"
              step="2"
              >Ministry/Branch Information</v-stepper-step
            >
            <v-divider class="first-divider"></v-divider>
            <v-divider class="second-divider"></v-divider>
            <v-stepper-step
              @click="checkedit(e1)"
              :editable="isEditRiskInfo"
              edit-icon="3"
              :complete="e1 > 3"
              step="3"
            >
              Risk
              <br />Assessment
            </v-stepper-step>
            <v-divider class="first-divider"></v-divider>
            <v-divider class="second-divider"></v-divider>
            <v-stepper-step
              @click="checkedit(e1)"
              :editable="isEditContactInfo"
              edit-icon="4"
              :complete="e1 > 4"
              step="4"
            >
              Contact
              <br />Information
            </v-stepper-step>
            <v-divider class="first-divider"></v-divider>
            <v-divider class="second-divider"></v-divider>
            <v-stepper-step @click="checkedit(e1)" step="5">
              Review
              <br />& Submit
            </v-stepper-step>
          </v-stepper-header>

          <v-stepper-items>
            <v-stepper-content step="1">
              <template v-slot:header>
                <div class="primary-heading">
                  <img src="../../../images/projectinfo.svg" />
                  <label class="sub-header-large">Project Information</label>
                </div>
              </template>
              <v-card>
                <v-card-text>
                  <intake-base-info
                    ref="intakeBaseInfo"
                    :project="intakeRequest"
                    @next="clickfnctn(2)"
                  ></intake-base-info>
                </v-card-text>
              </v-card>
            </v-stepper-content>

            <v-stepper-content step="2">
              <template v-slot:header>
                <div class="primary-heading">
                  <img src="../../../images/ministryinfo.svg" />
                  <label class="sub-header-large">Ministry / Branch Information</label>
                </div>
              </template>
              <v-btn @click="backfn(1)" flat large color="primary">&lt; Project Information</v-btn>
              <v-card>
                <v-card-text>
                  <!-- Only one client on the form for now, but there will be multiple in the future -->
                  <ministry-branch-info
                    ref="intakeClientInfo"
                    :ministry="intakeRequest.client"
                    @next="clickfnctn(3)"
                  ></ministry-branch-info>
                </v-card-text>
              </v-card>
            </v-stepper-content>

            <v-stepper-content step="3">
              <template v-slot:header>
                <div class="primary-heading">
                  <img src="../../../images/ministryinfo.svg" />
                  <label class="sub-header-large">Risk Assessment</label>
                </div>
              </template>
              <v-btn @click="backfn(2)" flat large color="primary"
                >>Ministry / Branch Information</v-btn
              >
              <v-card>
                <v-card-text>
                  <!-- Only one client on the form for now, but there will be multiple in the future -->
                  <intake-risk-assessment
                    ref="intakeRiskAssessment"
                    :intakeRisk="intakeRiskQuestions"
                    @next="clickfnctn(4)"
                  ></intake-risk-assessment>
                </v-card-text>
              </v-card>
            </v-stepper-content>
            <v-stepper-content step="4">
              <template v-slot:header>
                <div class="primary-heading">
                  <img src="../../../images/contactinfo.svg" />
                  <label class="sub-header-large">Contact Information</label>
                </div>
              </template>
              <v-btn @click="backfn(3)" flat large color="primary">>Risk Assessment</v-btn>
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
                          @next="clickfnctn(5)"
                        />
                      </v-flex>
                      <v-flex xs12 md6 my-3>
                        <h3 class="v-form-container">Executive Sponsor Contact Information</h3>
                        <project-contact-info
                          ref="projectSponsor"
                          :contact="getClientInfo(CLIENT_SPONSOR)"
                          :contactNameLabel="'Executive Sponsor Name'"
                          :isRequired="true"
                          @next="clickfnctn(5)"
                        />
                      </v-flex>
                      <v-flex xs12 md6 my-3>
                        <h3 class="v-form-container">Financial Contact Information</h3>
                        <project-contact-info
                          ref="projectFinance"
                          :contact="getClientInfo(CLIENT_FINANCE)"
                          :contactNameLabel="'Client Finance Name'"
                          @next="clickfnctn(5)"
                        />
                      </v-flex>
                      <v-flex xs12 md6 my-3>
                        <div>
                          <v-checkbox color="primary" v-model="enabled" class="v-form-container">
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
                          @next="clickfnctn(5)"
                        />
                      </v-flex>
                    </v-layout>
                    <v-layout>
                      <v-flex xs12>
                        <div class="v-form-container">
                          <div class="v-form-actions">
                            <v-flex md-12 mt-4>
                              <v-btn
                                :disabled="
                                  !(
                                    $store.state.projectInformation &&
                                    $store.state.ministryInformation &&
                                    this.$store.state.intakeRiskQuestions
                                  )
                                "
                                color="primary"
                                @click="clickfnctn(5)"
                                >Next</v-btn
                              >
                            </v-flex>
                          </div>
                        </div>
                      </v-flex>
                    </v-layout>
                  </div>
                </v-card-text>
              </v-card>
            </v-stepper-content>
            <v-stepper-content step="5">
              <v-btn @click="backfn(4)" flat large color="primary">>Contact Information</v-btn>
              <v-card class="mb-12" color="grey lighten-1" height="200px">
                <intake-review
                  ref="intakeReview"
                  :intakeValues="reviewSubmit"
                  @switch="moveToComponent"
                ></intake-review>
              </v-card>
            </v-stepper-content>
          </v-stepper-items>
        </v-stepper>
        <v-flex xs12 py-2>
          <div class="v-form-container">
            <div class="v-form-actions">
              <v-flex md12 mt-4 v-if="e1 == 5">
                <v-btn color="default" @click="discard">Discard</v-btn>
                <v-btn
                  :disabled="
                    !(
                      $store.state.projectInformation &&
                      $store.state.ministryInformation &&
                      $store.state.contactInformation &&
                      this.$store.state.intakeRiskQuestions
                    )
                  "
                  color="primary"
                  @click="submitForm"
                  >Submit</v-btn
                >
              </v-flex>
            </div>
          </div>
        </v-flex>
      </v-container>
    </v-form>
  </div>
</template>
<script>
import assign from 'object-assign';
import Vue from 'vue';
import VeeValidate from 'vee-validate';
// import { setTimeout } from 'timers';
import IntakeBaseInfo from './IntakeBaseInfo.vue';
import MinistryBranchInfo from '../common/MinistryBranchInfo.vue';
import Snackbar from '../common/Snackbar.vue';
import Spinner from '../common/Spinner.vue';
import ProjectContactInfo from '../projects/ProjectContactInfo.vue';
import intakeRiskAssessment from './intakeRisk.vue';
import ProjectAdditionalContactInfo from '../projects/ProjectAddintionalContactInfo.vue';
import intakeReview from './IntakeReviewSubmit.vue';
import './intakeform.styl';
import parseCurrencyFloat from '../../../utils/parseCurrencyFloat';

Vue.use(VeeValidate);

const INTAKE_FORM_PANELS = {
  PROJECT_INFO: 'projectInfo',
  CLIENTS_INFO: 'clientInfo',
  CONTACTS_INFO: 'contactInfo',
  RISK_ASSESSMENT: 'intakeRisk',
};

const CLIENT_INFO_TYPES = {
  CLIENT_LEAD: 'clientlead',
  CLIENT_SPONSOR: 'clientsponsor',
  CLIENT_CONTACT: 'clientcontact',
  CLIENT_FINANCE: 'clientfinance',
};

export default {
  components: {
    IntakeBaseInfo,
    MinistryBranchInfo,
    ProjectContactInfo,
    ProjectAdditionalContactInfo,
    intakeRiskAssessment,
    intakeReview,
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
      intakeRiskQuestions: this.$store.state.intakeRiskQuestions,
      valid: false,
      enabled: false,
      isEditPInnfo: false,
      isEditMBInfo: false,
      isEditContactInfo: false,
      isEditRiskInfo: false,
      ...INTAKE_FORM_PANELS,
      ...CLIENT_INFO_TYPES,
      e1: 1,
      reviewSubmit: [],
    };
  },
  computed: {
    intakeRequest() {
      return this.$store.state.activeIntakeRequest;
    },
  },
  methods: {
    moveToComponent(item) {
      this.clickfnctn(item);
    },
    checkedit(msg) {
      if (msg === 1) {
        this.e1 = 1;
        this.isEditMBInfo = false;
        this.isEditContactInfo = false;
        this.isEditRiskInfo = false;
      } else if (msg === 2) {
        this.e1 = 2;
        this.isEditPInnfo = true;
        this.isEditMBInfo = false;
        this.isEditContactInfo = false;
        this.isEditRiskInfo = false;
      } else if (msg === 3) {
        this.e1 = 3;
        this.isEditPInnfo = true;
        this.isEditMBInfo = true;
        this.isEditContactInfo = false;
        this.isEditRiskInfo = false;
      } else if (msg === 4) {
        this.e1 = 4;
        this.isEditPInnfo = true;
        this.isEditMBInfo = true;
        this.isEditRiskInfo = true;
      } else {
        this.e1 = 5;
        //   this.isEditPInnfo = false;
        // this.isEditMBInfo = false;
        // this.isEditContactInfo = false;
        // this.isEditRiskInfo = false;
      }
    },
    fetchData() {
      const { params } = this.$router.currentRoute;
      const id = params.id || undefined;
      if (!(id === undefined)) {
        this.$store.dispatch('fetchIntakeRequest', { id: params.id });
      } else {
        this.$store.dispatch('clearActiveIntakeRequest');
      }
    },
    getRiskAnalysis() {
      const riskAnalysis = [];
      let riskAnalysisIndex = 0;
      let applicableQuestion = false;
      let scoreValue = 0;
      let selectedanswerTxt = '';
      for (let i = 0; i < this.$store.state.intakeRiskQuestions.length; i++) {
        scoreValue = 0;
        selectedanswerTxt = '';
        const question = this.$store.state.intakeRiskQuestions[i];
        if (typeof question.selectedAnswerId !== 'undefined' || question.selectedAnswerId) {
          const selectedAnswer = question.answer.filter(
            answer => answer.id === question.selectedAnswerId,
          );
          if (selectedAnswer && selectedAnswer[0]) {
            scoreValue = selectedAnswer[0].score;
            selectedanswerTxt = selectedAnswer[0].answer;
          }
          if (question.questionNo === 1) {
            applicableQuestion = question.showStatus;
            riskAnalysis[riskAnalysisIndex] = {
              questionId: question.id,
              answerId: question.selectedAnswerId,
              score: scoreValue,
              question: question.question,
              answer: selectedanswerTxt,
            };
            riskAnalysisIndex++;
          } else if (applicableQuestion) {
            riskAnalysis[riskAnalysisIndex] = {
              questionId: question.id,
              answerId: question.selectedAnswerId,
              score: scoreValue,
              question: question.question,
              answer: selectedanswerTxt,
            };
            riskAnalysisIndex++;
          }
        }
      }
      return riskAnalysis;
    },
    async submitForm() {
      this.$refs.projectLead.onNextClicked();
      this.$refs.projectSponsor.onNextClicked();
      this.$refs.projectFinance.onNextClicked();

      const riskAnalysis = this.getRiskAnalysis();
      const scoreSum = riskAnalysis.map(o => o.score).reduce((a, c) => a + c);
      const formData = assign({}, this.$refs.intakeBaseInfo.form, {
        client: this.$refs.intakeClientInfo.form,
        contacts: [],
        risk: riskAnalysis,
        riskScore: scoreSum,
      });
      const projectLead = this.$refs.projectLead.form || undefined;
      const projectSponsor = this.$refs.projectSponsor.form || undefined;
      const projectFinance = this.$refs.projectFinance.form || undefined;
      let projectContact;
      if (this.enabled) {
        projectContact = this.$refs.projectContact.form || undefined;
      }
      // Set types - this could be done dynamically later, but definitely out of scope
      // and doing so wouldn't match the user interface that has been approved
      if (projectLead !== undefined) {
        projectLead.contactType = CLIENT_INFO_TYPES.CLIENT_LEAD;
      }

      if (projectSponsor !== undefined) {
        projectSponsor.contactType = CLIENT_INFO_TYPES.CLIENT_SPONSOR;
      }
      if (projectFinance !== undefined) {
        projectFinance.contactType = CLIENT_INFO_TYPES.CLIENT_FINANCE;
      }
      if (projectContact !== undefined) {
        projectContact.contactType = CLIENT_INFO_TYPES.CLIENT_CONTACT;
      }

      const contacts = [projectLead, projectSponsor, projectFinance, projectContact].filter(
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
        && this.$store.state.intakeRisk
      ) {
        this.$refs.spinner.open();
        formData.estimatedContractValue = parseCurrencyFloat(formData.estimatedContractValue);
        this.$store.dispatch('addIntakeRequest', formData).then(
          () => {
            this.$refs.snackbar.displaySnackbar('success', 'Project Intake Form Submited.');
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
      this.$refs.projectFinance.reset();
      this.$refs.projectContact.reset();
      this.$refs.intakeRiskAssessment.reset();
    },
    getClientInfo(infoType) {
      const contacts = this.$store.state.activeIntakeRequest.contacts || [];
      const clientInfo = contacts.find(contact => contact.contactType === infoType);
      return clientInfo;
    },
    backfn(step) {
      if (step - 1 === 1) {
        this.isEditPInnfo = true;
        this.isEditRiskInfo = false;
        this.isEditContactInfo = false;
      } else if (step - 1 === 2) {
        this.isEditMBInfo = true;
        this.isEditPInnfo = true;
        this.isEditContactInfo = false;
      } else if (step - 1 === 3) {
        this.isEditMBInfo = true;
        this.isEditPInnfo = true;
        this.isEditRiskInfo = true;
      } else {
        this.isEditMBInfo = false;
        this.isEditPInnfo = false;
        this.isEditRiskInfo = false;
        this.isEditContactInfo = false;
      }
      this.e1 = step;
    },
    clickfnctn(step) {
      if (step === 5) {
        const value1 = this.$refs.projectLead.onNextClicked();
        const value2 = this.$refs.projectSponsor.onNextClicked();
        const value3 = this.$refs.projectFinance.onNextClicked();
        if (value1 && value2 && value3) {
          this.isEditMBInfo = true;
          this.isEditPInnfo = true;
          this.isEditRiskInfo = true;
          this.isEditContactInfo = true;
          this.e1 = step;
        }
        const riskAnalysis = this.getRiskAnalysis();
        const scoreSum = riskAnalysis.map(o => o.score).reduce((a, c) => a + c);
        const formData = assign({}, this.$refs.intakeBaseInfo.form, {
          client: this.$refs.intakeClientInfo.form,
          contacts: [],
          risk: riskAnalysis,
          riskScore: scoreSum,
        });
        const projectLead = this.$refs.projectLead.form || undefined;
        const projectSponsor = this.$refs.projectSponsor.form || undefined;
        const projectFinance = this.$refs.projectFinance.form || undefined;
        let projectContact;
        if (this.enabled) {
          projectContact = this.$refs.projectContact.form || undefined;
        }
        // Set types - this could be done dynamically later, but definitely out of scope
        // and doing so wouldn't match the user interface that has been approved
        if (projectLead !== undefined) {
          projectLead.contactType = CLIENT_INFO_TYPES.CLIENT_LEAD;
        }

        if (projectSponsor !== undefined) {
          projectSponsor.contactType = CLIENT_INFO_TYPES.CLIENT_SPONSOR;
        }
        if (projectFinance !== undefined) {
          projectFinance.contactType = CLIENT_INFO_TYPES.CLIENT_FINANCE;
        }
        if (projectContact !== undefined) {
          projectContact.contactType = CLIENT_INFO_TYPES.CLIENT_CONTACT;
        }

        const contacts = [projectLead, projectSponsor, projectFinance, projectContact].filter(
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
          && this.$store.state.intakeRisk
        ) {
          // this.$refs.spinner.open();
          formData.estimatedContractValue = parseCurrencyFloat(formData.estimatedContractValue);
          this.reviewSubmit = formData;
        }
      } else {
        if (step - 1 === 1) {
          this.isEditPInnfo = true;
          this.isEditRiskInfo = false;
          this.isEditContactInfo = false;
        } else if (step - 1 === 2) {
          this.isEditMBInfo = true;
          this.isEditPInnfo = true;
          this.isEditContactInfo = false;
        } else if (step - 1 === 3) {
          this.isEditMBInfo = true;
          this.isEditPInnfo = true;
          this.isEditRiskInfo = true;
        } else {
          this.isEditMBInfo = false;
          this.isEditPInnfo = false;
          this.isEditRiskInfo = false;
          this.isEditContactInfo = false;
        }
        this.e1 = step;
      }
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
