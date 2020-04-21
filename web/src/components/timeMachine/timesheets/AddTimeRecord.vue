<template>
  <v-layout row justify-center>
    <snackbar ref="snackbar"></snackbar>
    <v-dialog
      id="AddTimeRecord"
      content-class="add-time-record"
      v-model="dialog"
      @input="closeDialog(false)"
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
                    <v-select
                      class="currentuser"
                      v-model="form.userId"
                      :rules="requiredRule"
                      @input="onChangeUser(form.userId)"
                      :items="userList"
                      item-value="id"
                      item-text="contact.fullName"
                      :disabled="editMode"
                      label="User"
                      validate-on-blur
                    ></v-select>
                  </v-flex>
                </v-flex>

                <v-flex class="d-flex cardheadlabel2">
                  <v-flex md4>
                    <v-flex v-if="form.project && activeTab === 'weekly'">
                      <b>MOU amount:</b>
                      ${{ mouAmount }}
                    </v-flex>
                  </v-flex>
                  <v-flex md4> <b>Currently Billed:</b> $0 </v-flex>
                  <v-flex md4> <b>Legal Billed Amount:</b> $0 </v-flex>
                </v-flex>
              </v-flex>
            </v-layout>
            <v-divider class="header-divider"></v-divider>
            <v-tabs v-model="activeTab">
              <v-tab href="#batch" @click="onBatchEntry()">Batch Entry</v-tab>
              <v-tab href="#weekly" @click="onWeekEntry()">Weekly Entry</v-tab>
              <v-tab-item value="batch">
                <v-flex>
                  <v-flex class="d-flex" cols="12" sm="6">
                    <v-flex md6 >
                      <timesheets-calendar
                        ref="TimeCalenderBatch"
                        @next="onChangeWeek"
                      ></timesheets-calendar>
                    </v-flex>
                    <v-flex md6>
                      <v-radio-group row v-model="recordType">
                        <v-radio label="Hours" :value="1"></v-radio>
                        <v-radio label="Unbillable Hours" :value="2"></v-radio>
                      </v-radio-group>
                    </v-flex>
                  </v-flex>

                  <v-flex v-show="recordType === 1">
                    <batch-time-entry
                      ref="billableBatchEntry"
                      :selectedItem="1"
                      :userId="form.userId"
                      :timesheet="timesheet"
                      :projectList="userMouProjects"
                      @add-row="addTimeSheetRow"
                    ></batch-time-entry>
                  </v-flex>
                  <v-flex v-show="recordType === 2">
                    <batch-time-entry
                      ref="nonBillableBatchEntry"
                      :selectedItem="2"
                      :userId="form.userId"
                      :timesheet="timesheet"
                      :projectList="userMouProjects"
                      @add-row="addTimeSheetRow"
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
                      @input="onChangeMou(false)"
                      validate-on-blur
                    ></v-select>
                  </v-flex>
                  <v-flex xs12>
                    <v-select
                      v-model="form.project"
                      :items="projectList"
                      :rules="requiredRule"
                      item-text="projectName"
                      item-value="id"
                      label="Project Name"
                      @input="onChangeProjectWeeklyEntry()"
                      :disabled="editMode"
                      validate-on-blur
                    ></v-select>
                  </v-flex>

                  <v-flex xs12>
                    <v-select
                      v-model="form.rfx"
                      :items="projectRfx"
                      item-text="rfxName"
                      item-value="id"
                      label="Project Rfx"
                      :disabled="form.is_locked"
                      @input="onChangeProjectRfx()"
                    ></v-select>
                  </v-flex>
                </v-flex>
                <v-flex>
                  <v-flex class="d-flex" cols="12" sm="6">
                    <v-flex md6 >
                      <timesheets-calendar
                        ref="TimeCalenderWeekly"
                        @next="onChangeWeek"
                      ></timesheets-calendar>
                    </v-flex>
                    <v-flex md6>
                      <v-radio-group row v-model="recordTypeWeekly">
                        <v-radio label="Hours" :value="1"></v-radio>
                        <v-radio label="Expenses" :value="2"></v-radio>
                        <v-radio label="Revenue" :value="3"></v-radio>
                        <v-radio label="Unbillable Hours" :value="4"></v-radio>
                      </v-radio-group>
                    </v-flex>
                  </v-flex>
                  <v-flex v-show="recordTypeWeekly === 1">
                    <timesheet-entry
                      ref="Billable"
                      :timesheet="computeTimesheet"
                      :selectedItem="1"
                      :days="timesheetEntryDays"
                      :projectIndex="weeklyProjectIndex"
                    ></timesheet-entry>
                  </v-flex>
                  <v-flex v-show="recordTypeWeekly === 2">
                    <expense-entry
                      ref="AddExpense"
                      :timesheet="computeTimesheet"
                      :days="timesheetEntryDays"
                      :projectIndex="weeklyProjectIndex"
                    ></expense-entry>
                  </v-flex>
                  <v-flex v-show="recordTypeWeekly === 3">
                    <revenue-entry
                      ref="AddRevenue"
                      :timesheet="computeTimesheet"
                      :days="timesheetEntryDays"
                      :projectIndex="weeklyProjectIndex"
                    ></revenue-entry>
                  </v-flex>
                  <v-flex v-show="recordTypeWeekly === 4">
                    <timesheet-entry
                      ref="NonBillable"
                      :timesheet="computeTimesheet"
                      :selectedItem="4"
                      :days="timesheetEntryDays"
                      :projectIndex="weeklyProjectIndex"
                    ></timesheet-entry>
                  </v-flex>
                </v-flex>
              </v-tab-item>
            </v-tabs>
          </v-card-text>
          <v-divider class="header-divider"></v-divider>
          <v-card-actions>
            <v-btn class="btn-discard" @click="closeDialog(false)" :ripple="false"
              >DISCARD TIMESHEET</v-btn
            >
            <v-flex class="add-btns">
              <v-btn class="btn-normal" @click="expotTimesheet()">EXPORT TIMESHEET</v-btn>
              <v-btn class="add-new-row" color="primary" @click="save()"  :disabled="form.is_locked && editMode">SUBMIT</v-btn>
            </v-flex>
          </v-card-actions>
        </v-card>
      </v-form>
      <!-- <pre>

     Timesheet:{{this.timesheet}}
        </pre> -->
    </v-dialog>
  </v-layout>
