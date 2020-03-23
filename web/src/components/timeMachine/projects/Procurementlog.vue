<template>
  <v-layout row justify-center class='procurement-log'>
    <snackbar ref="snackbar"></snackbar>
    <v-dialog id="ProcurementLog" content-class="add-procurement-log" v-model="dialog">
      <v-form ref="ProcurementLogs" v-model="valid" class="v-form intake-base-info" lazy-validation>
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
                    v-model="logTypeId"
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
                      v-model="notificationId"
                      item-value="id"
                      item-text="methodName"
                      label="Method of Notification"
                    ></v-select>
                  </div>
                </v-flex>
              </v-layout>
              <v-layout row wrap>
                <v-flex md6>
                  <div class="v-form-container">
                    <v-select
                      :items="phaseImpactList"
                      v-model="phaseImpactId"
                      item-value="id"
                      item-text="phaseImpactName"
                      label="Phase Impact"
                    ></v-select>
                  </div>
                </v-flex>
                 <v-flex md6>
                  <div class="v-form-container">
                    <v-select
                      :items="clientDecisionList"
                      v-model="clientDecisionId"
                      item-value="id"
                      item-text="clientDecisionName"
                      label="Client Decision"
                    ></v-select>
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
  computed: {},
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
      console.log('reached here');
     // const projectFinanceForm = this.$refs.ProcurementLogs || undefined;
       const formData = {
          logTypeId: this.logTypeId,
          riskOwner: this.riskOwnerName,
          descriptionOfIssue:this.issueDescription,
          dateToClient:this.dateToClient,
          notificationId: this.notificationId,
          phaseImpactId: this.phaseImpactId,
          clientDecisionId:this.clientDecisionId,
          followUpDate: this.followUpDate
          // userId: this.form.userId,
        };
        console.log('form data:', formData);
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
        logTypeId: "",
        itemList: [
          { id: "6d030127", logType: "Rfx Change" },
          { id: "6d530127", logType: "contact change" },
          { id: "56456453", logType: "Finance change" }
        ],
        notificationId: "",
        notificationMethodList: [
          { id: "6d030127", methodName: "Method 1" },
          { id: "6d530127", methodName: "Method 2" },
          { id: "56456453", methodName: "Method 3" }
        ],
        phaseImpactId: "",
        phaseImpactList: [
          { id: "6d030127", phaseImpactName: "impact 1" },
          { id: "6d530127", phaseImpactName: "impact 2" },
          { id: "56456453", phaseImpactName: "impact 3" }
        ],
        clientDecisionId: "",
        clientDecisionList: [
          { id: "6d030127", clientDecisionName: "decision 1" },
          { id: "6d530127", clientDecisionName: "decision 2" },
          { id: "56456453", clientDecisionName: "decision 3" }
        ]
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
</style>
