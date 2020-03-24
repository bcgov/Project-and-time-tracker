<template>
  <v-layout row justify-center class="proc-layout" >
    <snackbar ref="snackbar"></snackbar>
    <v-dialog id="ProcurementLog" class="proc-dialgue" max-width="70%"  v-model="dialog">
      <v-form ref="ProcurementLogs"  v-model="valid"  lazy-validation>
        <spinner ref="spinner"></spinner>
        <v-card>
          <v-card-text class="card-contents">
            <v-flex md12>
              <v-card-title>
                <span class="headline">Add New Log</span>
              </v-card-title>
              <v-divider class="header-divider"></v-divider>
            </v-flex>
            <v-layout row wrap>
              <v-flex md6>
                <div class="v-form-container">
                  <v-select
                    :items="itemList"
                    v-model="logType"
                    item-value="id"
                    item-text="logType"
                    label="Select a Log Type"
                  ></v-select>
                </div>
              </v-flex>
              <v-flex md6>
                <div class="v-form-container">
                  <v-text-field v-model="riskOwnerName" label="Risk Owner"></v-text-field>
                </div>
              </v-flex>
              <v-flex xs12>
                <div class="v-form-container">
                  <v-textarea
                    name="description-of-the-issue"
                    label="Description of the Issue"
                    no-resize
                    v-model="issueDescription"
                  ></v-textarea>
                </div>
              </v-flex>
              <v-layout row wrap>
                <v-flex md6>
                  <div class="v-form-container">
                    <v-menu
                      v-model="menu1"
                      :close-on-content-click="false"
                      :nudge-right="40"
                      lazy
                      transition="scale-transition"
                      offset-y
                      full-width
                      max-width="290px"
                      min-width="290px"
                    >
                      <template v-slot:activator="{ on }">
                        <v-text-field
                          readonly
                          :rules="requiredRule"
                          v-model="dateToClient"
                          label="Date to Client"
                          persistent-hint
                          prepend-inner-icon="event"
                          @blur="date = parseDate(dateFormatted)"
                          v-on="on"
                        ></v-text-field>
                      </template>
                      <v-date-picker
                        v-model="dateToClient"
                        no-title
                        @input="menu1 = false"
                        :min="new Date().toISOString()"
                      ></v-date-picker>
                    </v-menu>
                  </div>
                </v-flex>
                <v-flex md6>
                  <div class="v-form-container">
                    <v-select
                      :items="notificationMethodList"
                      v-model="notificationMethod"
                      item-value="id"
                      item-text="notificationMethod"
                      label="Method of Notification"
                    ></v-select>
                  </div>
                </v-flex>
              </v-layout>
              <v-layout row wrap>
                <v-flex md6>
                  <div class="v-form-container">
                    <v-select
                      v-model="phaseImpactName"
                      :items="projectRfx"
                      item-text="rfxName"
                      item-value="rfxName"
                      label="Phase Impact"
                    ></v-select>
                  </div>
                </v-flex>
                 <v-flex md6>
                   <div class="v-form-container">
                  <v-text-field v-model="clientDecision" label="Client Decision"></v-text-field>
                </div>
                </v-flex>
              </v-layout>
                <v-flex md6>
                  <div class="v-form-container">
                    <v-menu
                      v-model="menu2"
                      :close-on-content-click="false"
                      :nudge-right="40"
                      lazy
                      transition="scale-transition"
                      offset-y
                      full-width
                      max-width="290px"
                      min-width="290px"
                    >
                      <template v-slot:activator="{ on }">
                        <v-text-field
                          readonly
                          :rules="requiredRule"
                          v-model="followUpDate"
                          label="Follow Up Date"
                          persistent-hint
                          prepend-inner-icon="event"
                          @blur="date = parseDate(dateFormatted)"
                          v-on="on"
                        ></v-text-field>
                      </template>
                      <v-date-picker
                        v-model="followUpDate"
                        no-title
                        @input="menu2 = false"
                        :min="new Date().toISOString()"
                      ></v-date-picker>
                    </v-menu>
                  </div>
                </v-flex>

                 <v-flex md12>
                 <v-flex d-flex justify-end>
                              <v-btn
                                class="add-log-button"
                                color="btnPrimary"
                                dark
                                @click="saveProcurementLog"
                              >ADD LOG</v-btn>
                            </v-flex></v-flex>

            </v-layout>
          </v-card-text>
        </v-card>
      </v-form>
    </v-dialog>
  </v-layout>
</template>
<script>
import "./procurementlog.styl";
// import moment from 'moment';
import Snackbar from "../common/Snackbar.vue";
import Spinner from "../common/Spinner.vue";
// import AddExpense from './AddExpense.vue';
// import TimesheetEntry from './TimesheetEntry.vue';

