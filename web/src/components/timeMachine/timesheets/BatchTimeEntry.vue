<template>
  <v-layout column justify-center>
    <v-flex>
      <v-data-table
        :headers="headers"
        :items="weekEntries"
        hide-actions
        class="elevation-0 tm-v-datatable"
      >
        <template v-slot:items="props">
          <td>
            <v-select
              :items="allProjects"
              item-text="projectName"
              item-value="id"
              v-model="props.item.projectId"
              @change="onChangeProjectWeeklyEntry(props.item.projectId)"
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
            <v-text-field type="number" single-line label="Hours" v-model="props.item.monday.hours"></v-text-field>
          </td>
          <td>
            <v-text-field
              type="number"
              single-line
              label="Hours"
              v-model="props.item.tuesday.hours"
            ></v-text-field>
          </td>
          <td>
            <v-text-field
              type="number"
              single-line
              label="Hours"
              v-model="props.item.wednesday.hours"
            ></v-text-field>
          </td>
          <td>
            <v-text-field
              type="number"
              single-line
              label="Hours"
              v-model="props.item.thursday.hours"
            ></v-text-field>
          </td>
          <td>
            <v-text-field type="number" single-line label="Hours" v-model="props.item.friday.hours"></v-text-field>
          </td>
          <td>
            <v-edit-dialog :return-value.sync="props.item.comments" lazy>
              {{ props.item.comments ? props.item.comments : "..." }}
              <template v-slot:input>
                <v-text-field v-model="props.item.comments" label="Comments" single-line></v-text-field>
              </template>
            </v-edit-dialog>
          </td>
        </template>
      </v-data-table>
    </v-flex>

    <v-flex v-if="!editMode">
      <v-btn @click="addRow">Add another entry</v-btn>
      <pre>
          <!-- {{ weekEntries }}

          {{ prepareDataForSubmission() }} -->
        </pre>
    </v-flex>
  </v-layout>
</template>
<script>
import moment from "moment";
import Spinner from "../common/Spinner";

const timesheetEntryDays = [
  "monday",
  "tuesday",
  "wednesday",
  "thursday",
  "friday"
];

