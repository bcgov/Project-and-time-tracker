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
                  <v-flex>
                    <b>Currently Billed:</b> $0
                  </v-flex>
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
                </v-flex>-->
                <!-- </v-flex> -->
                <v-flex>
                  <v-flex class="d-flex" cols="12" sm="6">
                    <v-flex md6 >
                      <timesheets-calendar ref="timeCalenderBatch" @next="checkWeekChange"></timesheets-calendar>
                    </v-flex>
                    <v-flex md6>
                      <v-radio-group row v-model="recordType">
                        <v-radio label="Hours" :value="1"></v-radio>
                        <!-- <v-radio label="Expenses" :value="2"></v-radio> -->
                        <v-radio label="Unbillable Hours" :value="3"></v-radio>
                      </v-radio-group>
                    </v-flex>
                  </v-flex>

                  <v-flex v-show="recordType === 1">
                    <batch-time-entry ref="billableBatchEntry"></batch-time-entry>
                  </v-flex>
                  <!-- <v-flex v-if="recordType === 2">
                    <add-expense ref="AddExpense" single-row></add-expense>
                  </v-flex>-->
                  <v-flex v-show="recordType === 3">
                    <batch-time-entry ref="nonBillableBatchEntry"></batch-time-entry>
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
                      @change="onChangeProjectWeeklyEntry(form.project)"
                    ></v-select>
                  </v-flex>

                  <v-flex xs12>
                    <v-select
                      v-model="form.Rfx"
                      :items="projectRfx"
                      item-text="rfxName"
                      item-value="id"
                      label="Project Rfx"
                    ></v-select>
                  </v-flex>
                </v-flex>
                <v-flex>
                  <v-flex class="d-flex" cols="12" sm="6">
                    <v-flex md6 >
                      <timesheets-calendar ref="timeCalenderWeekly" @next="checkWeekChange"></timesheets-calendar>
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
              <v-btn class="add-new-row" color="primary" @click="saveAndClose()">SAVE AND CLOSE</v-btn>
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
        return Math.abs(
          moment(this.dateRange.start).diff(moment(this.dateRange.end), 'days'),
        );
      }
    },
    projectList() {
      if (typeof this.form.mou !== 'undefined') {
        const mouProjects = this.$store.state.projects.filter(item => item.mou);
        if (mouProjects.length === 0) {
          return [];
        }
        const Projects = mouProjects.filter(
          item => item.mou.id === this.form.mou,
        );
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
      return this.mouList[this.form.mou - 1].name.replace(
        /\B(?=(\d{3})+(?!\d))/g,
        ',',
      );
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
      const dateValue = new Date(date);
      return this.getDateInYYYYMMDD(dateValue);
    },
    async checkWeekChange() {
      // const date = this.$store.state.timesheetsWeek.startDate.add(7, 'days');
      this.getTimeEntries();
    },
    async getTimeEntries() {
      this.$refs.billableBatchEntry.editMode = false;
      this.$refs.nonBillableBatchEntry.editMode = false;
      this.editMode = false;
      const date = this.getDatePart(this.$store.state.timesheetsWeek.startDate);
      this.clearTimeEntries();
      const rfxId = this.form.Rfx;
      const formData = {
        mou: this.form.mou,
        project: this.form.project,
        projectRfx: rfxId ? this.form.Rfx : '',
        startDate: date,
        userId: this.form.userId,
      };
      const vm = this;
      vm.$store.dispatch('fetchTimesheetEntries', formData).then(() => {
        vm.initTimeEntries(vm.$store.state.timesheetEntryData);
      });
    },
    async editTimeEntries(obj) {
      this.$refs.timeCalenderWeekly.setCalendarText();
      this.$refs.timeCalenderBatch.setCalendarText();
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
      this.form.userId = obj.user.id;
      this.form.mou = obj.mou.id;
      this.form.project = obj.project.id;
      this.onChangeProjectWeeklyEntry(obj.project.id);
      this.form.Rfx = obj.projectRfx ? obj.projectRfx.id : '';
      this.activeTab = 'weekly';
      this.initTimeEntries(obj);

      this.editMode = true;
      this.$refs.billableBatchEntry.editMode = true;
      this.$refs.nonBillableBatchEntry.editMode = true;

      this.$refs.billableBatchEntry.weekEntries[0].projectId = obj.project.id;
      this.$refs.billableBatchEntry.weekEntries[0].monday.hours = this.$refs.Billable.weekData[0].hours;
      this.$refs.billableBatchEntry.weekEntries[0].tuesday.hours = this.$refs.Billable.weekData[1].hours;
      this.$refs.billableBatchEntry.weekEntries[0].wednesday.hours = this.$refs.Billable.weekData[2].hours;
      this.$refs.billableBatchEntry.weekEntries[0].thursday.hours = this.$refs.Billable.weekData[3].hours;
      this.$refs.billableBatchEntry.weekEntries[0].friday.hours = this.$refs.Billable.weekData[4].hours;

      this.$refs.nonBillableBatchEntry.weekEntries[0].projectId = obj.project.id;
      this.$refs.nonBillableBatchEntry.weekEntries[0].monday.hours = this.$refs.NonBillable.weekData[0].hours;
      this.$refs.nonBillableBatchEntry.weekEntries[0].tuesday.hours = this.$refs.NonBillable.weekData[1].hours;
      this.$refs.nonBillableBatchEntry.weekEntries[0].wednesday.hours = this.$refs.NonBillable.weekData[2].hours;
      this.$refs.nonBillableBatchEntry.weekEntries[0].thursday.hours = this.$refs.NonBillable.weekData[3].hours;
      this.$refs.nonBillableBatchEntry.weekEntries[0].friday.hours = this.$refs.NonBillable.weekData[4].hours;
    },
    formatWeekData(weekData) {
      const weeks = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      for (let i = 0; i < weekData[i].length; i++) {
        weekData[i].day = weeks[i];
      }
      return weekData;
    },

    initTimeEntries(timesheetEntryData) {
      if (timesheetEntryData && timesheetEntryData.timesheetEntries) {
        for (
          let index = 0;
          index < timesheetEntryData.timesheetEntries.length;
          index++
        ) {
          const entry = timesheetEntryData.timesheetEntries[index];
          this.$refs.Billable.weekData[index].entryDate = entry.entryDate;
          this.$refs.Billable.weekData[index].hours = entry.hoursBillable;
          this.$refs.Billable.weekData[index].description = entry.commentsBillable;


          this.$refs.NonBillable.weekData[index].entryDate = entry.entryDate;
          this.$refs.NonBillable.weekData[index].hours = entry.hoursUnBillable;
          this.$refs.NonBillable.weekData[index].description = entry.commentsUnBillable;
        }
        this.$refs.Billable.weekData = this.formatWeekData(this.$refs.Billable.weekData);
        this.$refs.NonBillable.weekData = this.formatWeekData(this.$refs.NonBillable.weekData);
      }
    },

    onChangeProjectWeeklyEntry(projectId) {
      this.$store.dispatch('fetchProjectRFxData', { id: projectId });
      this.getTimeEntries();
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
      if (this.$refs.AddimeRecords.validate()) {
        if (this.activeTab === 'weekly') {
          this.submitWeekData();
        } else {
          const nonBillableBatchEntry = this.$refs.nonBillableBatchEntry.prepareDataForSubmission();
          const billableBatchEntry = this.$refs.billableBatchEntry.prepareDataForSubmission();
          this.submitBatchData(nonBillableBatchEntry, billableBatchEntry);
        }
      }
    },
    clearTimeEntries() {
      this.clearWeekEntry();
      this.clearBatchEntry();
    },
    clearWeekEntry() {
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
    },
    clearBatchEntry() {
      this.$refs.nonBillableBatchEntry.weekEntries = [];
      this.$refs.billableBatchEntry.weekEntries = [];
      this.$refs.nonBillableBatchEntry.weekEntries.push(this.$refs.nonBillableBatchEntry.createEmptyWeekEntry());
      this.$refs.billableBatchEntry.weekEntries.push(this.$refs.billableBatchEntry.createEmptyWeekEntry());
    },
    async saveAndClose() {
      if (this.$refs.AddimeRecords.validate()) {
        if (this.activeTab === 'weekly') {
          this.submitWeekData(true);
        } else {
          const nonBillableBatchEntry = this.$refs.nonBillableBatchEntry.prepareDataForSubmission();
          const billableBatchEntry = this.$refs.billableBatchEntry.prepareDataForSubmission();
          this.submitBatchData(nonBillableBatchEntry, billableBatchEntry, true);
        }


        this.$refs.spinner.open();
        debugger;
        const timesheets = await this.$store.dispatch('fetchAllTimesheets');

        this.$refs.spinner.close();
      }
    },

    submitBatchData(nonBillableBatchEntry, billableBatchEntry, needToClose = false) {
      const timeSheetEntries = [];

      for (
        let itemIndex = 0;
        itemIndex < billableBatchEntry.length;
        itemIndex++
      ) {
        const startDate = this.getDatePart(billableBatchEntry[itemIndex].startDate);
        const endDate = this.getDatePart(this.$store.state.timesheetsWeek.endDate);
        const entries = billableBatchEntry[itemIndex].timesheetEntry;
        const timeEntries = [];
        const timeSheetEntry = {};

        for (let index = 0; index < entries.length; index++) {
          const dateOfEntry = this.getDatePart(entries[index].entryDate);
          const entry = {
            entryDate: dateOfEntry,
            hoursBillable: entries[index].hours ? entries[index].hours : 0,
            hoursUnBillable: 0,
            commentsBillable: '',
            commentsUnBillable: '',
            expenseAmount: 0,
            expenseComment: '',
          };
          timeEntries.push(entry);
        }
        timeSheetEntry.entries = timeEntries;
        timeSheetEntry.startDate = startDate;
        timeSheetEntry.endDate = endDate;
        timeSheetEntry.project = billableBatchEntry[itemIndex].projectId;
        timeSheetEntry.userId = this.form.userId;
        const projectMou = this.$store.state.projects.filter(item => item.id === billableBatchEntry[itemIndex].projectId);
        if (projectMou && projectMou[0]) {
          timeSheetEntry.mou = projectMou[0].mou.id;
        }

        if (!timeSheetEntry.project) continue;
        // timeSheetEntry.comment = billableBatchEntry[itemIndex].comment;
        timeSheetEntries.push(timeSheetEntry);
      }

      for (
        let itemIndex = 0;
        itemIndex < nonBillableBatchEntry.length;
        itemIndex++
      ) {
        const timeSheetEntry = {};
        const startDate = this.getDatePart(nonBillableBatchEntry[itemIndex].startDate);
        const endDate = this.getDatePart(nonBillableBatchEntry[itemIndex].endDate);
        timeSheetEntry.startDate = startDate;
        timeSheetEntry.endDate = endDate;

        timeSheetEntry.project = nonBillableBatchEntry[itemIndex].projectId;
        if (!timeSheetEntry.project) continue;
        // timeSheetEntry.comment = nonBillableBatchEntry[itemIndex].comment;
        const entries = nonBillableBatchEntry[itemIndex].timesheetEntry;

        // check for billable entry for the project, then update fields only
        const existingProjectEntry = timeSheetEntries.filter(
          item => item.startDate === timeSheetEntry.startDate
            && item.project === timeSheetEntry.project,
        );
        if (existingProjectEntry[0]) {
          // assuming one record for a project

          for (let index = 0; index < entries.length; index++) {
            // select existing entries
            const dateOfEntry = this.getDatePart(entries[index].entryDate);
            const existingEntry = existingProjectEntry[0].entries.filter(
              item => item.entryDate === dateOfEntry,
            );
            if (existingEntry[0]) {
              // update the item
              existingEntry[0].hoursUnBillable = entries[index].hours;
            } else {
              // add new item
              const entry = {
                entryDate: dateOfEntry,
                hoursBillable: 0,
                hoursUnBillable: entries[index].hours
                  ? entries[index].hours
                  : 0,
                commentsBillable: '',
                commentsUnBillable: '',
                expenseAmount: 0,
                expenseComment: '',
              };
              existingProjectEntry.push(entry);
            }
          }
        } else {
          // add new project
          const timeEntries = [];
          for (let index = 0; index < entries.length; index++) {
            const dateOfEntry = this.getDatePart(entries[index].entryDate);
            const entry = {
              entryDate: dateOfEntry,
              hoursBillable: 0,
              hoursUnBillable: entries[index].hours ? entries[index].hours : 0,
              commentsBillable: '',
              commentsUnBillable: '',
              expenseAmount: 0,
              expenseComment: '',
            };
            timeEntries.push(entry);
          }
          timeSheetEntry.entries = timeEntries;
          timeSheetEntries.push(timeSheetEntry);
        }
      }
      this.$refs.spinner.open();
      this.$store.dispatch('addBatchTimesheet', timeSheetEntries).then(
        () => {
          this.$refs.snackbar.displaySnackbar(
            'success',
            'Successfully added time entries.',
          );
          this.$refs.spinner.close();
          if (needToClose) {
            this.clearTimeEntries();
            this.closeDialog();
          }
        },
        (err) => {
          this.$refs.spinner.close();
          if (err && err.response && err.response.data) {
            const { message } = err.response.data.error;
            this.$refs.snackbar.displaySnackbar('error', message);
          } else {
            this.$refs.snackbar.displaySnackbar(
              'error',
              'Timesheet entry Error',
            );
          }
        },
      );
    },
    submitWeekData(needToClose = false) {
      const billableDetails = this.$refs.Billable.onBillableclick();
      const nonBillableDetails = this.$refs.NonBillable.nonBillableclick();

      const timeEntries = [];
      const startDate = new Date(this.$store.state.timesheetsWeek.startDate);
      for (let index = 0; index < 7; index++) {
        const entryDate = new Date(startDate);
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

      const formData = {
        entries: timeEntries,
        mou: this.form.mou,
        project: this.form.project,
        projectRfx: this.form.Rfx,
        startDate: timeEntries[0].entryDate,
        endDate: timeEntries[6].entryDate,
        userId: this.form.userId,
      };
      this.$refs.spinner.open();
      this.$store.dispatch('addLightTimesheet', formData).then(
        () => {
          this.$refs.snackbar.displaySnackbar(
            'success',
            'Successfully added time entries.',
          );
          this.$refs.spinner.close();
          if (needToClose) {
            this.clearTimeEntries();
            this.closeDialog();
          }
        },
        (err) => {
          this.$refs.spinner.close();
          if (err && err.response && err.response.data) {
            const { message } = err.response.data.error;
            this.$refs.snackbar.displaySnackbar('error', message);
          } else {
            this.$refs.snackbar.displaySnackbar(
              'error',
              'Timesheet entry Error',
            );
          }
          return false;
        },
      );
    },
    open() {
      this.dialog = true;
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
      const user = this.$store.state.users.find(
        value => value.referenceId === referenceId,
      );
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
        editMode: false,
        activeTab: 'batch',
        recordType: 1,
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
        dateRange: { start: null, end: null },
      };
    },
  },
};
</script>