</template>
<script>
import './addtimerecord.styl';
import moment from 'moment';
import Snackbar from '../common/Snackbar.vue';
import Spinner from '../common/Spinner.vue';
import TimesheetsCalendar from './TimesheetsCalendar.vue';
import ExpenseEntry from './AddExpense.vue';
import RevenueEntry from './AddRevenue.vue';
import TimesheetEntry from './TimesheetEntry.vue';
import BatchTimeEntry from './BatchTimeEntry.vue';

export default {
  computed: {
    computeTimesheet: {
      get() {
        if (this.form.project === undefined || this.form.project === '') {
          if (this.blankTimesheet.length === 0) {
            this.addTimeSheetRow(true);
          }

          return this.blankTimesheet;
        }
        return this.timesheet;
      },
    },

    mouList() {
      return this.$store.state.mouList;
    },
    userList() {
      return this.$store.state.users;
    },
    timesheetEntryData() {
      return this.$store.state.timesheetEntryData;
    },
    projectRfx() {
      return this.$store.state.activeProjectRfxData;
      // if (typeof this.form.project !== 'undefined') {
      //   if (this.$store.state.activeProjectRfxData.length === 1) {
      //     if (this.$store.state.activeProjectRfxData[0].id === '') {
      //       return [];
      //     }
      //   }
      //   return this.$store.state.activeProjectRfxData;
      // }
      // return [];
    },
    mouAmount() {
      if (!this.form || !this.form.mou || !this.form.project) {
        return '';
      }
      const selectedProject = this.userMouProjects.filter(item => item.id === this.form.project);
      if (selectedProject[0]) {
        return selectedProject[0].mouAmount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
      }
      return '';
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
  props: {},
  created() {
    this.clearTimesheet();
  },
  methods: {
    fetchUser() {
      const referenceId = this.$store.state.activeUser.refId;
      const user = this.$store.state.users.find(value => value.referenceId === referenceId);
      if (user && user.id) {
        this.userMouProjects = this.$store.state.allProjects.filter(
          item => item.mou && (item.backupUserId === user.id || item.leadUserId === user.id),
        );
        return user.id;
      }
      return '';
    },
    initData() {
      const form = Object.assign({});
      return {
        weeklyProjectIndex: 0,
        timesheetEntryDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        timesheet: [],
        blankTimesheet: [],
        userMouProjects: [],
        projectList: [],
        editMode: false,
        activeTab: 'weekly',
        recordType: 1,
        recordTypeWeekly: 1,
        valid: true,
        requiredRule: [v => !!v || 'This field required'],
        dialog: false,
        form: { ...form },
      };
    },
    onChangeUser(userId, editMode = false) {
      if (this.$refs.spinner) {
        this.$refs.spinner.open();
      }
      this.clearTimesheet();
      this.form.userId = userId;
      this.userMouProjects = this.$store.state.allProjects.filter(
        item => item.mou
          && (item.backupUserId === this.form.userId || item.leadUserId === this.form.userId || item.teamWideProject === true),
      );
      if (!editMode) {
        this.getTimeSheets();
      }
      if (this.$refs.spinner) {
        this.$refs.spinner.close();
      }
    },
    onChangeMou(editMode) {
      if (
        typeof this.form.mou !== 'undefined'
        && typeof this.form.userId !== 'undefined'
        && this.form.mou
        && this.form.userId
      ) {
        this.projectList = this.userMouProjects.filter(
          item => item.mou
            && (item.backupUserId === this.form.userId || item.leadUserId === this.form.userId || item.teamWideProject === true)
            && item.mou.id === this.form.mou,
        );
      } else {
        this.projectList = [];
      }
      this.form.is_locked = false;
      this.form.project = undefined;
      this.$store.state.activeProjectRfxData = [];
      this.form.rfx = undefined;
      if (!editMode) {this.selectWeeklyProject(undefined, this.form.mou);}
      // this.selectWeeklyProject(undefined, this.form.mou);
      // if (this.projectList.length > 0) {
      //   this.selectWeeklyProject(this.projectList[0].id, this.form.mou);
      // } else { this.selectWeeklyProject(undefined, this.form.mou); }
    },
    onBatchEntry() {
      if (this.timesheet.length > 1) {
        this.timesheet = this.timesheet.filter(
          item => item.project !== '' && item.project !== undefined,
        );
        if (this.timesheet.length === 0) {
          this.AddimeRecords();
        }
        // this.selectWeeklyProject(this.form.project, this.form.mou);
      }
    },
    onWeekEntry() {
      if (this.weeklyProjectIndex !== 0 && this.timesheet[this.weeklyProjectIndex].deleted) {
        this.weeklyProjectIndex = 0;
      }
    },
    selectWeeklyProject(projectId, mou) {
      let projectIndex = -1;
      for (let index = 0; index < this.timesheet.length; index++) {
        if (this.timesheet[index].project === projectId && !this.timesheet[index].deleted) {
          projectIndex = index;
        }
      }
      if (projectIndex === -1) {
        this.timesheet = this.timesheet.filter(
          item => item.project !== '' && item.project !== undefined,
        );
        this.addTimeSheetRow();
        this.weeklyProjectIndex = this.timesheet.length - 1;
      } else {
        this.weeklyProjectIndex = projectIndex;
      }

      this.timesheet[this.weeklyProjectIndex].project = projectId;
      this.timesheet[this.weeklyProjectIndex].mou = mou;

      if (projectId !== '' && projectId !== undefined) {
        this.$store.dispatch('fetchProjectRFxData', { id: projectId });
        this.form.rfx = this.timesheet[this.weeklyProjectIndex].projectRfx;
      }
      this.form.is_locked = this.timesheet[this.weeklyProjectIndex].is_locked;
      // this.form.mou = mou;
      // this.form.project = projectId;
    },
    onChangeProjectWeeklyEntry() {
      if (this.$refs.spinner) {
        this.$refs.spinner.open();
      }
      // Keep index of weekly entry selected project. This is used to set props value to weekly entry components.

      this.$store.state.activeProjectRfxData = [];
      this.form.rfx = undefined;
      this.selectWeeklyProject(this.form.project, this.form.mou);
      this.blankTimesheet = [];
      this.addTimeSheetRow(true);
      if (this.$refs.spinner) {
        this.$refs.spinner.close();
      }
    },
    onChangeProjectRfx() {
      this.timesheet[this.weeklyProjectIndex].projectRfx = this.form.rfx;
    },
    onChangeWeek() {
      if (this.$refs.spinner) {
        this.$refs.spinner.open();
      }
      this.getTimeSheets(true);
      if (this.$refs.spinner) {
        this.$refs.spinner.close();
      }
    },
    async getTimeSheets(weekChange = false) {
      this.clearTimesheet(weekChange);
      if (!this.form.userId) {
        return;
      }
      const date = this.getDatePart(this.$store.state.timesheetsWeek.startDate);

      const formData = {
        startDate: date,
        userId: this.form.userId,
      };
      const vm = this;
      vm.$store.dispatch('fetchTimesheetEntries', formData).then(() => {
        const obj = vm.$store.state.timesheetEntryData;
        if (obj && obj[0] && obj[0].timesheetEntries) {
          vm.timesheet = [];
          for (let index = 0; index < obj.length; index++) {
            const timesheetItem = {};
            timesheetItem.project = obj[index].project.id;
            timesheetItem.mou = obj[index].mou.id;
            timesheetItem.projectRfx = obj[index].projectRfx ? obj[index].projectRfx.id : undefined;
            timesheetItem.userId = obj[index].userId;
            timesheetItem.startDate = obj[index].startDate;
            timesheetItem.endDate = obj[index].endDate;
            timesheetItem.deleted = false;
            timesheetItem.id = obj[index].id;
            timesheetItem.entries = obj[index].timesheetEntries;
            timesheetItem.is_locked = obj[index].is_locked;
            vm.timesheet.push(timesheetItem);
          }
          vm.$refs.TimeCalenderWeekly.setCalendarText();
          vm.$refs.TimeCalenderBatch.setCalendarText();

          vm.$refs.billableBatchEntry.editMode = false;
          vm.$refs.nonBillableBatchEntry.editMode = false;
          vm.editMode = false;

          if (vm.form.project && vm.form.mou && weekChange) {
            if (this.activeTab === 'weekly') {
              vm.selectWeeklyProject(vm.form.project, vm.form.mou);
            } else {
              vm.form.project = undefined;
              vm.form.mou = undefined;
              this.form.is_locked = false;
            }
            vm.blankTimesheet = [];
            vm.addTimeSheetRow(true);
          }

          // if (!vm.form.project && vm.timesheet.length > 0) {
          //   vm.form.mou = vm.timesheet[0].mou;
          //   vm.onChangeMou();
          //   vm.form.project = vm.timesheet[0].project;
          // }
          // vm.selectWeeklyProject(vm.form.project, vm.form.mou);
        }
        if (vm.form.project && vm.form.mou && weekChange) {
          if (this.activeTab === 'weekly') {
            vm.selectWeeklyProject(vm.form.project, vm.form.mou);
          } else {
            vm.form.project = undefined;
            vm.form.mou = undefined;
            this.form.is_locked = false;
          }
          vm.blankTimesheet = [];
          vm.addTimeSheetRow(true);
        }
      });
    },

    async editTimeEntries(timeSheetId) {
      const vm = this;
      vm.$store.dispatch('fetchTimesheetById', { id: timeSheetId }).then(() => {
        const obj = vm.$store.state.timesheetById;

        this.onChangeUser(obj.userId, true);

        vm.timesheet[vm.weeklyProjectIndex].entries = obj.timesheetEntries;
        vm.timesheet[vm.weeklyProjectIndex].startDate = obj.startDate;
        vm.timesheet[vm.weeklyProjectIndex].endDate = obj.endDate;
        vm.timesheet[vm.weeklyProjectIndex].userId = obj.userId;
        vm.timesheet[vm.weeklyProjectIndex].mou = obj.mou.id;
        vm.timesheet[vm.weeklyProjectIndex].project = obj.project.id;
        vm.timesheet[vm.weeklyProjectIndex].is_locked = obj.is_locked;
        vm.timesheet[vm.weeklyProjectIndex].projectRfx = obj.projectRfx
          ? obj.projectRfx.id
          : undefined;
        vm.timesheet[vm.weeklyProjectIndex].deleted = false;
        vm.$store.state.timesheetsWeek.startDate = vm.timesheet[vm.weeklyProjectIndex].startDate;
        vm.$store.state.timesheetsWeek.endDate = vm.timesheet[vm.weeklyProjectIndex].endDate;
        vm.$refs.TimeCalenderWeekly.setCalendarText();
        vm.$refs.TimeCalenderBatch.setCalendarText();

        vm.form.mou = vm.timesheet[vm.weeklyProjectIndex].mou;
        this.onChangeMou(true);

        this.form.is_locked = vm.timesheet[vm.weeklyProjectIndex].is_locked;
        vm.form.project = vm.timesheet[vm.weeklyProjectIndex].project;
        vm.$store.dispatch('fetchProjectRFxData', { id: vm.form.project });
        vm.form.rfx = vm.timesheet[vm.weeklyProjectIndex].projectRfx
          ? vm.timesheet[vm.weeklyProjectIndex].projectRfx
          : undefined;

        vm.activeTab = 'weekly';
        vm.editMode = true;
        vm.$refs.billableBatchEntry.editMode = true;
        vm.$refs.nonBillableBatchEntry.editMode = true;
        this.blankTimesheet = [];
        this.addTimeSheetRow(true);
      });
    },

    open(editMode = false) {
      this.initData();
      this.$refs.AddimeRecords.resetValidation();
      this.form.userId = this.fetchUser();
      if (this.form.userId) {
        this.onChangeUser(this.form.userId, editMode);
      } else {
        this.clearTimesheet();
      }
      this.$refs.TimeCalenderBatch.disableWeekPicker(editMode);
      this.$refs.TimeCalenderWeekly.disableWeekPicker(editMode);
      this.dialog = true;
      setTimeout(() => {
        if (document.getElementsByClassName('v-dialog v-dialog--active')[0]) {
          document.getElementsByClassName('v-dialog v-dialog--active')[0].scrollTop = 0;
        }
      }, 400);
    },
    closeDialog(needRefresh) {
      this.dialog = false;
      this.$emit('close-timesheet', needRefresh);
    },
    async save() {
      if (this.$refs.AddimeRecords.validate()) {
        if (
          !this.$refs.Billable.validate()
          || !this.$refs.NonBillable.validate()
          || !this.$refs.AddRevenue.validate()
          || !this.$refs.AddExpense.validate()
        ) {
          this.$refs.snackbar.displaySnackbarTop('error', 'Please correct validation errors.');
          return;
        }
        if (this.activeTab === 'batch') {
          const validRecords = this.timesheet.filter(
            item => item.project !== '' && item.project !== undefined,
          );

          if (validRecords.length === 0) {
            return;
          }
        }
        this.saveTimesheets();
      } else {
        this.$refs.snackbar.displaySnackbarTop('error', 'Please correct validation errors.');
      }
    },

    saveTimesheets() {
      const submitItems = this.timesheet.filter(
        item => item.project !== '' && item.project !== undefined,
      );
      this.$refs.spinner.open();
      this.$store.dispatch('addBatchTimesheet', submitItems).then(
        () => {
          this.$refs.snackbar.displaySnackbar('success', 'Successfully saved time entries.');
          this.$refs.spinner.close();
          this.closeDialog(true);
        },
        (err) => {
          this.$refs.spinner.close();
          if (err && err.response && err.response.data) {
            const { message } = err.response.data.error;
            this.$refs.snackbar.displaySnackbarTop('error', message);
          } else {
            this.$refs.snackbar.displaySnackbarTop('error', 'Timesheet entry Error');
          }
        },
      );
    },

    stringToDate(dateString) {
      const parts = dateString.split('-');
      return new Date(parts[0], parts[1] - 1, parts[2]);
    },
    getDatePart(date) {
      if (typeof date !== 'string') {
        date = date.format('YYYY-MM-DD');
      }
      date = this.stringToDate(date);
      return this.getDateInYYYYMMDD(date);
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
    clearTimesheet(weekChange = false) {
      if (!weekChange) {
        this.form.mou = undefined;
        this.form.project = undefined;
        this.form.rfx = undefined;
        this.form.is_locked = false;
      }
      this.clearTimeEntries();
    },
    clearTimeEntries() {
      this.timesheet = [];
      this.addTimeSheetRow();
      this.recordTypeWeekly = 1;
      this.recordType = 1;
      this.weeklyProjectIndex = 0;
    },
    addTimeSheetRow(blankRow = false) {
      let entryDate = new Date();
      if (this.$store.state.timesheetsWeek && this.$store.state.timesheetsWeek.startDate) {
        const startDate = this.stringToDate(this.$store.state.timesheetsWeek.startDate);
        entryDate = new Date(startDate);
      }
      const timesheetEntries = [];
      const timesheetItem = {};
      for (let index = 0; index < 7; index++) {
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
        timesheetEntries.push(entry);
        entryDate.setDate(entryDate.getDate() + 1);
      }
      timesheetItem.entries = timesheetEntries;
      // if (this.activeTab === 'weekly' && !blankRow) {
      //   timesheetItem.projectRfx = this.form.rfx ? this.form.rfx : undefined;
      //   timesheetItem.project = this.form.project;
      //   timesheetItem.userId = this.form && this.form.userId ? this.form.userId : undefined;
      //   timesheetItem.mou = this.form.mou;
      // } else {
      timesheetItem.id = undefined;
      timesheetItem.deleted = false;
      timesheetItem.projectRfx = undefined;
      timesheetItem.project = undefined;
      timesheetItem.userId = this.form && this.form.userId ? this.form.userId : undefined;
      timesheetItem.mou = undefined;
      timesheetItem.is_locked = false;
      // }

      timesheetItem.startDate = timesheetItem.entries[0].entryDate;
      timesheetItem.endDate = timesheetItem.entries[6].entryDate;
      if (!blankRow) {
        this.timesheet.push(timesheetItem);
      } else {
        this.blankTimesheet.push(timesheetItem);
      }
    },
    ConvertToCSV(objArray) {
      const array = typeof objArray !== 'object' ? JSON.parse(objArray) : objArray;
      const str = '';
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
      if (window.navigator.msSaveOrOpenBlob) {
        const blob = new Blob([data]);
        window.navigator.msSaveOrOpenBlob(blob, 'export.csv');
      } else {
        link.setAttribute('href', data);
        link.setAttribute('download', 'export.csv');
        link.click();
      }
    },
    expotTimesheet() {
      if (!this.form.userId) {
        this.$refs.snackbar.displaySnackbarTop('error', 'Please select user.');
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
            timeEntries.push({
              Project: currentProject,
              'Entry Date': entry.entryDate,
              'Billable Hours': entry.hoursBillable,
              'Billable Comments': entry.commentsBillable,
              'Unbillable Hours': entry.hoursUnBillable,
              'Unbillable Comments': entry.commentsUnBillable,
              'Expense Amount': entry.expenseAmount,
              'Expense Category': entry.expenseCategory,
              'Expense Description': entry.expenseComment,
              'Revenue Amount': entry.revenueAmount,
              'Revenue Description': entry.revenueComment,
            });
          }
        }
        this.csvExport(timeEntries);
      });
    },
  },
};
</script>
