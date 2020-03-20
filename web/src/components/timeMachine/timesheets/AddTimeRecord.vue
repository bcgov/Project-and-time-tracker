<template>
  <v-layout row justify-center>
    <snackbar ref="snackbar"></snackbar>
    <v-dialog id="AddTimeRecord" content-class="add-time-record" v-model="dialog">
      <v-form ref="AddimeRecords" v-model="valid" lazy-validation>
        <spinner ref="spinner"></spinner>
        <v-card>
          <v-card-text class="card-contents">
            <v-layout wrap>
              <v-flex md4>
                <v-card-title>
                  <span class="headline">Add Time Record</span>
                </v-card-title>
              </v-flex>
              <v-flex md8>
                <v-flex class="d-flex cardheadlabel1">
                  <v-flex md7 class="haederinfo">Information being entered by:</v-flex>
                  <v-flex md4>
                    <v-select
                      v-model="form.userId"
                      :rules="requiredRule"
                      :items="userList"
                      item-value="id"
                      item-text="contact.fullName"
                      label="User"
                    ></v-select>
                  </v-flex>
                </v-flex>

                <v-flex v-if="form.mou" class="d-flex cardheadlabel2">
                  <v-flex>
                    <b>MOU amount:</b>
                    ${{ mouAmount }}
                  </v-flex>
                  <v-flex> <b>Currently Billed:</b> $0 </v-flex>
                </v-flex>
              </v-flex>
            </v-layout>
            <v-divider class="header-divider"></v-divider>
            <v-tabs v-model="activeTab">
              <v-tab href="#batch">Batch Entry</v-tab>
              <v-tab href="#weekly">Weekly Entry</v-tab>
              <v-tab-item value="batch">
                <!-- <v-flex class="d-flex" cols="12" sm="4">
                  <v-flex xs12>
                    <v-select
                      v-model="form.mou"
                      :rules="requiredRule"
                      :items="mouList"
                      item-text="name"
                      item-value="id"
                      label="MOU"
                    ></v-select>
                  </v-flex>
                  <v-flex xs12>
                    <v-select
                      v-model="form.project"
                      :rules="requiredRule"
                      :items="projectList"
                      item-text="projectName"
                      item-value="id"
                      label="Project Name"
                      @change="onChangeProject(form.project)"
                    ></v-select>
                  </v-flex>

                  <v-flex xs12>
                    <v-select
                      v-model="form.Rfx"
                      :rules="requiredRule"
                      :items="projectRfx"
                      item-text="rfxName"
                      item-value="id"
                      label="Project Rfx"
                      @change="onChangeProjectRfx()"
                    ></v-select>
                  </v-flex> -->
                <!-- </v-flex> -->
                <v-flex>
                  <v-flex class="d-flex" cols="12" sm="6">
                    <v-flex md6>
                      <timesheets-calendar @next="checkWeekChange"></timesheets-calendar>
                    </v-flex>
                    <v-flex md6>
                      <v-radio-group row v-model="recordType">
                        <v-radio label="Hours" :value="1"></v-radio>
                        <v-radio label="Expenses" :value="2"></v-radio>
                        <v-radio label="Unbillable Hours" :value="3"></v-radio>
                      </v-radio-group>
                    </v-flex>
                  </v-flex>

                  <batch-time-entry ref="BatchTimeEntry"></batch-time-entry>

                  <!-- <v-flex v-show="recordType === 1">
                    <timesheet-entry ref="Billable" single-row></timesheet-entry>
                  </v-flex>
                  <v-flex v-if="recordType === 2">
                    <add-expense ref="AddExpense" single-row></add-expense>
                  </v-flex>
                  <v-flex v-show="recordType === 3">
                    <timesheet-entry ref="NonBillable" single-row></timesheet-entry>
                  </v-flex> -->
                </v-flex>
                <!--
                      <v-layout row>
                        <v-flex xs6 sm9>
                          <vc-date-picker
                            mode="range"
                            v-model="dateRange"
                            is-inline
                            is-expanded
                            :excludeDates='{ weekdays: [1, 7] }'
                          />
                        </v-flex>
                        <v-flex xs6 sm3>
                          <v-card>
                            <v-card-text>
                              <p>Start date: {{ dateRange.start | formatDate }}</p>
                              <p>End date: {{ dateRange.end | formatDate }}</p>
                              <p>Total days: {{ dateRangeDiffInDays }} </p>
                              <p>Total hours: {{ hoursForRange }}</p>
                            </v-card-text>
                          </v-card>
                        </v-flex>
                      </v-layout> -->
              </v-tab-item>
              <v-tab-item value="weekly">
                <v-flex class="d-flex" cols="12" sm="4" v-if="activeTab === 'weekly'">
                  <v-flex xs12>
                    <v-select
                      v-model="form.mou"
                      :rules="requiredRule"
                      :items="mouList"
                      item-text="name"
                      item-value="id"
                      label="MOU"
                    ></v-select>
                  </v-flex>
                  <v-flex xs12>
                    <v-select
                      v-model="form.project"
                      :rules="requiredRule"
                      :items="projectList"
                      item-text="projectName"
                      item-value="id"
                      label="Project Name"
                      @change="onChangeProject(form.project)"
                    ></v-select>
                  </v-flex>

                  <v-flex xs12>
                    <v-select
                      v-model="form.Rfx"
                      :rules="requiredRule"
                      :items="projectRfx"
                      item-text="rfxName"
                      item-value="id"
                      label="Project Rfx"
                      @change="onChangeProjectRfx()"
                    ></v-select>
                  </v-flex>
                </v-flex>
                <v-flex>
                  <v-flex class="d-flex" cols="12" sm="6">
                    <v-flex md6>
                      <timesheets-calendar @next="checkWeekChange"></timesheets-calendar>
                    </v-flex>
                    <v-flex md6>
                      <v-radio-group row v-model="recordType">
                        <v-radio label="Hours" :value="1"></v-radio>
                        <v-radio label="Expenses" :value="2"></v-radio>
                        <v-radio label="Unbillable Hours" :value="3"></v-radio>
                      </v-radio-group>
                    </v-flex>
                  </v-flex>
                  <v-flex v-show="recordType === 1">
                    <timesheet-entry ref="Billable"></timesheet-entry>
                  </v-flex>
                  <v-flex v-if="recordType === 2">
                    <add-expense ref="AddExpense"></add-expense>
                  </v-flex>
                  <v-flex v-show="recordType === 3">
                    <timesheet-entry ref="NonBillable" single-row></timesheet-entry>
                  </v-flex>
                </v-flex>
                <!--
                      <v-layout row>
                        <v-flex xs6 sm9>
                          <vc-date-picker
                            mode="range"
                            v-model="dateRange"
                            is-inline
                            is-expanded
                            :excludeDates='{ weekdays: [1, 7] }'
                          />
                        </v-flex>
                        <v-flex xs6 sm3>
                          <v-card>
                            <v-card-text>
                              <p>Start date: {{ dateRange.start | formatDate }}</p>
                              <p>End date: {{ dateRange.end | formatDate }}</p>
                              <p>Total days: {{ dateRangeDiffInDays }} </p>
                              <p>Total hours: {{ hoursForRange }}</p>
                            </v-card-text>
                          </v-card>
                        </v-flex>
                </v-layout>-->
              </v-tab-item>
            </v-tabs>
          </v-card-text>
          <v-divider class="header-divider"></v-divider>
          <v-card-actions>
            <label class="btn-discard">DISCARD TIMESHEET</label>
            <v-flex class="add-btns">
              <v-btn class="btn-normal">EXPORT TIMESHEET</v-btn>
              <v-btn class="btn-normal" @click="saveAndCopy()">SAVE AND COPY</v-btn>
              <v-btn class="add-new-row" color="primary" @click="saveAndClose()"
                >SAVE AND CLOSE</v-btn
              >
            </v-flex>
          </v-card-actions>
        </v-card>
      </v-form>
    </v-dialog>
  </v-layout>
