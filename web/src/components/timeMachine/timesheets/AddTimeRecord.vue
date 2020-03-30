<template>
  <v-layout row justify-center>
    <snackbar ref="snackbar"></snackbar>
    <v-dialog
      id="AddTimeRecord"
      content-class="add-time-record"
      v-model="dialog"
      @input="closeDialog()"
    >
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
                    <v-select class = 'currentuser'
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
                   <v-flex> <b>Legal Billed Amount:</b> $0 </v-flex>
                </v-flex>
              </v-flex>
            </v-layout>
            <v-divider class="header-divider"></v-divider>
            <v-tabs v-model="activeTab">
              <v-tab href="#batch" @click="initializeBatchEntry()">Batch Entry</v-tab>
              <v-tab href="#weekly">Weekly Entry</v-tab>
              <v-tab-item value="batch">
                <v-flex>
                  <v-flex class="d-flex" cols="12" sm="6">
                    <v-flex md6 v-show="!editMode">
                      <timesheets-calendar
                        ref="TimeCalenderBatch"
                        @next="initializeBatchEntry"
                      ></timesheets-calendar>
                    </v-flex>
                    <v-flex md6>
                      <v-radio-group row v-model="recordType">
                        <v-radio label="Hours" :value="1"></v-radio>
                        <v-radio label="Unbillable Hours" :value="3"></v-radio>
                      </v-radio-group>
                    </v-flex>
                  </v-flex>

                  <v-flex v-show="recordType === 1">
                    <batch-time-entry ref="billableBatchEntry" :selectedItem="1"></batch-time-entry>
                  </v-flex>
                  <v-flex v-show="recordType === 3">
                    <batch-time-entry
                      ref="nonBillableBatchEntry"
                      :selectedItem="3"
                    ></batch-time-entry>
                  </v-flex>
                </v-flex>
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
                      :disabled="editMode"
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
                      :disabled="editMode"
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
                    <v-flex md6 v-show="!editMode">
                      <timesheets-calendar
                        ref="TimeCalenderWeekly"
                        @next="checkWeekChangeWeekly"
                      ></timesheets-calendar>
                    </v-flex>
                    <v-flex md6>
                      <v-radio-group row v-model="recordType">
                        <v-radio label="Hours" :value="1"></v-radio>
                        <v-radio label="Expenses" :value="2"></v-radio>
                        <v-radio label="Revenue" :value="4"></v-radio>
                        <v-radio label="Unbillable Hours" :value="3"></v-radio>
                      </v-radio-group>
                    </v-flex>
                  </v-flex>
                  <v-flex v-show="recordType === 1">
                    <timesheet-entry ref="Billable"></timesheet-entry>
                  </v-flex>
                  <v-flex v-show="recordType === 2">
                    <expense-entry ref="AddExpense"></expense-entry>
                  </v-flex>
                   <v-flex v-show="recordType === 4">
                    <revenue-entry ref="AddRevenue"></revenue-entry>
                  </v-flex>
                  <v-flex v-show="recordType === 3">
                    <timesheet-entry ref="NonBillable" single-row></timesheet-entry>
                  </v-flex>
                </v-flex>
              </v-tab-item>
            </v-tabs>
          </v-card-text>
          <v-divider class="header-divider"></v-divider>
          <v-card-actions>
            <v-btn class="btn-discard" @click="closeDialog()" :ripple="false">DISCARD TIMESHEET</v-btn>
            <v-flex class="add-btns">
              <v-btn class="btn-normal" @click="expotTimesheet()">EXPORT TIMESHEET</v-btn>
              <v-btn class="btn-normal" @click="saveAndCopy()">SAVE AND COPY</v-btn>
              <v-btn class="add-new-row" color="primary" @click="saveAndClose()"
                >SUBMIT</v-btn
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
import ExpenseEntry from './AddExpense.vue';
import RevenueEntry from './AddRevenue.vue';
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
      if (!this.form || !this.form.mou) {
        return '';
      }
      const mou = this.$store.state.mouList.filter(item => item.id === this.form.mou);
      if (mou[0]) {
        return mou[0].name.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
      }
      return '';
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
    TimesheetEntry,
    BatchTimeEntry,
    ExpenseEntry,
    RevenueEntry,
  },
  data() {
    return this.initData();
  },
  watch: {},
  props: {
    timeEntry: Object,
  },
  methods: {
    ConvertToCSV(objArray) {
      const array = typeof objArray !== 'object' ? JSON.parse(objArray) : objArray;
      let str = '';

      for (let i = 0; i < array.length; i++) {
        let line = '';
        for (const index in array[i]) {
          if (line != '') line += ',';

          line += array[i][index];
        }

        str += `${line}\r\n`;
      }

      return str;
    },


    csvExport(arrData) {
      let csvContent = 'data:text/csv;charset=utf-8,';
      csvContent += [
        Object.keys(arrData[0]).join(';'),
        ...arrData.map(item => Object.values(item).join(';')),
      ]
        .join('\n')
        .replace(/(^\[)|(\]$)/gm, '');

      const data = encodeURI(csvContent);
      const link = document.createElement('a');
      link.setAttribute('href', data);
      link.setAttribute('download', 'export.csv');
      link.click();
    },

    expotTimesheet() {
      if (!(this.form.userId)) {
        this.$refs.snackbar.displaySnackbar('error', 'Please select user.');
        return;
      }
      const formData = {

        userId: this.form.userId,
      };
      const vm = this;

      vm.$store.dispatch('fetchTimesheetEntriesByUser', formData).then(() => {
        const timeEntries = [];
        for (let i = 0; i < vm.$store.state.timesheetEntryDatabyUser.length; i++) {
          const entries = vm.$store.state.timesheetEntryDatabyUser[i].timesheetEntries;
          const currentProject = vm.$store.state.timesheetEntryDatabyUser[i].project.projectName;

          for (let j = 0; j < entries.length; j++) {
            const entry = entries[j];

            timeEntries.push({ Project: currentProject,
              'Entry Date': entry.entryDate,
              'Billable Hours': entry.hoursBillable,
              'Billable Comments': entry.commentsBillable,
              'Unbillable Hours': entry.hoursUnBillable,
              'Unbillable Comments': entry.commentsUnBillable,
              'Expense Amount': entry.expenseAmount,
              'Expense Category': entry.expenseCategory,
              'Expense Description': entry.expenseComment,
              'Revenue Amount': entry.revenueAmount,
              'Revenue Description': entry.revenueComment });
          }
        }
        this.csvExport(timeEntries);
      });
    },
    onChangeMouWeeklyEntry() {
      return this.projectList;
    },
    getDatePart(date) {
      const dateValue = new Date(date);
      return this.getDateInYYYYMMDD(dateValue);
    },
    async checkWeekChangeWeekly() {
      this.getTimeEntries();
    },
    async getTimeEntries() {
      this.clearTimeEntries();
      this.$refs.billableBatchEntry.editMode = false;
      this.$refs.nonBillableBatchEntry.editMode = false;
      this.editMode = false;
      const date = this.getDatePart(this.$store.state.timesheetsWeek.startDate);
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
        this.$refs.billableBatchEntry.weekEntries[0].projectId = this.form.project;
        this.$refs.nonBillableBatchEntry.weekEntries[0].projectId = this.form.project;
        vm.initTimeEntries(vm.$store.state.timesheetEntryData);
      });
    },

    async editTimeEntries(obj) {
      this.$store.state.timesheetsWeek.startDate = obj.startDate;
      this.$store.state.timesheetsWeek.endDate = obj.endDate;
      this.$refs.TimeCalenderWeekly.setCalendarText();
      this.$refs.TimeCalenderBatch.setCalendarText();
      this.form.userId = obj.user.id;
      this.form.mou = obj.mou.id;
      this.onChangeMouWeeklyEntry();
      this.form.project = obj.project.id;
      this.$store.dispatch('fetchProjectRFxData', { id: obj.project.id });
      // this.onChangeProjectWeeklyEntry(obj.project.id);
      this.form.Rfx = obj.projectRfx ? obj.projectRfx.id : '';
      this.activeTab = 'weekly';
      this.$refs.billableBatchEntry.weekEntries[0].projectId = obj.project.id;
      this.$refs.nonBillableBatchEntry.weekEntries[0].projectId = obj.project.id;
      this.initTimeEntries(obj);
      this.editMode = true;
      this.$refs.billableBatchEntry.editMode = true;
      this.$refs.nonBillableBatchEntry.editMode = true;
    },
    formatWeekData(weekData) {
      const weeks = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      for (let i = 0; i < weekData[i].length; i++) {
        weekData[i].day = weeks[i];
      }
      return weekData;
    },
    initializeBatchEntry() {
      if (!this.editMode) {
        const date = this.getDatePart(this.$store.state.timesheetsWeek.startDate);
        const selectedProjects = this.$store.state.allTimesheets.filter(
          item => this.getDatePart(item.startDate) === date,
        );
        this.clearBatchEntry();
        for (let i = 0; i < selectedProjects.length; i++) {
          if (i > 0) {
            this.$refs.billableBatchEntry.addRow();
            this.$refs.nonBillableBatchEntry.addRow();
          }

          this.$refs.billableBatchEntry.weekEntries[i].projectId = selectedProjects[i].project.id;
          this.$refs.nonBillableBatchEntry.weekEntries[i].projectId = selectedProjects[i].project.id;
          if (selectedProjects[i].timesheetEntries.length > 4) {
            const selectedEntries = selectedProjects[i].timesheetEntries;
            this.$refs.billableBatchEntry.weekEntries[i].monday.hours = selectedEntries[0].hoursBillable;
            this.$refs.billableBatchEntry.weekEntries[i].tuesday.hours = selectedEntries[1].hoursBillable;
            this.$refs.billableBatchEntry.weekEntries[i].wednesday.hours = selectedEntries[2].hoursBillable;
            this.$refs.billableBatchEntry.weekEntries[i].thursday.hours = selectedEntries[3].hoursBillable;
            this.$refs.billableBatchEntry.weekEntries[i].friday.hours = selectedEntries[4].hoursBillable;

            this.$refs.nonBillableBatchEntry.weekEntries[i].monday.hours = selectedEntries[0].hoursUnBillable;
            this.$refs.nonBillableBatchEntry.weekEntries[i].tuesday.hours = selectedEntries[1].hoursUnBillable;
            this.$refs.nonBillableBatchEntry.weekEntries[i].wednesday.hours = selectedEntries[2].hoursUnBillable;
            this.$refs.nonBillableBatchEntry.weekEntries[i].thursday.hours = selectedEntries[3].hoursUnBillable;
            this.$refs.nonBillableBatchEntry.weekEntries[i].friday.hours = selectedEntries[4].hoursUnBillable;
          }
        }
      }
    },
    initTimeEntries(timesheetEntryData) {
      if (timesheetEntryData && timesheetEntryData.timesheetEntries) {
        for (let index = 0; index < timesheetEntryData.timesheetEntries.length; index++) {
          const entry = timesheetEntryData.timesheetEntries[index];

          // Weekly entry expenses
          this.$refs.AddExpense.weekData[index].entryDate = entry.entryDate;
          this.$refs.AddExpense.weekData[index].category = entry.expenseCategory;
          this.$refs.AddExpense.weekData[index].amount = entry.expenseAmount;
          this.$refs.AddExpense.weekData[index].description = entry.expenseComment;

          // Weekly entry revenue
          this.$refs.AddRevenue.weekData[index].entryDate = entry.entryDate;
          this.$refs.AddRevenue.weekData[index].amount = entry.revenueAmount;
          this.$refs.AddRevenue.weekData[index].description = entry.revenueComment;

          // Weekly entry billable
          this.$refs.Billable.weekData[index].entryDate = entry.entryDate;
          this.$refs.Billable.weekData[index].hours = entry.hoursBillable;
          this.$refs.Billable.weekData[index].description = entry.commentsBillable;

          // Weekly entry non billable
          this.$refs.NonBillable.weekData[index].entryDate = entry.entryDate;
          this.$refs.NonBillable.weekData[index].hours = entry.hoursUnBillable;
          this.$refs.NonBillable.weekData[index].description = entry.commentsUnBillable;
        }

        this.$refs.AddRevenue.weekData = this.formatWeekData(this.$refs.AddRevenue.weekData);
        this.$refs.AddExpense.weekData = this.formatWeekData(this.$refs.AddExpense.weekData);
        this.$refs.Billable.weekData = this.formatWeekData(this.$refs.Billable.weekData);
        this.$refs.NonBillable.weekData = this.formatWeekData(this.$refs.NonBillable.weekData);

        // Batch entry  billable
        this.$refs.billableBatchEntry.weekEntries[0].monday.hours = this.$refs.Billable.weekData[0].hours;
        this.$refs.billableBatchEntry.weekEntries[0].tuesday.hours = this.$refs.Billable.weekData[1].hours;
        this.$refs.billableBatchEntry.weekEntries[0].wednesday.hours = this.$refs.Billable.weekData[2].hours;
        this.$refs.billableBatchEntry.weekEntries[0].thursday.hours = this.$refs.Billable.weekData[3].hours;
        this.$refs.billableBatchEntry.weekEntries[0].friday.hours = this.$refs.Billable.weekData[4].hours;

        // Batch entry non billable
        this.$refs.nonBillableBatchEntry.weekEntries[0].monday.hours = this.$refs.NonBillable.weekData[0].hours;
        this.$refs.nonBillableBatchEntry.weekEntries[0].tuesday.hours = this.$refs.NonBillable.weekData[1].hours;
        this.$refs.nonBillableBatchEntry.weekEntries[0].wednesday.hours = this.$refs.NonBillable.weekData[2].hours;
        this.$refs.nonBillableBatchEntry.weekEntries[0].thursday.hours = this.$refs.NonBillable.weekData[3].hours;
        this.$refs.nonBillableBatchEntry.weekEntries[0].friday.hours = this.$refs.NonBillable.weekData[4].hours;
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
      const weekDataExpenses = [
        { day: 'Mon', description: '', amount: 0, category: '', date: '' },
        { day: 'Tue', description: '', amount: 0, category: '', date: '' },
        { day: 'Wed', description: '', amount: 0, category: '', date: '' },
        { day: 'Thu', description: '', amount: 0, category: '', date: '' },
        { day: 'Fri', description: '', amount: 0, category: '', date: '' },
        { day: 'Sat', description: '', amount: 0, category: '', date: '' },
        { day: 'Sun', description: '', amount: 0, category: '', date: '' },
      ];
      const weekDataRevenue = [
        { day: 'Mon', description: '', amount: 0, date: '' },
        { day: 'Tue', description: '', amount: 0, date: '' },
        { day: 'Wed', description: '', amount: 0, date: '' },
        { day: 'Thu', description: '', amount: 0, date: '' },
        { day: 'Fri', description: '', amount: 0, date: '' },
        { day: 'Sat', description: '', amount: 0, date: '' },
        { day: 'Sun', description: '', amount: 0, date: '' },
      ];

      this.$refs.AddRevenue.weekData = weekDataRevenue;
      this.$refs.AddExpense.weekData = weekDataExpenses;
      this.$refs.Billable.weekData = weekDataBillable;
      this.$refs.NonBillable.weekData = weekDataUnBillable;
    },
    clearBatchEntry() {
      this.$refs.nonBillableBatchEntry.weekEntries = [];
      this.$refs.billableBatchEntry.weekEntries = [];
      this.$refs.nonBillableBatchEntry.weekEntries.push(
        this.$refs.nonBillableBatchEntry.createEmptyWeekEntry(),
      );
      this.$refs.billableBatchEntry.weekEntries.push(
        this.$refs.billableBatchEntry.createEmptyWeekEntry(),
      );
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
      }
    },

    submitBatchData(nonBillableBatchEntry, billableBatchEntry, needToClose = false) {
      const timeSheetEntries = [];

      for (let itemIndex = 0; itemIndex < billableBatchEntry.length; itemIndex++) {
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
          };
          timeEntries.push(entry);
        }
        timeSheetEntry.entries = timeEntries;
        timeSheetEntry.startDate = startDate;
        timeSheetEntry.endDate = endDate;
        timeSheetEntry.project = billableBatchEntry[itemIndex].projectId;
        timeSheetEntry.userId = this.form.userId;
        const projectMou = this.$store.state.projects.filter(
          item => item.id === billableBatchEntry[itemIndex].projectId,
        );
        if (projectMou && projectMou[0]) {
          timeSheetEntry.mou = projectMou[0].mou.id;
        }

        if (!timeSheetEntry.project) continue;
        // timeSheetEntry.comment = billableBatchEntry[itemIndex].comment;
        timeSheetEntries.push(timeSheetEntry);
      }

      for (let itemIndex = 0; itemIndex < nonBillableBatchEntry.length; itemIndex++) {
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
          item => item.startDate === timeSheetEntry.startDate && item.project === timeSheetEntry.project,
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
                hoursUnBillable: entries[index].hours ? entries[index].hours : 0,
                commentsBillable: '',
                commentsUnBillable: '',
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
          this.$refs.snackbar.displaySnackbar('success', 'Successfully saved time entries.');
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
            this.$refs.snackbar.displaySnackbar('error', 'Timesheet entry Error');
          }
        },
      );
    },
    submitWeekData(needToClose = false) {
      const billableDetails = this.$refs.Billable.onBillableclick();
      const nonBillableDetails = this.$refs.NonBillable.nonBillableclick();
      const revenueDetails = this.$refs.AddRevenue.updateDate();
      const expensesDetails = this.$refs.AddExpense.updateDate();

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
          expenseCategory: '',
          revenueAmount: 0,
          revenueComment: '',
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
        if (revenueDetails.length > 0) {
          const revenue = revenueDetails.filter(
            item => item.date === timeEntries[index].entryDate,
          );
          if (revenue[0]) {
            timeEntries[index].revenueAmount = revenue[0].amount === '' ? 0 : revenue[0].amount;
            timeEntries[index].revenueComment = revenue[0].description;
          }
        }
        if (expensesDetails.length > 0) {
          const expense = expensesDetails.filter(
            item => item.date === timeEntries[index].entryDate,
          );
          if (expense[0]) {
            timeEntries[index].expenseCategory = expense[0].category;
            timeEntries[index].expenseAmount = expense[0].amount === '' ? 0 : expense[0].amount;
            timeEntries[index].expenseComment = expense[0].description;
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
          this.$refs.snackbar.displaySnackbar('success', 'Successfully saved time entries.');
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
            this.$refs.snackbar.displaySnackbar('error', 'Timesheet entry Error');
          }
          return false;
        },
      );
    },
    open() {
      this.dialog = true;
      setTimeout(() => {
        document.getElementsByClassName('v-dialog v-dialog--active')[0].scrollTop = 0;
      }, 400);
    },
    closeDialog() {
      this.$emit('close');
      this.dialog = false;
    },
    reset() {
      // this.$refs.form.resetValidation();
      this.clearTimeEntries();
      const data = this.initData();
      this.$data.valid = data.valid;
      this.$data.requiredRule = data.requiredRule;
      this.$data.requireRadioButtondRule = data.requireRadioButtondRule;
      this.$data.dialog = data.dialog;
      this.$data.menu1 = data.menu1;
      this.$data.form = data.form;
      this.$data.dateFormatted = data.dateFormatted;
      this.$data.existingTimeEntries = data.existingTimeEntries;
      this.activeTab = 'weekly';
      this.$refs.TimeCalenderWeekly.setCalendarText();
      this.$refs.TimeCalenderBatch.setCalendarText();
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
        editMode: false,
        activeTab: 'weekly',
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
