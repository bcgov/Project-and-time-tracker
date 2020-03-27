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
                      <project-base-info ref="projectBaseInfo" :project="project"></project-base-info>
                    </v-card-text>
                  </v-card>
                  <v-card>
                    <div style="padding:5px;border-top-style: ridge;">
                      <div class="primary-heading">
                        <!-- <img src="@/assets/bulb.svg"> -->
                        <label class="sub-header-large" style="margin-left:25px">Notes</label>
                      </div>
                      <v-card-text>
                        <v-layout v-for="(item) in $store.state.allProjectNotes" :key="item.id">
                          <v-flex v-if="!item.parentId" d-flex justify-end>
                            <v-flex md12>
                              <div class="row">
                                <div class="column">
                                  <div class="card">
                                    <div class="headerdivstyle">
                                    <span class="headerspan" v-html="item.user.contact.fullName" />
                                    <span v-html="new Date(item.noteTime).toString().slice(0,15)" /></div>
                                    <br/>
                                    <span style="float:left;margin-left:3%;text-align: justify;padding-right: 30px;"  v-html="item.note" />
                                      <br/>
                                        <v-layout v-for="(inneritem) in $store.state.allProjectNotes" :key="inneritem.id">
                                          <div style="width:100%" v-if="(inneritem.parentId)&&(inneritem.parentId == item.id)">
                                            <br>
                                          <span style="float:left;margin-left:10%;text-align: justify;padding-right: 30px;font-weight:bold"  v-html="inneritem.user.contact.fullName" />  
                                          <span style="font-weight:bold;float: left;font-size: smaller;" v-html="new Date(inneritem.noteTime).toString().slice(0,15)" />
                                          <br>
                                          <span style="float:left;margin-left:10%;text-align: justify;padding-right: 30px;"  v-html="inneritem.note" />
                                          </div>
                                          </v-layout>
                                    <v-btn
                                      flat
                                      large
                                      color="primary"
                                      @click="replynotes(item.id)"
                                      style="margin-right: 80%;"
                                    >
                                      <svg
                                        xmlns="http://www.w3.org/2000/svg"
                                        width="24"
                                        height="24"
                                        viewBox="0 0 24 24"
                                      >
                                        <path
                                          d="M10 9V5l-7 7 7 7v-4.1c5 0 8.5 1.6 11 5.1-1-5-4-10-11-11z"
                                        />
                                      </svg> Reply
                                    </v-btn>
                                  </div>
                                </div>
                              </div>
                              <br />
                              <project-notes :ref=item.id></project-notes>
                            </v-flex>
                          </v-flex>
                        </v-layout>
                        <v-flex md12>
                          <project-notes ref="projectNoteNew"></project-notes>
                          <v-btn
                            style="margin-left: 77%;"
                            class="add-timesheet-button"
                            color="btnPrimary"
                            dark
                            @click="newnotes(1)"
                          >Add Note</v-btn>
                        </v-flex>
                      </v-card-text>
                    </div>
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
                  <v-tab
                    ripple
                    href="#finance"
                    v-if="project.client && !project.client.isNonMinistry"
                  >Finance Codes</v-tab>
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
                              <label class="sub-header-large">RFx Type and Phase #{{ index + 1 }}</label>
                            </v-flex>
                            <!-- <v-flex xs2>
                                <v-btn color="primary" @click="saveProjectRfxData(index)">Save</v-btn>
                            </v-flex>-->
                          </div>
                        </template>
                        <v-card>
                          <v-card-text>
                            <project-rfx :rfxData="rfx" :project="project" ref="rfxForm"></project-rfx>
                          </v-card-text>
                        </v-card>
                      </v-expansion-panel-content>
                    </v-expansion-panel>
                    <v-card>
                      <v-flex xs12>
                        <div>
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
                                :contactNameLabel="'Financial Contact Name'"
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
                                >-->
                                Procurement Log
                              </h4>
                            </v-flex>
                            <v-flex d-flex justify-end>
                              <procurement-log ref="ProcurementLog"></procurement-log>
                              <v-btn
                                class="add-timesheet-button"
                                color="btnPrimary"
                                dark
                                @click="newProcurementLog"
                              >Add Log</v-btn>
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
import Vue from "vue";
import VeeValidate from "vee-validate";
import RFxDto from "@/domain/models/RFx.dto";
import ContactDto from "@/domain/models/Contact.dto";
import Material from "vuetify/es5/util/colors";
import ProcurementLog from "./Procurementlog.vue";
import ProjectBaseInfo from "./ProjectBaseInfo.vue";
import projectNotes from "./projectNotes.vue";
import ProjectContactInfo from "./ProjectContactInfo.vue";
import ProjectRfx from "./ProjectRfx.vue";
import ProjectFinanceInfo from "./ProjectFinanceInfo.vue";
import projectRiskAssessment from "./ProjectRisk.vue";
import Snackbar from "../common/Snackbar.vue";
import ProjectAdditionalContactInfo from "./ProjectAddintionalContactInfo.vue";
import ProcurementLogTable from "./ProcurementLogTable.vue";

import "./project.styl";

Vue.use(VeeValidate);

const CLIENT_INFO_TYPES = {
  CLIENT_CONTACT: "clientcontact"
};

