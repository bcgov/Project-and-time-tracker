/* eslint-disable vue/no-side-effects-in-computed-properties */
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
          <div class="mou-amount-warning">
            <v-system-bar v-if="!selectedProject().hasValidFinanceCodes" dark color="red">
              <v-icon dark medium>error</v-icon>
              <span class="pl-1"><b>This project has incomplete finance codes.</b></span>
            </v-system-bar>
            <v-system-bar v-if="selectedProject().mouUsedAmount > MOU_USED_AMOUNT_LEVELS.DANGER" dark color="red">
              <v-icon dark medium>error</v-icon>
              <span class="pl-1"><b>MOU value is overdrawn and a new MOU amendment would be needed.</b></span>
            </v-system-bar>
            <v-system-bar v-else-if="selectedProject().mouUsedAmount > MOU_USED_AMOUNT_LEVELS.WARNING" dark color="orange">
              <v-icon dark medium>warning</v-icon>
              <span class="pl-1"><b>MOU is within 10% of its remaining value.</b></span>
            </v-system-bar>
          </div>
          <v-card-text class="card-contents">
            <v-layout wrap>
              <v-flex md4>
                <v-card-title>
                  <span class="headline">Add Time Record</span>
                </v-card-title>
              </v-flex>
              <v-flex md8>
                <v-flex class="d-flex cardheadlabel1">
                  <v-flex md5 class="headerinfo">Information being entered by:</v-flex>
                  <v-flex md7>
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
                      ${{ selectedProject().mouAmount }}
                    </v-flex>
                  </v-flex>
                  <v-flex md4 v-if="timesheet && activeTab == 'batch'">
                    <b>Currently Billed:</b>
                    ${{ getBilledAmount() }}
                  </v-flex>
                  <v-flex
                    md4
                    v-else-if="
                      form.project &&
                        timesheet &&
                        timesheet[weeklyProjectIndex] &&
                        timesheet[weeklyProjectIndex].amountBilled
                    "
                  >
                    <b>Currently Billed:</b>
                    ${{ timesheet[weeklyProjectIndex].amountBilled }}
                  </v-flex>
                  <v-flex md4 v-else> <b>Currently Billed:</b> $0 </v-flex>
                  <v-flex md4> <b>Legal Billed Amount:</b> ${{ selectedProject().totalBilledAmount }} </v-flex>
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
                    <v-flex md6 class="week-change-control">
                      <timesheets-calendar
                        ref="TimeCalenderBatch"
                        @next="onChangeWeek"
                      ></timesheets-calendar>
                    </v-flex>
                    <v-flex md6>
                      <v-radio-group row v-model="recordType" class="justify-end">
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
                      :rules="requiredRule"
                      item-text="rfxName"
                      item-value="id"
                      label="Project Rfx"
                      :disabled="editMode"
                      @input="onChangeProjectRfx()"
                      validate-on-blur
                    ></v-select>
                  </v-flex>
                </v-flex>
                <v-flex>
                  <v-flex class="d-flex" cols="12" sm="6">
                    <v-flex md6 class="week-change-control">
                      <timesheets-calendar
                        ref="TimeCalenderWeekly"
                        @next="onChangeWeek"
                      ></timesheets-calendar>
                    </v-flex>
                    <v-flex md6>
                      <v-radio-group row v-model="recordTypeWeekly" class="justify-end">
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
          <br /><br />

          <v-divider class="header-divider"></v-divider>
          <v-card-actions>
            <BulkCSVExport
              ref="exporttimesheet"
              @exportTimeSheets="exportTimeSheets"
            ></BulkCSVExport>
            <v-btn class="btn-discard" @click="closeDialog(false)" :ripple="false"
              >DISCARD TIMESHEET</v-btn
            >
            <v-flex class="add-btns">
              <v-btn class="btn-normal" @click="openExportModal()">EXPORT TIMESHEET</v-btn>
              <v-btn
                class="add-new-row"
                color="primary"
                @click="save()"
                :disabled="form.is_locked && editMode"
                >{{ getSubmitButtonVal() }}</v-btn
              >
            </v-flex>
          </v-card-actions>
        </v-card>
      </v-form>
      <!-- <pre>

     Timesheet:{{this.timesheet}}
      </pre>-->
    </v-dialog>
  </v-layout>
</template>
<script>
import './addtimerecord.styl';
import Snackbar from '../common/Snackbar.vue';
import Spinner from '../common/Spinner.vue';
import TimesheetsCalendar from './TimesheetsCalendar.vue';
import ExpenseEntry from './AddExpense.vue';
import RevenueEntry from './AddRevenue.vue';
import TimesheetEntry from './TimesheetEntry.vue';
import BatchTimeEntry from './BatchTimeEntry.vue';
import BulkCSVExport from './BulkCSVExport.vue';

