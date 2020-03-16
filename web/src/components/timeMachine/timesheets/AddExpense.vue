 <template>
  <v-layout row justify-center>
    <snackbar ref="snackbar"></snackbar>
    <v-dialog id="AddExpense" content-class="new-time-record"  max-width="600">
      <v-form ref="form" v-model="valid" lazy-validation>
        <spinner ref="spinner"></spinner>
        <v-card>
          <v-card-title>
            <span justify-center class="headline">Add Expenses</span>
          </v-card-title>
          <v-card-text>
            <v-container grid-list-md>
              <v-layout wrap>
                <v-flex xs12>
                  <div class="v-form-container">
                    <v-text-field
                      class="required"
                      :rules="requiredRule"
                      prepend-inner-icon="attach_money"
                      label="Amount"
                      v-currency
                      oninput="validity.valid||(value='');"
                      v-model="form.amount"
                    ></v-text-field>
                  </div>
                </v-flex>
                <v-flex xs12>
                  <v-textarea label="Comment" no-resize v-model="form.comment" rows="3"></v-textarea>
                </v-flex>
              </v-layout>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn
              class="add-new-row"
              color="primary"
              @click="saveNewRow"
              :disabled="addRecordLoading"
              :loading="addRecordLoading"
            >Ok</v-btn>
            <v-btn @click="closeDialog">Cancel</v-btn>
          </v-card-actions>
        </v-card>
      </v-form>
    </v-dialog>
  </v-layout>
</template>
<script>
import TimesheetEntryDto from '@/domain/models/TimesheetEntry.dto';
import RFxDto from '@/domain/models/RFx.dto';
import RFxPhaseDto from '@/domain/models/RFxPhase.dto';
import ProjectDto from '@/domain/models/Project.dto';

import merge from 'object-merge';

import './addnewtimerecord.styl';
import moment from 'moment';
import Snackbar from '../common/Snackbar.vue';
import Spinner from '../common/Spinner.vue';

export default {
  computed: {
    computedDateFormatted() {
      return this.formatDate(this.date);
    },
    userList() {
      return this.$store.state.users;
    },
    rfxPhases() {
      return this.$store.state.rfxPhases;
    },
    rfxTypes() {
      return this.$store.state.activeProjectRfxData;
    },
    projects() {
      return this.$store.state.projects;
    },
  },
  components: {
    Snackbar,
    Spinner,
  },
  data() {
    return this.initData();
  },
  watch: {
    date() {
      this.dateFormatted = this.formatDate(this.date);
    },
    project(val) {
      this.$store.dispatch('fetchProjectRfx', { id: val });
    },
  },
  props: {
    timeEntry: Object,
  },
  methods: {
    open() {
      this.form.date = moment().format('YYYY-MM-DD');
      this.dialog = true;
      const referenceId = JSON.parse(localStorage.getItem('keycloak_user')).sub;
      const user = this.$store.state.users.find(value => value.referenceId === referenceId);
      if (user && user.id) {
        this.form.userId = user.id;
      }
      setTimeout(() => {
        document.getElementsByClassName(
          'v-dialog v-dialog--active',
        )[0].scrollTop = 0;
      }, 400);
    },
    closeDialog() {
      this.dialog = false;
    },
    reset() {
      this.$refs.form.resetValidation();
      const data = this.initData();
      this.$data.valid = data.valid;
      this.$data.requiredRule = data.requiredRule;
      this.$data.requireRadioButtondRule = data.requireRadioButtondRule;
      this.$data.dialog = data.dialog;
      this.$data.menu1 = data.menu1;
      this.$data.form = data.form;
      this.$data.dateFormatted = data.dateFormatted;
      this.$data.existingTimeEntries = data.existingTimeEntries;
    },
    initData() {
      const form = Object.assign({}, this.$props.timeEntry);
      if (!form.date) {
        form.date = moment().format('YYYY-MM-DD');
      }
      const existingTimeEntries = [];
      return {
        valid: true,
        requiredRule: [v => !!v || 'This field required'],
        requireRadioButtondRule: [
          v => ((v || !v) && v != null) || 'This field required',
        ],
        dialog: false,
        menu1: false,
        form: { ...form },
        dateFormatted: undefined,
        existingTimeEntries,
        addRecordLoading: false,
      };
    },
    saveNewRow() {
      if (this.$refs.form.validate()) {
        const formData = this.form;
        formData.hour = parseFloat(formData.hour.toFixed(2));
        const payload = this.timesheetUpdatePayload(formData);
        // this.updateTimesheet(payload);
      } else {
        this.dialog = true;
      }
    },
    handleMultipleErrors(errorList) {
      this.$refs.snackbar.displayMultipleErrorSnackbar('error', errorList);
    },
  },
};
</script>
<style scoped>
.v-form-container {
   padding: none;
}
</style>