export default {
  components: {
    Spinner
  },
  computed: {
    allProjects() {
      const mouProjects = this.$store.state.projects.filter(
        item => item.mou != null && item.mou !== ""
      );
      var filteredProjects = mouProjects.filter(
        item => !this.exludeProjects.includes(item.id)
      );
      return mouProjects;
    },
    selectedStartDate() {
      return this.$store.state.timesheetsWeek.startDate;
    }
  },
  data() {
    //  const form = Object.assign({}, this.$props.timeEntry);
    return {
      // form: { ...form },
      exludeProjects: [],
      flagBillUnBill: 1,
      flagBill: 0,
      flagUnBill: 0,
      projectRfx: "",
      weekData: [
        { day: "Mon", description: "", hours: 0, date: "" },
        { day: "Tue", description: "", hours: 0, date: "" },
        { day: "Wed", description: "", hours: 0, date: "" }
      ],
      valid: true,
      editMode: false,

      headers: [
        { text: "Project", value: "contact.fullName" },
        { text: "Monday", value: "contact.hourlyRate", sortable: false },
        { text: "Tuesday", value: "contact.hourlyRate", sortable: false },
        { text: "Wednesday", value: "contact.hourlyRate", sortable: false },
        { text: "Thursday", value: "contact.hourlyRate", sortable: false },
        { text: "Friday", value: "contact.hourlyRate", sortable: false },
        { text: "Comments", value: "contact.fullName", sortable: false }
      ],

      weekEntries: [this.createEmptyWeekEntry()]
      // weekEntries: this.cre
    };
  },
  watch: {
    selectedStartDate(newDate, oldDate) {
      console.log("WATCH, selected start date", {
        newDate,
        oldDate,
        calculated: this.calculateDate()
      });
    }
  },
  methods: {
    openbatchentry(value) {
      this.flagBillUnBill = value;
    },
    fetchUser() {
      const referenceId = this.$store.state.activeUser.refId;
      const user = this.$store.state.users.find(
        value => value.referenceId === referenceId
      );
      if (user && user.id) {
        return user.id;
      }
    },
    onChangeProjectWeeklyEntry(projectId) {
      this.getTimeEntries(projectId);
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
    async getTimeEntries(projectId) {
      // this.$refs.billableBatchEntry.editMode = false;
      // this.$refs.nonBillableBatchEntry.editMode = false;
      // this.editMode = false;
      const date = this.getDatePart(this.$store.state.timesheetsWeek.startDate);
      const mouProjects = this.$store.state.projects.filter(
        item => item.mou != null && item.mou !== "" && item.id == projectId
      );
      console.log("selected mou", mouProjects[0].mou.id);
      // this.clearTimeEntries();
      const formData = {
        mou: mouProjects[0].mou.id,
        project: projectId,
        projectRfx: "",
        startDate: date,
        userId: this.fetchUser()
      };
      const vm = this;
      console.log(formData);
      vm.$store.dispatch("fetchTimesheetEntries", formData).then(res => {
        // vm.initTimeEntries(vm.$store.state.timesheetEntryData);
        if (res) {
          if (this.flagBillUnBill == 1) {
            this.weekEntries[this.flagBill].monday.hours =
              res.timesheetEntries[0].hoursBillable;
            this.weekEntries[this.flagBill].tuesday.hours =
              res.timesheetEntries[1].hoursBillable;
            this.weekEntries[this.flagBill].wednesday.hours =
              res.timesheetEntries[2].hoursBillable;
            this.weekEntries[this.flagBill].thursday.hours =
              res.timesheetEntries[3].hoursBillable;
            this.weekEntries[this.flagBill].friday.hours =
              res.timesheetEntries[4].hoursBillable;
            this.flagBill = this.flagBill + 1;
          } else {
            this.weekEntries[this.flagUnBill].monday.hours =
              res.timesheetEntries[0].hoursUnBillable;
            this.weekEntries[this.flagUnBill].tuesday.hours =
              res.timesheetEntries[1].hoursUnBillable;
            this.weekEntries[this.flagUnBill].wednesday.hours =
              res.timesheetEntries[2].hoursUnBillable;
            this.weekEntries[this.flagUnBill].thursday.hours =
              res.timesheetEntries[3].hoursUnBillable;
            this.weekEntries[this.flagUnBill].friday.hours =
              res.timesheetEntries[4].hoursUnBillable;
            this.flagUnBill = this.flagUnBill + 1;
          }
        }
      });
    },
    createEmptyWeekEntry() {
      const obj = {};
      timesheetEntryDays.map(
        dayString =>
          (obj[dayString] = {
            hours: undefined
          })
      );
      return obj;
    },
    calculateDate() {
      const startDate = this.selectedStartDate;
      const sunday = moment(startDate).startOf("week");
      const monday = sunday.clone().add("1", "day");
      const tuesday = monday.clone().add("1", "day");
      const wednesday = tuesday.clone().add("1", "day");
      const thursday = wednesday.clone().add("1", "day");
      const friday = thursday.clone().add("1", "day");
      return {
        monday,
        tuesday,
        wednesday,
        thursday,
        friday
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

      const timesheets = this.weekEntries.map(weekEntry => {
        const timesheetEntry = timesheetEntryDays.map(dayString => {
          const day = weekEntry[dayString];
          return {
            // TODO - A lso need non-billable + revenue
            hours: day.hours,
            entryDate: calendarDates[dayString],
            comments: weekEntry.comments
          };
        });

        return {
          startDate: calendarDates.monday,
          endDate: calendarDates.friday,
          projectId: weekEntry.projectId,
          timesheetEntry
          // userId: TODO, is "form.userId" in AddTimeRecord.vue (this comps parent)
        };
      });

      return timesheets;
    }
  }
};
</script>