export default {
  computed: {
    computeTimesheet: {
      get() {
        if (this.form.rfx === undefined || this.form.rfx === '') {
          if (this.blankTimesheet.length === 0) {
            this.addTimeSheetRow(true);
          }
          // eslint-disable-next-line vue/no-side-effects-in-computed-properties
          this.weeklyProjectIndex = this.blankTimesheet.length - 1;
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
      return this.rfxList;
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
    BulkCSVExport,
  },
  data() {
    return this.initData();
  },
  watch: {},
  props: {},
  created() {
    this.clearTimesheet();
    this.MOU_USED_AMOUNT_LEVELS = {
      WARNING: 0.9,
      DANGER: 1
    };
  },
  methods: {
    openExportModal() {
      this.$refs.exporttimesheet.reset();
      this.$refs.exporttimesheet.open();
    },
    closeExportModal() {},
    getSubmitButtonVal() {
      if (this.editMode) return 'SAVE CHANGES';
      return 'SUBMIT';
    },
    getBilledAmount() {
      const sum = this.timesheet
        .filter(item => item.amountBilled && item.amountBilled > 0)
        .reduce((prev, cur) => prev + Number(cur.amountBilled), 0);
      return sum;
    },
    selectedProject() {
      if (this.form && this.form.mou && this.form.project) {
        const selectedProject = this.userMouProjects.filter(item => item.id === this.form.project);
        if (selectedProject[0]) {
          const project = selectedProject[0];
          return{
            mouAmount: project.mouAmount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ','),
            totalBilledAmount: project.totalAmountBilled.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ','),
            mouUsedAmount: project.totalAmountBilled / project.mouAmount,
            hasValidFinanceCodes: project.hasValidFinanceCodes || !project.isCostRecoverable
          }
        }
      }
      return{
        mouAmount: 0,
        totalBilledAmount: 0,
        mouUsedAmount: 0,
        hasValidFinanceCodes: true
      }
    },
    fetchUser() {
      const referenceId = this.$store.state.activeUser.refId;
      const user = this.$store.state.users.find(value => value.referenceId === referenceId);
      if (user && user.id) {
        // this.userMouProjects = this.$store.state.allProjects.filter(
        //   item => item.mou && (item.backupUserId === user.id || item.leadUserId === user.id),
        // );
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
        rfxList: [],
        editMode: false,
        activeTab: 'weekly',
        recordType: 1,
        recordTypeWeekly: 1,
        valid: true,
        exportStartDate: undefined,
        exportEndDate: undefined,
        requiredRule: [v => !!v || 'This field required'],
        dialog: false,
        form: { ...form }
      };
    },
    async onChangeUser(userId, editMode = false) {
      if (this.$refs.spinner) {
        this.$refs.spinner.open();
      }
      this.clearTimesheet();
      this.form.userId = userId;
      // this.userMouProjects = this.$store.state.allProjects.filter(
      //   item => item.mou
      //     && (item.backupUserId === this.form.userId
      //       || item.leadUserId === this.form.userId
      //       || item.teamWideProject === true),
      // );
      const vm = this;
      // vm.mouList = [];
      vm.projectList = [];
      vm.rfxList = [];
      vm.userMouProjects = [];
      await vm.$store.dispatch('fetchMouProjects', { id: userId }).then((res) => {
        vm.userMouProjects = res;
      });
      if (!editMode) {
        await this.getTimeSheets();
      }
      if (this.$refs.spinner) {
        this.$refs.spinner.close();
      }

      return vm.userMouProjects;
    },
    onChangeMou(editMode) {
      if (
        typeof this.form.mou !== 'undefined'
        && typeof this.form.userId !== 'undefined'
        && this.form.mou
        && this.form.userId
      ) {
        this.projectList = this.userMouProjects.filter(item => item.mouId === this.form.mou);
      } else {
        this.projectList = [];
      }
      this.form.is_locked = false;
      this.form.project = undefined;
      this.rfxList = [];
      this.form.rfx = undefined;
      if (!editMode) {
        this.form.is_locked = false;
      }
      // this.selectWeeklyProject(this.form.project, this.form.mou, this.form.rfx);
    },
    onBatchEntry() {
      if (this.timesheet.length > 1) {
        this.timesheet = this.timesheet.filter(
          item => item.project !== '' && item.project !== undefined,
        );
        if (this.timesheet.length === 0) {
          this.addTimeSheetRow();
        }
      }
      this.selectWeeklyProject();
    },
    onWeekEntry() {
      if (this.weeklyProjectIndex !== 0 && this.timesheet[this.weeklyProjectIndex].deleted) {
        this.weeklyProjectIndex = 0;
        this.form.is_locked = false;
      }
    },
    selectWeeklyProject(projectId, mou, rfx) {
      let projectIndex = -1;
      for (let index = 0; index < this.timesheet.length; index++) {
        if (this.timesheet[index].projectRfx === rfx && !this.timesheet[index].deleted) {
          projectIndex = index;
        }
      }
      if (projectIndex === -1) {
        this.timesheet = this.timesheet.filter(
          item => item.projectRfx !== '' && item.projectRfx !== undefined,
        );
        this.addTimeSheetRow();
        this.weeklyProjectIndex = this.timesheet.length - 1;
        this.form.is_locked = false;
      } else {
        this.weeklyProjectIndex = projectIndex;
        this.form.is_locked = this.timesheet[this.weeklyProjectIndex].is_locked;
      }

      this.timesheet[this.weeklyProjectIndex].project = projectId;
      this.timesheet[this.weeklyProjectIndex].mou = mou;
      this.timesheet[this.weeklyProjectIndex].projectRfx = rfx;

      this.rfxList = [];
      if (this.form.project !== '' && this.form.project !== undefined) {
        if (this.form.project) {
          const selProject = this.projectList.find(item => item.id === this.form.project);
          if (selProject) {
            this.rfxList = selProject.rfxList;
            this.form.rfx = this.timesheet[this.weeklyProjectIndex].projectRfx;
          }
        }
      }
    },
    onChangeProjectWeeklyEntry() {
      this.rfxList = [];
      this.form.rfx = undefined;
      if (this.form.project) {
        const selProject = this.projectList.find(item => item.id === this.form.project);
        if (selProject) {
          this.rfxList = selProject.rfxList;
        }
      }
    },
    onChangeProjectRfx() {
      if (this.$refs.spinner) {
        this.$refs.spinner.open();
      }
      // Keep index of weekly entry selected project. This is used to set props value to weekly entry components.

      this.selectWeeklyProject(this.form.project, this.form.mou, this.form.rfx);
      this.blankTimesheet = [];
      this.addTimeSheetRow(true);
      this.timesheet[this.weeklyProjectIndex].projectRfx = this.form.rfx;
      if (this.$refs.spinner) {
        this.$refs.spinner.close();
      }
    },
    async onChangeWeek() {
      if (this.$refs.spinner) {
        this.$refs.spinner.open();
      }
      await this.getTimeSheets(true);
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
      await vm.$store.dispatch('fetchTimesheetEntries', formData).then(() => {
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
            timesheetItem.amountBilled = obj[index].amountBilled ? obj[index].amountBilled : 0;
            vm.timesheet.push(timesheetItem);
          }
          vm.$refs.TimeCalenderWeekly.setCalendarText();
          vm.$refs.TimeCalenderBatch.setCalendarText();

          vm.$refs.billableBatchEntry.editMode = false;
          vm.$refs.nonBillableBatchEntry.editMode = false;
          vm.editMode = false;

          if (vm.form.project && vm.form.mou && weekChange) {
            if (this.activeTab === 'weekly') {
              vm.selectWeeklyProject(vm.form.project, vm.form.mou, vm.form.rfx);
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
            vm.selectWeeklyProject(vm.form.project, vm.form.mou, vm.form.rfx);
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
      await vm.$store.dispatch('fetchTimesheetById', { id: timeSheetId }).then(() => {
        const obj = vm.$store.state.timesheetById;
        // this.onChangeUser(obj.userId, true);
        this.form.userId = obj.userId;
        vm.timesheet[vm.weeklyProjectIndex].entries = obj.timesheetEntries;
        vm.timesheet[vm.weeklyProjectIndex].startDate = obj.startDate;
        vm.timesheet[vm.weeklyProjectIndex].endDate = obj.endDate;
        vm.timesheet[vm.weeklyProjectIndex].userId = obj.userId;
        vm.timesheet[vm.weeklyProjectIndex].mou = obj.mou.id;
        vm.timesheet[vm.weeklyProjectIndex].project = obj.project.id;
        vm.timesheet[vm.weeklyProjectIndex].is_locked = obj.is_locked;
        vm.timesheet[vm.weeklyProjectIndex].amountBilled = obj.amountBilled ? obj.amountBilled : 0;
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
        vm.rfxList = [];
        if (vm.form.project) {
          const selProject = vm.projectList.find(item => item.id === vm.form.project);
          if (selProject) {
            vm.rfxList = selProject.rfxList;
          }
        }
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

    async open(editMode = false, userId = null) {
      this.dialog = true;
      // this.$refs.TimeCalenderWeekly.disableWeekPicker(true);
      // this.$refs.TimeCalenderBatch.disableWeekPicker(true);
      if (this.$store.state.users.length === 0) {
        this.$refs.spinner.open();
        await this.$store.dispatch('fetchUsers');
        this.$refs.spinner.close();
      }
      this.initData();
      this.$refs.AddimeRecords.resetValidation();
      this.form.userId = this.fetchUser();
      if (this.form.userId) {
        await this.onChangeUser(userId || this.form.userId, editMode);
      } else {
        this.clearTimesheet();
      }
      this.$refs.TimeCalenderBatch.disableWeekPicker(editMode);
      this.$refs.TimeCalenderWeekly.disableWeekPicker(editMode);
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
          revenueHours: 0,
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
      timesheetItem.amountBilled = 0;
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
        Object.keys(arrData[0]).join(','),
        ...arrData.map(item => Object.values(item).join(',')),
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
        const date = new Date();
        let userName = '';
        const user = this.$store.state.users.find(item => item.id === this.form.userId);
        if (user) {
          userName = user.contact.fullName;
        }
        const fileName = `TimeMachine-${this.getDateInYYYYMMDD(date).toString()}-${userName}.csv`;
        link.setAttribute('download', fileName);
        link.click();
      }
    },
    exportTimeSheets(val1, val2) {
      if (!this.form.userId) {
        this.$refs.snackbar.displaySnackbarTop('error', 'Please select user.');
        return;
      }
      const formData = {
        userId: this.form.userId,
        startDate: val1,
        endDate: val2,
      };
      const user = this.$store.state.users.find(item => item.id === this.form.userId);
      let hourlyRate = 0;
      if (user && user.contact && user.contact.hourlyRate) {
        // eslint-disable-next-line prefer-destructuring
        hourlyRate = user.contact.hourlyRate;
      }
      let revenueRate = 0;
      if (user && user.contact && user.contact.revenueRate) {
        // eslint-disable-next-line prefer-destructuring
        revenueRate = user.contact.revenueRate;
      }
      const vm = this;
      vm.$store.dispatch('fetchTimesheetEntriesByUser', formData).then(() => {
        const timeEntries = [];
        for (let i = 0; i < vm.$store.state.timesheetEntryDatabyUser.length; i++) {
          const entries = vm.$store.state.timesheetEntryDatabyUser[i].timesheetEntries;
          const currentProject = vm.$store.state.timesheetEntryDatabyUser[i].project.projectName;
          const currentProjectRfx = vm.$store.state.timesheetEntryDatabyUser[i].projectRfx.rfxName;
          for (let j = 0; j < entries.length; j++) {
            const entry = entries[j];
            timeEntries.push({
              Project: currentProject,
              'Project Rfx': currentProjectRfx,
              Date: entry.entryDate,
              'Billable Hours': entry.hoursBillable ? entry.hoursBillable : 0,
              'Hourly Rate': hourlyRate,
              'Billable Comments': entry.commentsBillable,
              'Unbillable Hours': entry.hoursUnBillable ? entry.hoursUnBillable : 0,
              'Unbillable Comments': entry.commentsUnBillable,
              'Expense Amount': entry.expenseAmount ? entry.expenseAmount : 0,
              'Expense Category': entry.expenseCategory,
              'Expense Description': entry.expenseComment,
              'Revenue Hours': entry.revenueHours ? entry.revenueHours : 0,
              'Revenue Rate': revenueRate,
              'Revenue Description': entry.revenueComment,
              Total:
                parseFloat(entry.hoursBillable ? entry.hoursBillable : 0, 10)
                  * parseFloat(hourlyRate, 10)
                + parseFloat(entry.hoursUnBillable ? entry.hoursUnBillable : 0, 10)
                  * parseFloat(hourlyRate, 10)
                + parseFloat(entry.expenseAmount ? entry.expenseAmount : 0, 10)
                + parseFloat(entry.revenueHours ? entry.revenueHours : 0, 10)
                  * parseFloat(revenueRate, 10),
            });
          }
        }
        if (timeEntries.length) this.csvExport(timeEntries);
        else this.$refs.snackbar.displaySnackbarTop('info', 'No Records Found');
      });
    },
  },
};
</script>
