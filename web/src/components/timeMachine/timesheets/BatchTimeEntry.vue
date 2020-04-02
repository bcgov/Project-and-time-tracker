<template>
  <v-layout column justify-center>
    <snackbar ref="snackbar"></snackbar>
    <v-flex>
      <v-data-table
        :headers="headers"
        :items="weekEntries"
        hide-actions
        class="elevation-0 tm-v-datatable batch-entry"
      >
        <template v-slot:items="props">
          <td>
            <v-select
              :items="allProjects"
              item-text="projectName"
              item-value="id"
              v-model="props.item.projectId"
              @change="onChangeProjectBatchEntry(props.item)"
              label="Project Name"
              :disabled="editMode"
            >
              <!-- TODO - Truncate name if Proj name too long -->
              <!-- <template v-slot:selection='{item}'>
                        {{ item.projectName }}
              </template>-->
            </v-select>
          </td>
          <td>
            <!-- TODO - Swap the below out with "hoursUnbillable" if above is selected. Maybe with a prop, "isUnbillable"?-->
            <v-text-field
              type="number"
              max="24"
              step="0.01"
              min="0"
              oninput="validity.valid||(value=0);"
              v-model="props.item.monday.hours"
            ></v-text-field>
          </td>
          <td>
            <v-text-field
              type="number"
              max="24"
              step="0.01"
              min="0"
              :rules="hoursRule"
              oninput="validity.valid||(value=0);"
              v-model="props.item.tuesday.hours"
            ></v-text-field>
          </td>
          <td>
            <v-text-field
              type="number"
              max="24"
              step="0.01"
              min="0"
              :rules="hoursRule"
              oninput="validity.valid||(value=0);"
              v-model="props.item.wednesday.hours"
            ></v-text-field>
          </td>
          <td>
            <v-text-field
              type="number"
              max="24"
              step="0.01"
              min="0"
              :rules="hoursRule"
              oninput="validity.valid||(value=0);"
              v-model="props.item.thursday.hours"
            ></v-text-field>
          </td>
          <td>
            <v-text-field
              type="number"
              max="24"
              step="0.01"
              min="0"
              :rules="hoursRule"
              oninput="validity.valid||(value=0);"
              v-model="props.item.friday.hours"
            ></v-text-field>
          </td>
          <td>
            <v-edit-dialog :return-value.sync="props.item.comments" lazy>
              {{ props.item.comments ? props.item.comments : "..." }}
              <template v-slot:input>
                <v-text-field
                  v-model="props.item.comments"
                  label="Comments"
                  single-line
                ></v-text-field>
              </template>
            </v-edit-dialog>
          </td>
        </template>
      </v-data-table>
    </v-flex>

    <v-flex v-if="!editMode">
      <v-btn class="btn-normal" @click="addRow">ADD ANOTHER ENTRY</v-btn>
      <pre>
          <!-- {{ weekEntries }} -->

          <!-- {{ prepareDataForSubmission() }} -->
        </pre>
    </v-flex>
  </v-layout>
</template>
<script>
import moment from 'moment';
import Spinner from '../common/Spinner';
import Snackbar from '../common/Snackbar';

const timesheetEntryDays = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday'];

