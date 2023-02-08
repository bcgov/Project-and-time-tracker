<template>
  <v-layout class="timesheets-toolbar" d-flex style="width: 100%;">
    <v-flex d-flex justify-center align-start style="width: 100%;">
      <v-flex md6>
        <timesheets-calendar ref="WeekSelection" @next="onChangeWeek"></timesheets-calendar>
      </v-flex>
      <v-flex md6>
        <v-radio-group v-model="selectedFilter" row>
          <v-radio label="My Timesheets" value="Mine"></v-radio>
          <v-radio label="Everyone's Timesheets" value="All" v-if="isAdmin"></v-radio>
        </v-radio-group>
      </v-flex>
    </v-flex>
    <v-flex d-flex justify-end>
      <add-time-record ref="AddTimeRecord" @close-timesheet="closeTimesheet"></add-time-record>
      <v-btn class="add-timesheet-button" color="btnPrimary" dark @click="newTimeRecord"
        >+ Add Time Record</v-btn
      >
    </v-flex>
  </v-layout>
</template>

<script>
import TimesheetsCalendar from './TimesheetsCalendar.vue';
import AddTimeRecord from './AddTimeRecord.vue';
import { getRoles } from '../../../modules/security/init';

export default {
  data() {
    return {
      selectedFilter: 'Mine',
      startDateMain: this.$store.state.timesheetsWeek.startDate,
      endDateMain: this.$store.state.timesheetsWeek.endDate,
      isAdmin: false,
      isAddTimeOpen: false,
    };
  },
  components: {
    TimesheetsCalendar,
    AddTimeRecord,
  },
  props: {
    title: String,
    addTimeRecord: {
      type: Function,
      default: () => {},
    },
  },
  created() {
    this.setAdmin();
  },
  methods: {
    closeTimesheet(needRefresh) {
      isAddTimeOpen = false;
      if (needRefresh) {
        sessionStorage.setItem('selectedStartDate', this.$store.state.timesheetsWeek.startDate);
        sessionStorage.setItem('selectedEndDate', this.$store.state.timesheetsWeek.endDate);
        this.$refs.WeekSelection.setCalendarText();
        this.$emit('refresh');
      } else {
        sessionStorage.setItem('selectedStartDate', this.startDateMain);
        sessionStorage.setItem('selectedEndDate', this.endDateMain);
        this.$store.state.timesheetsWeek.startDate = this.startDateMain;
        this.$store.state.timesheetsWeek.endDate = this.endDateMain;
        this.$refs.WeekSelection.setCalendarText();
      }
    },
    newTimeRecord() {
      this.isAddTimeOpen = true;
      this.startDateMain = this.$store.state.timesheetsWeek.startDate;
      this.endDateMain = this.$store.state.timesheetsWeek.endDate;
      sessionStorage.setItem('selectedStartDate', this.startDateMain);
      sessionStorage.setItem('selectedEndDate', this.endDateMain);
      this.$refs.AddTimeRecord.open();
    },
    async setAdmin() {
      this.isAdmin = getRoles().includes('PSB_Admin');// this.$store.state.activeRoles && this.$store.state.activeRoles.role.includes('PSB_Admin');
    },
    async onChangeWeek() {
      if(!this.isAddTimeOpen){
        if (this.$refs.spinner) {
          this.$refs.spinner.open();
        }
        await this.$store.dispatch('fetchTimesheetsByWeek');
        if (this.$refs.spinner) {
          this.$refs.spinner.close();
        }
      }
    },
  },
};
</script>

<style>
.timesheets-toolbar > * {
  width: 33.33333%;
  flex: 1 1 33.33333%;
}

.search-bar {
  padding-right: 3rem !important;
}

.search-bar .v-input {
  margin-top: 0;
  margin-bottom: 0;
}

.add-timesheet-btn {
  width: 100px;
}

.timesheets-calendar {
  width: 130px;
  margin-top: 6px !important;
  margin-bottom: 8px !important;
  padding-top: 0 !important;
  padding-bottom: 0 !important;
}
.date-picker-container {
  margin-top: 0px;
}

.week-switcher-cal {
  margin: 0 !important;
  padding: 0;
}

.add-timesheet-button {
  margin-top: 12px;
  width: 200px;
  flex: 0 0 200px !important;
}
</style>