export default {
  components: {
    ProjectBaseInfo,
    projectNotes,
    ProjectContactInfo,
    ProjectRfx,
    ProjectFinanceInfo,
    Snackbar,
    ProjectAdditionalContactInfo,
    projectRiskAssessment,
    ProcurementLogTable,
    ProcurementLog
  },
  props: {
    title: String,
    ProcurementLog: {
      type: Function,
      default: () => {}
    }
  },
  $_veeValidate: { validator: "new" },
  computed: {
    project() {
      return this.$store.state.activeProject;
    },
    projectRfxData() {
      return this.$store.state.activeProjectRfxData;
    },
    // projectcomments() {
    //   return this.$store.state.allProjectNotes;
    // }
  },
  data() {
    
    return {
      rfxData: [new RFxDto()],
      projectId: "",
      enabled: true,
      initialLoad: true,
      color: Material,
      selectedTab: "tab-1",
      projectcomments : this.$store.state.allProjectNotes
     
    };
  },
  watch: {
    enabled() {
      if (!this.enabled) this.$refs.projectClient.reset();
    }
  },
  methods: {
    projectnotes() {
      return this.$store.state.allProjectNotes;
    },
    newProcurementLog() {
      this.$refs.ProcurementLog.reset();
      this.$refs.ProcurementLog.open();
    },
     replynotes(value) {
      let refvalue = value;
      console.log('refvalue', refvalue);

      this.$refs[refvalue][0].reset();
      this.$refs[refvalue][0].open(value);
    },
    newnotes(value) {
      this.$refs.projectNoteNew.reset();
      this.$refs.projectNoteNew.open(value);
    },
    // saveProjectRfxData(index) {
    //
    //   const data = this.projectRfxData[index];
    // },
    projectContactData(contactType) {
      const contactData = this.$store.getters.getProjectContactByType(
        contactType
      );
      if (
        this.initialLoad &&
        contactType === "clientcontact" &&
        this.$store.state.activeProjectContacts.length > 0
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
        this.$store.dispatch("fetchProject", { id: this.projectId });
        this.$store.dispatch("fetchProjectRFxData", { id: this.projectId });
        this.$store.dispatch("fetchProjectContacts", { id: this.projectId });
        this.$store.dispatch("fetchprojectRiskAnswers", { id: this.projectId });
        this.$store.dispatch("fetchAllProcurementLog", { id: this.projectId });
      }
       this.$store.dispatch("fetchAllProjectNotes", { id: this.projectId });
      this.$store.dispatch("fetchintakeRiskQuestions");
    },
    formatDate(date) {
      if (!date) return null;

      const [year, month, day] = date.split("-");
      return `${month}/${day}/${year}`;
    },
    parseDate(date) {
      if (!date) return null;

      const [month, day, year] = date.split("/");
      return `${year}-${month.padStart(2, "0")}-${day.padStart(2, "0")}`;
    },
    addNewRFx() {
      const allRFXValid = this.validateRFXForm();
      if (allRFXValid) {
        this.projectRfxData.push(new RFxDto());
      }
      console.log({ allRFXValid });
    },
    validateRFXForm() {
      // Validates all RFX Forms, true only if all forms are valid.
      // If one form is valid, return false

      if (this.$refs.rfxForm) {
        return (
          this.$refs.rfxForm.map(x => x.$refs.form.validate()).filter(x => !x)
            .length === 0 // Remove truthy values
        ); // See if any falsy values remain
      }
      return true;
    },
    async saveProjectContacts() {
      this.$refs.projectLead.Validate();
      this.$refs.projectSponsor.Validate();
      this.$refs.projectFinancier.Validate();
      const projectLeadForm = this.$refs.projectLead.form || undefined;
      const projectSponsorForm = this.$refs.projectSponsor.form || undefined;
      const projectFinancierForm =
        this.$refs.projectFinancier.form || undefined;
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
        projectFinancierForm
      ].filter(contact => contact !== undefined);
      if (contacts instanceof Array && contacts.length > 0) {
        await this.$store.dispatch("updateProjectContacts", {
          id: this.projectId,
          contacts
        });
        this.$refs.snackbar.displaySnackbar("success", "Saved");
      }
    },
    async saveFinanceCodes() {
      const projectFinanceForm =
        this.$refs.projectFinanceInfo.financeInfo || undefined;
      if (this.$refs.projectFinanceInfo.validate()) {
        if (this.project && this.project.client && this.project.client.id) {
          await this.$store
            .dispatch("updateProjectFinanceCodes", {
              id: this.project.client.id,
              financeCodes: projectFinanceForm
            })
            .then(
              () => {
                this.$refs.snackbar.displaySnackbar("success", "Updated");
              },
              err => {
                try {
                  const { message } = err.response.data.error;
                  this.$refs.snackbar.displaySnackbar("error", message);
                } catch (ex) {
                  this.$refs.snackbar.displaySnackbar(
                    "error",
                    "Failed to update"
                  );
                }
              }
            );
        }
      }
    },
    initializeRisk() {
      this.$refs.projectRiskAssessment.updateInitalData();
      this.$refs.projectRiskAssessment.editScreen = false;
    }
  },
  created() {
    while (this.$store.state.activeProjectContacts.length > 0) {
      this.$store.state.activeProjectContacts.pop();
    }

    // if no rfx, add one
    if (this.projectRfxData.length === 0) {
      console.log("addinging initial rfx");
      this.addNewRFx();
    }

    this.fetchData();
  }
};
</script>
<style scoped>
.column {
  float: left;
  width: 100%;
  padding: 0 10px;
}

/* Remove extra left and right margins, due to padding */
.row {
  margin: 0 -5px;
}

/* Clear floats after the columns */
.row:after {
  content: "";
  display: table;
  clear: both;
}

/* Responsive columns */
@media screen and (max-width: 600px) {
  .column {
    width: 100%;
    display: block;
    margin-bottom: 20px;
  }
}

/* Style the counter cards */
.card {
  box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
  padding: 0px;
  text-align: center;
}
.headerspan {
  margin-right: 80%;
}
.headerdivstyle {
background-color: #57789a;
    padding: 15px;
    color: white;
}
.notecontent {
  float: left;
  margin-left: 3%;
}
.replybutton {
  float: left;
}
</style>