export default {
  components: {
    Spinner,
    Snackbar,
  },
  computed: {
    allProjects() {
      if (typeof this.userId !== 'undefined') {
        const mouProjects = this.$store.state.allProjects.filter(
          item => item.mou != null && item.mou !== '' && (item.backupUserId === this.userId
|| item.leadUserId === this.userId),
        );
        return mouProjects;
      }
      return [];
    },
    selectedStartDate() {
      return this.$store.state.timesheetsWeek.startDate;
    },
  },
  data() {
    //  const form = Object.assign({}, this.$props.timeEntry);
    return {
      // form: { ...form },
      hoursRule: [v => v % 0.25 === 0 || 'Please enter in quarter hours (0.25 = 15min)'],
      exludeProjects: [],
      projectRfx: '',
      weekData: [
        { day: 'Mon', description: '', hours: 0, date: '' },
        { day: 'Tue', description: '', hours: 0, date: '' },
        { day: 'Wed', description: '', hours: 0, date: '' },
        { day: 'Thur', description: '', hours: 0, date: '' },
        { day: 'Fri', description: '', hours: 0, date: '' },
      ],
      valid: true,
      editMode: false,

      headers: [
        { text: 'Project', value: 'contact.fullName' },
        { text: 'Monday', value: 'contact.hourlyRate', sortable: false },
        { text: 'Tuesday', value: 'contact.hourlyRate', sortable: false },
        { text: 'Wednesday', value: 'contact.hourlyRate', sortable: false },
        { text: 'Thursday', value: 'contact.hourlyRate', sortable: false },
        { text: 'Friday', value: 'contact.hourlyRate', sortable: false },
        { text: 'Comments', value: 'contact.fullName', sortable: false },
      ],

      weekEntries: [this.createEmptyWeekEntry()],
      // weekEntries: this.cre
    };
  },
  props: {
    selectedItem: Number,
    userId: String,
  },

  watch: {
    selectedStartDate(newDate, oldDate) {
      console.log('WATCH, selected start date', {
        newDate,
        oldDate,
        calculated: this.calculateDate(),
      });
    },
  },
  methods: {
    fetchUser() {
      return this.userId;
    },
    onChangeProjectBatchEntry(selectedItem) {
      const selectedProjects = this.weekEntries.filter(
        item => item.projectId === selectedItem.projectId,
      );
      if (selectedProjects.length === 1) {
        this.getTimeEntries(selectedItem);
      } else {
        this.$refs.snackbar.displaySnackbar('info', 'This project is already added');
        selectedItem.projectId = '';
      }
    },
    getDatePart(date) {
      const dateValue = new Date(date);
      return this.getDateInYYYYMMDD(dateValue);
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
    async getTimeEntries(seletedRow) {
      const date = this.getDatePart(this.$store.state.timesheetsWeek.startDate);
      const mouProjects = this.allProjects(
        item => item.mou != null && item.mou !== '' && item.id == seletedRow.projectId,
      );
      const formData = {
        mou: mouProjects[0].mou.id,
        project: seletedRow.projectId,
        projectRfx: '',
        startDate: date,
        userId: this.fetchUser(),
      };
      const vm = this;
      console.log(formData);
      vm.$store.dispatch('fetchTimesheetEntries', formData).then((res) => {
        seletedRow.monday.hours = 0;
        seletedRow.tuesday.hours = 0;
        seletedRow.wednesday.hours = 0;
        seletedRow.thursday.hours = 0;
        seletedRow.friday.hours = 0;
        if (res) {
          if (vm.selectedItem === 1) {
            seletedRow.monday.hours = res.timesheetEntries[0].hoursBillable;
            seletedRow.tuesday.hours = res.timesheetEntries[1].hoursBillable;
            seletedRow.wednesday.hours = res.timesheetEntries[2].hoursBillable;
            seletedRow.thursday.hours = res.timesheetEntries[3].hoursBillable;
            seletedRow.friday.hours = res.timesheetEntries[4].hoursBillable;
          } else {
            seletedRow.monday.hours = res.timesheetEntries[0].hoursUnBillable;
            seletedRow.tuesday.hours = res.timesheetEntries[1].hoursUnBillable;
            seletedRow.wednesday.hours = res.timesheetEntries[2].hoursUnBillable;
            seletedRow.thursday.hours = res.timesheetEntries[3].hoursUnBillable;
            seletedRow.friday.hours = res.timesheetEntries[4].hoursUnBillable;
          }
        }
      });
    },
    createEmptyWeekEntry() {
      const obj = {};
      timesheetEntryDays.map(
        dayString => (obj[dayString] = {
          hours: 0,
        }),
      );
      return obj;
    },
    calculateDate() {
      const startDate = this.selectedStartDate;
      const sunday = moment(startDate).startOf('week');
      const monday = sunday.clone().add('1', 'day');
      const tuesday = monday.clone().add('1', 'day');
      const wednesday = tuesday.clone().add('1', 'day');
      const thursday = wednesday.clone().add('1', 'day');
      const friday = thursday.clone().add('1', 'day');
      return {
        monday,
        tuesday,
        wednesday,
        thursday,
        friday,
      };
    },
    addRow() {
      this.weekEntries.push(this.createEmptyWeekEntry());
    },
    prepareDataForSubmission() {
      // TODO - validate

      // GOAL: Prepare data similar to DB structure, make inserting easier.

      // create one Timesheet per row
      // create one Timesheet entry per day

      const calendarDates = this.calculateDate();

      const timesheets = this.weekEntries.map((weekEntry) => {
        const timesheetEntry = timesheetEntryDays.map((dayString) => {
          const day = weekEntry[dayString];
          return {
            // TODO - A lso need non-billable + revenue
            hours: day.hours,
            entryDate: calendarDates[dayString],
            comments: weekEntry.comments,
          };
        });

        return {
          startDate: calendarDates.monday,
          endDate: calendarDates.friday,
          projectId: weekEntry.projectId,
          timesheetEntry,
          // userId: TODO, is "form.userId" in AddTimeRecord.vue (this comps parent)
        };
      });

      return timesheets;
    },
  },
};
</script>
