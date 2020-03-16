<template>
  <v-layout row justify-center>
    <snackbar ref="snackbar"></snackbar>
    <v-dialog id="AddTimeRecord" content-class="new-time-record" v-model="dialog" max-width="850">
      <v-form ref="form" v-model="valid" lazy-validation>
        <spinner ref="spinner"></spinner>
        <v-card>
          <v-layout wrap>
            <v-flex xs4>
              <v-card-title>
                <span class="headline">Add Time Record</span>
              </v-card-title></v-flex
            >
            <v-flex xs8>
              <v-flex class="d-flex cardheadlabel1" cols="12" sm="6">
                <v-flex class="haederinfo"> Information being entered by:</v-flex>
                <v-flex> <v-select></v-select></v-flex>
              </v-flex>
              <v-flex class="d-flex cardheadlabel2" cols="12" sm="6">
                <v-flex><b>MOU amount: </b>$1,000,000</v-flex>
                <v-flex><b>Currently Billed:</b> $5000,000</v-flex>
              </v-flex>
            </v-flex>
          </v-layout>
          <v-divider class="header-divider"></v-divider>

          <v-tabs>
            <v-tab href="#batch">
              Batch Entry
            </v-tab>
            <v-tab href="#weakily">
              Weakily Entry
            </v-tab>
            <v-tab-item value="batch">
              batch
            </v-tab-item>
            <v-tab-item value="weakily">
              Weakily
            </v-tab-item>
          </v-tabs>
          <v-card-text>
            <v-container grid-list-md>
              <v-layout wrap>
                <v-flex class="d-flex" cols="12" sm="4">
                  <v-flex xs12>
                    <v-select label="MOU" v-model="form.project"></v-select>
                  </v-flex>

                  <v-flex xs12>
                    <v-select label="Project Name" v-model="form.projectRfx"></v-select>
                  </v-flex>

                  <v-flex xs12>
                    <v-select label="RFx Document"></v-select>
                  </v-flex>
                </v-flex>
                <v-flex>
                  <v-flex class="d-flex" cols="12" sm="6">
                    <v-flex>
                      <timesheets-calendar></timesheets-calendar>
                    </v-flex>
                    <v-flex>
                      <v-radio-group row v-model="recordType">
                        <v-radio label="Hours" :value="1"></v-radio>
                        <v-radio label="Expenses" :value="2" @change="expensePopup()"></v-radio>
                        <v-radio label="Unbillable Hours" :value="3"></v-radio>
                      </v-radio-group>
                      <v-flex v-if="recordType === 1 ">
                        <timesheet-billable ref="TimesheetBillable"></timesheet-billable
                      ></v-flex>
                      <v-flex >
                        <add-expense ref="AddExpense"></add-expense>
                        </v-flex>
                      <v-flex v-if="recordType === 3 ">
                        <timesheet-billable ref="TimesheetBillable"></timesheet-billable
                      ></v-flex>
                    </v-flex>
                  </v-flex>
                </v-flex>
              </v-layout>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <label class="btn-discard">
              DISCARD TIMESHEET
            </label>
            <v-flex class="add-btns">
              <v-btn class="btn-normal">EXPORT TIMESHEET </v-btn>
              <v-btn class="btn-normal">SAVE AND COPY </v-btn>
              <v-btn class="add-new-row" color="primary">SAVE AND CLOSE </v-btn>
            </v-flex>
          </v-card-actions>
        </v-card>
      </v-form>
    </v-dialog>
  </v-layout>
</template>
<script>
import TimesheetEntryDto from '@/domain/models/TimesheetEntry.dto';
import RFxDto from '@/domain/models/RFx.dto';
import ProjectDto from '@/domain/models/Project.dto';

import './addtimerecord.styl';
import moment from 'moment';
import Snackbar from '../common/Snackbar.vue';
import Spinner from '../common/Spinner.vue';
import TimesheetsCalendar from './TimesheetsCalendar.vue';
import AddExpense from './AddExpense.vue';
import TimesheetBillable from './TimesheetBillable.vue';

export default {
  computed: {},
  components: {
    Snackbar,
    Spinner,
    TimesheetsCalendar,
    AddExpense,
    TimesheetBillable,
  },
  data() {
    return this.initData();
  },
  watch: {},
  props: {
    timeEntry: Object,
  },
  methods: {
    expensePopup() {
      this.$refs.AddExpense.reset();
      this.$refs.AddExpense.open();
    },


    open() {
      this.dialog = true;
      setTimeout(() => {
        document.getElementsByClassName('v-dialog v-dialog--active')[0].scrollTop = 0;
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
        recordType: 1,
        valid: true,
        requiredRule: [v => !!v || 'This field required'],
        requireRadioButtondRule: [v => ((v || !v) && v != null) || 'This field required'],
        dialog: false,
        menu1: false,
        form: { ...form },
        dateFormatted: undefined,
        existingTimeEntries,
        addRecordLoading: false,
      };
    },
  },
};
</script>
