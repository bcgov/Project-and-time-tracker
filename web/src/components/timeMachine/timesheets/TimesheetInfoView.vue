<template>
  <div>
    <v-form>
      <v-container>
        <v-layout>
          <v-flex md12 column>
            <template>
              <v-card>
                <v-card-text>
                  <label class="sub-header-large">Project Information</label>
                  <!-- <intake-base-info-view
                    ref="intakeBaseInfoView"
                    :project="intakeRequest"
                    :panelName="PROJECT_INFO"
                  ></intake-base-info-view> -->
                </v-card-text>
              </v-card>

              <v-card>
                <v-card-text>
                  <label class="sub-header-large">Ministry / Branch Information</label>
                  <!-- <ministry-branch-info-view
                    ref="intakeClientInfoView"
                    :ministry="intakeRequest.client"
                    :panelName="CLIENTS_INFO"
                  ></ministry-branch-info-view> -->
                </v-card-text>
              </v-card>

              <v-card>
                <v-card-text>
                  <label class="sub-header-large">Contact Information</label>
                  <div>
                    <v-layout row wrap>
                      <v-flex xs12 md6 my-3>
                        <h3>Client Lead Contact Information</h3>
                        <!-- <project-contact-info-view
                          ref="projectLead"
                          :contact="getClientInfo(CLIENT_LEAD)"
                          :contactNameLabel="'Client Lead Name'"
                        /> -->
                      </v-flex>
                      <v-flex xs12 md6 my-3>
                        <h3>Executive Sponsor Contact Information</h3>
                        <!-- <project-contact-info-view
                          ref="projectSponsor"
                          :contact="getClientInfo(CLIENT_SPONSOR)"
                          :contactNameLabel="'Executive Sponsor Name'"
                        /> -->
                      </v-flex>
                    </v-layout>
                  </div>
                  <v-layout row wrap>
                    <v-flex xs12 md6 my-3 v-if="isEnabled(CLIENT_FINANCE)">
                      <h3>Financial Contact Information</h3>
                      <!-- <project-contact-info-view
                        ref="projectSponsor"
                        :contact="getClientInfo(CLIENT_FINANCE)"
                        :contactNameLabel="'Executive Sponsor Name'"
                      /> -->
                    </v-flex>
                    <v-flex xs12 md6 my-3 v-if="isEnabled(CLIENT_CONTACT)">
                      <h3>Additional Contact</h3>
                      <!-- <project-additional-contact-info-view
                        ref="projectContact"
                        :contact="getClientInfo(CLIENT_CONTACT)"
                        :contactNameLabel="'Contact Name'"
                      /> -->
                    </v-flex>
                  </v-layout>
                </v-card-text>
              </v-card>
            </template>
          </v-flex>
        </v-layout>
      </v-container>
    </v-form>
  </div>
</template>

<script>
// import IntakeBaseInfoView from './IntakeBaseInfoView.vue';
// import MinistryBranchInfoView from '../common/MinistryBranchInfoView.vue';
// import './intakeformview.styl';
// import ProjectContactInfoView from '../projects/ProjectContactInfoView.vue';
// import ProjectAdditionalContactInfoView from '../projects/ProjectAdditionalContactInfoView.vue';

const INTAKE_FORM_PANELS = {
  PROJECT_INFO: 'projectInfo',
  CLIENTS_INFO: 'clientInfo',
  CONTACTS_INFO: 'contactInfo',
};

const CLIENT_INFO_TYPES = {
  CLIENT_LEAD: 'clientlead',
  CLIENT_SPONSOR: 'clientsponsor',
  CLIENT_CONTACT: 'clientcontact',
  CLIENT_FINANCE: 'clientfinance',
};

export default {
  components: {
    // IntakeBaseInfoView,
    // MinistryBranchInfoView,
    // ProjectContactInfoView,
    // ProjectAdditionalContactInfoView,
  },
  props: {
    id: String,
  },
  data() {
    return {
      projectInformation: this.$store.state.projectInformation,
      ministryInformation: this.$store.state.ministryInformation,
      contactInformation: this.$store.state.contactInformation,
      valid: false,
      enabled: true,
      ...INTAKE_FORM_PANELS,
      panelStates: {
        [INTAKE_FORM_PANELS.PROJECT_INFO]: { value: false },
        [INTAKE_FORM_PANELS.CLIENTS_INFO]: { value: false },
        [INTAKE_FORM_PANELS.CONTACTS_INFO]: { value: false },
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
      const id = params.id || this.$props.id;

      if (!(id === undefined)) {
        this.$store.dispatch('fetchIntakeRequest', { id });
      } else {
        this.$store.dispatch('clearActiveIntakeRequest');
      }
    },
    isEnabled(infoType) {
      const contacts = this.$store.state.activeIntakeRequest.contacts || [];
      const clientInfo = contacts.find(contact => contact.contactType === infoType);
      if (clientInfo) return true;
      return false;
    },
    getClientInfo(infoType) {
      const contacts = this.$store.state.activeIntakeRequest.contacts || [];
      const clientInfo = contacts.find(contact => contact.contactType === infoType);
      // if (contacts.length > 2) this.enabled = true;
      // else this.enabled = false;
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
