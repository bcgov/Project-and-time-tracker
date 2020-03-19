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
                        label="Project Name">
                        <!-- TODO - Truncate name if Proj name too long -->
                        <!-- <template v-slot:selection='{item}'>
                        {{ item.projectName }}
                        </template> -->
                  </v-select>
              </td>
              <td>
                <!-- TODO - Swap the below out with "hoursUnbillable" if above is selected. Maybe with a prop, "isUnbillable"?-->
                <v-text-field type='number' single-line label='Hours' v-model="props.item.monday.hoursBillable"></v-text-field>
              </td>
              <td>
                <v-text-field type='number' single-line label='Hours' v-model="props.item.tuesday.hoursBillable"></v-text-field>
              </td>
              <td>
                <v-text-field type='number' single-line label='Hours' v-model="props.item.wednesday.hoursBillable"></v-text-field>
              </td>
              <td>
                <v-text-field type='number' single-line label='Hours' v-model="props.item.thursday.hoursBillable"></v-text-field>
              </td>
              <td>
                <v-text-field type='number' single-line label='Hours' v-model="props.item.friday.hoursBillable"></v-text-field>
              </td>
              <td>

                <v-edit-dialog
                  :return-value.sync="props.item.commentsBillable"
                  lazy
                >
                  {{ props.item.commentsBillable ? props.item.commentsBillable : '...' }}
                  <template
                    v-slot:input
                  >
                    <v-text-field
                      v-model="props.item.commentsBillable"
                      label="Comments"
                      single-line
                    ></v-text-field>
                  </template>
                </v-edit-dialog>
              </td>
            </template>
          </v-data-table>
  </v-flex>


    <v-flex>
        <v-btn @click='addRow'>Add another entry</v-btn>
        <pre>
          <!-- {{ weekEntries }} -->
          {{ prepareDataForSubmission() }}
        </pre>
    </v-flex>


  </v-layout>
</template>
<script>
import Spinner from '../common/Spinner';
import moment from 'moment';

const timesheetEntryDays = [
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday'
];

export default {
  components: {
    Spinner
  },
  computed: {
    allProjects() {
      return this.$store.state.projects;
    },
    selectedStartDate(){
      return this.$store.state.timesheetsWeek.startDate;
    }
  },
  data(){
    return {
      weekData: [
        { day: "Mon", description: "", hours: 0, date: "" },
          { day: "Tue", description: "", hours: 0, date: "" },
          { day: "Wed", description: "", hours: 0, date: "" },
      ],
      valid: true,

       headers: [
        { text: "Project", value: "contact.fullName" },
        { text: "Monday", value: "contact.fullName" , sortable: false},
        { text: "Tuesday", value: "contact.hourlyRate" , sortable: false},
        { text: "Wednesday", value: "contact.hourlyRate" , sortable: false},
        { text: "Thursday", value: "contact.hourlyRate" , sortable: false},
        { text: "Friday", value: "contact.hourlyRate" , sortable: false},
        { text: "Comments", value: "contact.hourlyRate", sortable: false }
      ],

      weekEntries: [
        this.createEmptyWeekEntry()
      ]
      // weekEntries: this.cre
    }
  },
  watch: {
    selectedStartDate(newDate, oldDate){
      console.log('WATCH, selected start date', {newDate, oldDate, calculated: this.calculateDate()});
    }
  },
  methods: {
    createEmptyWeekEntry(){
        const obj = {}
        timesheetEntryDays.map(dayString => obj[dayString] = {
          hoursBillable: undefined,
          hoursUnBillable: undefined,
        });
        return obj;
    },
    calculateDate(){
      const startDate = this.selectedStartDate;
      const monday = moment(startDate).startOf('week')
      const tuesday = monday.clone().add('1', 'day');
      const wednesday = tuesday.clone().add('1', 'day');
      const thursday = wednesday.clone().add('1', 'day');
      const friday = thursday.clone().add('1', 'day');
      return {
        monday,
        tuesday,
        wednesday,
        thursday,
        friday
      }
    },
    addRow(){
      this.weekEntries.push(this.createEmptyWeekEntry());
    },
    prepareDataForSubmission(){
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
            hoursBillable: day.hoursBillable,
            entryDate: calendarDates[dayString],
            commentsBillable: weekEntry.commentsBillable,
          }
        })


        return {
          startDate: calendarDates.monday,
          endDate: calendarDates.friday,
          projectId: weekEntry.projectId,
          timesheetEntry
          // userId: TODO, is "form.userId" in AddTimeRecord.vue (this comps parent)
        }

      });

      return timesheets;
    }
  }
}
</script>