// import Calendar from 'v-calendar/lib/components/calendar.umd'
// import DatePicker from 'v-calendar/lib/components/date-picker.umd'

export default {
  computed: {
      projectRfx() {
        return this.$store.state.activeProjectRfxData;
    }
  },
  components: {
    Snackbar,
    Spinner
  },
  data() {
    return this.initData();
  },
  watch: {},
  props: {
    timeEntry: Object
  },
  methods: {
    async saveProcurementLog() {
      console.log(this.logType, this.notificationMethod, this.phaseImpactName);
     // const projectFinanceForm = this.$refs.ProcurementLogs || undefined;
       const formData = {
          logType: this.logType,
          riskOwner: this.riskOwnerName,
          descriptionOfIssue:this.issueDescription,
          dateToClient:this.dateToClient,
          notificationMethod: this.notificationMethod,
          phaseImpactName: this.phaseImpactName,
          clientDecision:this.clientDecision,
          followUpDate: this.followUpDate,
          projectId: this.$store.state.activeProject.id
          // userId: this.form.userId,
        };
        if(this.id) {
          console.log('suppose to update');
        formData.id = this.id
         await this.$store
            .dispatch("updateProctLog", {
              procurementlog: formData
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
        } else {
          console.log('suppose to add new');
           await this.$store
            .dispatch("updateProcurementLog", {
              id: '34534-345345-45353',
              procurementlog: formData
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
         


    },
    parseDate(date) {
      if (!date) return null;
      const [month, day, year] = date.split("/");
      return `${year}-${month.padStart(2, "0")}-${day.padStart(2, "0")}`;
    },
    open() {
      this.dialog = true;
      setTimeout(() => {
        document.getElementsByClassName(
          "v-dialog v-dialog--active"
        )[0].scrollTop = 0;
      }, 400);
    },
    openWithValues(obj) {
         this.id = obj.id;
     // this.form.userId = obj.user.id;
          this.logType = obj.logType;
          this.riskOwnerName = obj.riskOwner;
          this.issueDescription = obj.descriptionOfIssue;
          this.dateToClient = obj.dateToClient.substring(0,10);
          this.notificationMethod = obj.notificationMethod;
          this.phaseImpactName = obj.phaseImpactName;
          this.clientDecision = obj.clientDecision;
         this.followUpDate = obj.followUpDate.substring(0,10);
    
      this.dialog = true;
      setTimeout(() => {
        document.getElementsByClassName(
          "v-dialog v-dialog--active"
        )[0].scrollTop = 0;
      }, 400);
    }
    ,
    closeDialog() {
      this.dialog = false;
    },
    reset() {
      // this.$refs.form.resetValidation();
      const data = this.initData();
    },
    initData() {
      const form = Object.assign({}, this.$props.timeEntry);

      form.userId = this.$store.state.activeUser.id;
      const existingTimeEntries = [];
      return {
        id: undefined,
        activeTab: "weekly",
        recordType: 1,
        valid: true,
        requiredRule: [v => !!v || "This field required"],
        requireRadioButtondRule: [
          v => ((v || !v) && v != null) || "This field required"
        ],
        dialog: false,
        menu1: false,
        menu2: false,
        form: { ...form },
        dateFormatted: undefined,
        dateToClient: '',
        followUpDate:'',
        riskOwnerName:'',
        issueDescription:'',
        existingTimeEntries,
        addRecordLoading: false,
        dateRange: { start: null, end: null },
        logType: "",
        itemList: [
          { id: "Contact Update", logType: "Contact Update" },
          { id: "RFX Update", logType: "RFX Update" },
          { id: "Project Lead", logType: "Project Lead" },
           { id: "Risk Assessment", logType: "Risk Assessment" }
        ],
        notificationMethod: "",
        notificationMethodList: [
          { id: "Phone", notificationMethod: "Phone" },
          { id: "Email", notificationMethod: "Email" },
          { id: "In person", notificationMethod: "In person" }
        ],
        phaseImpactName: "",
        phaseImpactList: [
          { id: "impact 1", phaseImpactName: "impact 1" },
          { id: "impact 2", phaseImpactName: "impact 2" },
          { id: "impact 3", phaseImpactName: "impact 3" }
        ],
        clientDecision: "",
      };
    }
  }
};
</script>
<style scoped>
.add-log-button {
  width: 150px;
  flex: 0 0 200px !important;
  margin-right: 3%;
}
.v-dialog:not(.v-dialog--fullscreen) {
  max-width:70%;
  max-height: 90%; 
}
</style>
