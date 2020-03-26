<template>
  <v-layout class="timesheets-toolbar" d-flex style="width: 100%;">
    <v-flex d-flex justify-center align-start>
      <timesheets-calendar ref="WeekSelection"></timesheets-calendar>
    </v-flex>
    <v-flex d-flex justify-end>
      <add-time-record ref="AddTimeRecord" @close="close"></add-time-record>
      <v-btn class="add-timesheet-button" color="btnPrimary" dark @click="newTimeRecord"
        >+ Add Time Record</v-btn
      >
    </v-flex>
  </v-layout>
</template>

<script>
import TimesheetsCalendar from './TimesheetsCalendar.vue';
import AddTimeRecord from './AddTimeRecord.vue';

export default {
  data() {
    return {
      startDateMain: this.$store.state.timesheetsWeek.startDate,
      endDateMain: this.$store.state.timesheetsWeek.endDate,
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
  methods: {
    close() {
      sessionStorage.setItem('selectedStartDate', this.startDateMain);
      sessionStorage.setItem('selectedEndDate', this.endDateMain);
      this.$store.state.timesheetsWeek.startDate = this.startDateMain;
      this.$store.state.timesheetsWeek.endDate = this.endDateMain;
      this.$refs.WeekSelection.setCalendarText();
      this.$emit('refresh');
    },
    newTimeRecord() {
      this.startDateMain = this.$store.state.timesheetsWeek.startDate;
      this.endDateMain = this.$store.state.timesheetsWeek.endDate;
      sessionStorage.setItem('selectedStartDate', this.startDateMain);
      sessionStorage.setItem('selectedEndDate', this.endDateMain);
      this.$refs.AddTimeRecord.reset();
      this.$refs.AddTimeRecord.open();
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

.week-switcher-cal {
  margin: 0 !important;
  padding: 0;
}

.add-timesheet-button {
  width: 200px;
  flex: 0 0 200px !important;
}
</style>