</template>
<script>
import './addtimerecord.styl';
import moment from 'moment';
import Calendar from 'v-calendar/lib/components/calendar.umd';
import DatePicker from 'v-calendar/lib/components/date-picker.umd';
import Snackbar from '../common/Snackbar.vue';
import Spinner from '../common/Spinner.vue';
import TimesheetsCalendar from './TimesheetsCalendar.vue';
import AddExpense from './AddExpense.vue';
import TimesheetEntry from './TimesheetEntry.vue';
import BatchTimeEntry from './BatchTimeEntry';

export default {
  computed: {
    mouList() {
      return this.$store.state.mouList;
    },
    userList() {
      return this.$store.state.users;
    },

    timesheetEntryData() {
      return this.$store.state.timesheetEntryData;
    },
    dateRangeDiffInDays() {
      if (this.dateRange.start && this.dateRange.end) {
        return Math.abs(moment(this.dateRange.start).diff(moment(this.dateRange.end), 'days'));
      }
    },
    projectList() {
      if (typeof this.form.mou !== 'undefined') {
        const mouProjects = this.$store.state.projects.filter(item => item.mou);
        if (mouProjects.length === 0) {
          return [];
        }
        const Projects = mouProjects.filter(item => item.mou.id === this.form.mou);
        if (Projects.length > 0) {
          return Projects;
        }
      }
      return [];
    },
    projectRfx() {
      if (typeof this.form.project !== 'undefined') {
        return this.$store.state.activeProjectRfxData;
      }
      return [];
    },
    mouAmount() {
      if (!this.form || !this.form.mou || !this.mouList[this.form.mou - 1]) {
        return '';
      }
      return this.mouList[this.form.mou - 1].name.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    },
    hoursForRange() {
      // const hours = this.dateRangeDiffInDays * days... how to get days from <timesheet-entry> or similar?
      return 'todo';
    },
  },
  components: {
    Snackbar,
    Spinner,
    TimesheetsCalendar,
    AddExpense,
    TimesheetEntry,
    BatchTimeEntry,
  },
  data() {
    return this.initData();
  },
  watch: {},
  props: {
    timeEntry: Object,
  },
  methods: {
    getDatePart(date) {
      // debugger;
      const dateTime = moment(date);

      const dateValue = moment({
        year: dateTime.year(),
        month: dateTime.month(),
        day: dateTime.date(),
      });
      return dateValue;
    },
    async checkWeekChange() {
      // const date = this.$store.state.timesheetsWeek.startDate.add(7, 'days');
      this.getTimeEntries();
    },
    async getTimeEntries() {
      const date = this.getDatePart(this.$store.state.timesheetsWeek.startDate);
      const weekDataBillable = [
        { day: 'Mon', description: '', hours: 0, date: '' },
        { day: 'Tue', description: '', hours: 0, date: '' },
        { day: 'Wed', description: '', hours: 0, date: '' },
        { day: 'Thu', description: '', hours: 0, date: '' },
        { day: 'Fri', description: '', hours: 0, date: '' },
        { day: 'Sat', description: '', hours: 0, date: '' },
        { day: 'Sun', description: '', hours: 0, date: '' },
      ];
      const weekDataUnBillable = [
        { day: 'Mon', description: '', hours: 0, date: '' },
        { day: 'Tue', description: '', hours: 0, date: '' },
        { day: 'Wed', description: '', hours: 0, date: '' },
        { day: 'Thu', description: '', hours: 0, date: '' },
        { day: 'Fri', description: '', hours: 0, date: '' },
        { day: 'Sat', description: '', hours: 0, date: '' },
        { day: 'Sun', description: '', hours: 0, date: '' },
      ];
      this.$refs.Billable.weekData = weekDataBillable;
      this.$refs.NonBillable.weekData = weekDataUnBillable;
      const formData = {
        mou: this.form.mou,
        project: this.form.project,
        projectRfx: this.form.Rfx,
        startDate: date,
        userId: this.form.userId,
      };
      const vm = this;
      vm.$store.dispatch('fetchTimesheetEntries', formData).then(() => {
        vm.initTimeEntries(vm.$store.state.timesheetEntryData);
      });
    },
    async getTimeEntriesById(obj) {
      const date = obj.startDate;
      
      const weekDataBillable = [
        { day: 'Mon', description: '', hours: 0, date: '' },
        { day: 'Tue', description: '', hours: 0, date: '' },
        { day: 'Wed', description: '', hours: 0, date: '' },
        { day: 'Thu', description: '', hours: 0, date: '' },
        { day: 'Fri', description: '', hours: 0, date: '' },
        { day: 'Sat', description: '', hours: 0, date: '' },
        { day: 'Sun', description: '', hours: 0, date: '' },
      ];
      const weekDataUnBillable = [
        { day: 'Mon', description: '', hours: 0, date: '' },
        { day: 'Tue', description: '', hours: 0, date: '' },
        { day: 'Wed', description: '', hours: 0, date: '' },
        { day: 'Thu', description: '', hours: 0, date: '' },
        { day: 'Fri', description: '', hours: 0, date: '' },
        { day: 'Sat', description: '', hours: 0, date: '' },
        { day: 'Sun', description: '', hours: 0, date: '' },
      ];
      this.$refs.Billable.weekData = weekDataBillable;
      this.$refs.NonBillable.weekData = weekDataUnBillable;
      const formData = {
        mou: obj.mou.id,
        project: obj.project.id,
        projectRfx: obj.projectRfx.id,
        startDate: date,
        userId: this.fetchUser(),
      };
      const vm = this;
      vm.$store.dispatch('fetchTimesheetEntries', formData).then(() => {
        vm.initTimeEntriesFromList(vm.$store.state.timesheetEntryData, obj);
      });
    },
    formatWeekData(weekData) {
      const weeks = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      for (let i = 0; i < 7; i++) {
        weekData[i].day = weeks[i];
      }
      return weekData;
    },
    initTimeEntriesFromList(timesheetEntryData, obj) {
      const billableDetails = [];
      const nonBillableDetails = [];
      this.form.userId = obj.user.id;
      this.form.mou = obj.mou.id;
      this.form.project = obj.project.id;
      this.onChangeProject(obj.project.id)
      this.form.Rfx= obj.projectRfx.id;
      this.activeTab = 'weekly';
      if (timesheetEntryData && timesheetEntryData.timesheetEntries) {
        for (let index = 0; index < timesheetEntryData.timesheetEntries.length; index++) {
          const entry = timesheetEntryData.timesheetEntries[index];
          const billable = {
            entryDate: entry.entryDate,
            hours: entry.hoursBillable,
            description: entry.commentsBillable,
          };
          billableDetails.push(billable);

          const nonBillable = {
            entryDate: entry.entryDate,
            hours: entry.hoursUnBillable,
            description: entry.commentsUnBillable,
          };
          nonBillableDetails.push(nonBillable);
        }

        this.$refs.Billable.weekData = this.formatWeekData(billableDetails);
        this.$refs.NonBillable.weekData = this.formatWeekData(nonBillableDetails);
      }
    },
    initTimeEntries(timesheetEntryData) {
      const billableDetails = [];
      const nonBillableDetails = [];
      if (timesheetEntryData && timesheetEntryData.timesheetEntries) {
        for (let index = 0; index < timesheetEntryData.timesheetEntries.length; index++) {
          const entry = timesheetEntryData.timesheetEntries[index];
          const billable = {
            entryDate: entry.entryDate,
            hours: entry.hoursBillable,
            description: entry.commentsBillable,
          };
          billableDetails.push(billable);

          const nonBillable = {
            entryDate: entry.entryDate,
            hours: entry.hoursUnBillable,
            description: entry.commentsUnBillable,
          };
          nonBillableDetails.push(nonBillable);
        }

        this.$refs.Billable.weekData = this.formatWeekData(billableDetails);
        this.$refs.NonBillable.weekData = this.formatWeekData(nonBillableDetails);
      }
    },

    onChangeProject(projectId) {
      this.$store.dispatch('fetchProjectRFxData', { id: projectId });
    },
    onChangeProjectRfx() {
      this.getTimeEntries();
    },
    getDateInYYYYMMDD(date) {
      // year
      const yyyy = `${date.getFullYear()}`;

      // month
      let mm = `0${date.getMonth() + 1}`; // prepend 0 // +1 is because Jan is 0
      mm = mm.substr(mm.length - 2); // take last 2 chars

      // day
      let dd = `0${date.getDate()}`; // prepend 0
      dd = dd.substr(dd.length - 2); // take last 2 chars

      return `${yyyy}-${mm}-${dd}`;
    },
    saveAndCopy() {
      this.submitForm();
    },
    saveAndClose() {
      if (this.$refs.AddimeRecords.validate()) {
        if (this.activeTab === 'weekly') {
          this.submitForm();
          this.closeDialog();
          const weekDataBillable = [
            { day: 'Mon', description: '', hours: 0, date: '' },
            { day: 'Tue', description: '', hours: 0, date: '' },
            { day: 'Wed', description: '', hours: 0, date: '' },
            { day: 'Thu', description: '', hours: 0, date: '' },
            { day: 'Fri', description: '', hours: 0, date: '' },
            { day: 'Sat', description: '', hours: 0, date: '' },
            { day: 'Sun', description: '', hours: 0, date: '' },
          ];
          const weekDataUnBillable = [
            { day: 'Mon', description: '', hours: 0, date: '' },
            { day: 'Tue', description: '', hours: 0, date: '' },
            { day: 'Wed', description: '', hours: 0, date: '' },
            { day: 'Thu', description: '', hours: 0, date: '' },
            { day: 'Fri', description: '', hours: 0, date: '' },
            { day: 'Sat', description: '', hours: 0, date: '' },
            { day: 'Sun', description: '', hours: 0, date: '' },
          ];
          this.$refs.Billable.weekData = weekDataBillable;
          this.$refs.NonBillable.weekData = weekDataUnBillable;
        } else {
          const batchdata = this.$refs.BatchTimeEntry.prepareDataForSubmission();
        }
      }
    },
    submitForm() {
      if (this.$refs.AddimeRecords.validate()) {
        console.log('submitForm called, valid');
        const billableDetails = this.$refs.Billable.onBillableclick();
        const nonBillableDetails = this.$refs.NonBillable.nonBillableclick();

        const timeEntries = [];
        const startDate = new Date(this.$store.state.timesheetsWeek.startDate);
        for (let index = 0; index < 7; index++) {
          const entryDate = new Date();
          entryDate.setDate(startDate.getDate() + index);
          const entry = {
            entryDate: this.getDateInYYYYMMDD(entryDate),
            hoursBillable: 0,
            hoursUnBillable: 0,
            commentsBillable: '',
            commentsUnBillable: '',
            expenseAmount: 0,
            expenseComment: '',
          };
          timeEntries.push(entry);
          if (billableDetails.length > 0) {
            const billable = billableDetails.filter(
              item => item.date === timeEntries[index].entryDate,
            );
            if (billable[0]) {
              timeEntries[index].hoursBillable = billable[0].hours === '' ? 0 : billable[0].hours;
              timeEntries[index].commentsBillable = billable[0].description;
            }
          }

          if (nonBillableDetails.length > 0) {
            const unBillable = nonBillableDetails.filter(
              item => item.date === timeEntries[index].entryDate,
            );
            if (unBillable[0]) {
              timeEntries[index].hoursUnBillable = unBillable[0].hours === '' ? 0 : unBillable[0].hours;
              timeEntries[index].commentsUnBillable = unBillable[0].description;
            }
          }
        }

        const dateValue = this.getDatePart(this.$store.state.timesheetsWeek.startDate);
        const formData = {
          entries: timeEntries,
          mou: this.form.mou,
          project: this.form.project,
          projectRfx: this.form.Rfx,
          startDate: dateValue,
          endDate: this.$store.state.timesheetsWeek.endDate,
          userId: this.form.userId,
        };
        this.$refs.spinner.open();
        this.$store.dispatch('addLightTimesheet', formData).then(
          () => {
            this.$refs.snackbar.displaySnackbar('success', 'Successfully added time entries.');
            this.$refs.spinner.close();
          },
          (err) => {
            this.$refs.spinner.close();
            if (err && err.response && err.response.data) {
              const { message } = err.response.data.error;
              this.$refs.snackbar.displaySnackbar('error', message);
            } else {
              this.$refs.snackbar.displaySnackbar('error', 'Timesheet entery Error');
            }
          },
        );
      }
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
      // this.$refs.form.resetValidation();
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
    fetchUser() {
      const referenceId = this.$store.state.activeUser.refId;
      const user = this.$store.state.users.find(value => value.referenceId === referenceId);
      if (user && user.id) {
        return user.id;
      }
    },
    initData() {
      const form = Object.assign({}, this.$props.timeEntry);
      if (!form.date) {
        form.date = moment().format('YYYY-MM-DD');
      }
      form.userId = this.fetchUser();
      const existingTimeEntries = [];
      return {
        activeTab: 'batch',
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
        dateRange: { start: null, end: null },
      };
    },
  },
};
</script>
