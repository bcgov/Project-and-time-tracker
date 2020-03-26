<template>
  <v-layout row justify-center class="proc-layout">
    <snackbar ref="snackbar"></snackbar>
    <v-dialog id="newNote" class="proc-dialgue" max-width="40%" v-model="dialog">
      <v-form ref="newNotes" v-model="valid" lazy-validation>
        <spinner ref="spinner"></spinner>
        <v-card style="width:100%">
          <v-card-text class="card-contents">
            
            <v-layout row wrap>
              <v-flex md12>
                <div class="v-form-container">
                    <v-textarea
            name="project-description"
            label="write your notes"
            no-resize
          ></v-textarea>
                </div>
              </v-flex>
              <v-flex md12>
                <v-flex d-flex justify-end>
                  <v-btn
                    class="add-log-button"
                    color="btnPrimary"
                    dark
                    @click="savenote"
                  >SAVE NOTE</v-btn>
                </v-flex>
              </v-flex>
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
      savenote() {
console.log('hiiii');
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
      // const data = this.initData();
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
        dateToClient: "",
        followUpDate: "",
        riskOwnerName: "",
        issueDescription: "",
        isResolved: false,
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
        clientDecision: ""
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
  max-width: 40%;
  max-height: 90%;
}
</style>
