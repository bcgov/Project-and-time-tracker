<template>
  <v-layout class="timesheets-toolbar" d-flex style="width: 100%;">
    <v-flex d-flex justify-center align-start>
      <timesheets-calendar></timesheets-calendar>
    </v-flex>
     <v-flex d-flex justify-end>
      <timesheet-billable ref="TimesheetBillable"></timesheet-billable>
      <v-btn
        class="add-timesheet-button"
        color="btnPrimary"
        dark
        @click="newTimeSheetBillable"
      >billable</v-btn>
    </v-flex>
     <v-flex d-flex justify-end>
      <add-expense ref="AddExpense"></add-expense>
      <v-btn
        class="add-timesheet-button"
        color="btnPrimary"
        dark
        @click="newExpenses"
      >Add Expense</v-btn>
    </v-flex>
    <v-flex d-flex justify-end>
      <add-new-time-record ref="AddNewTimeRecord"></add-new-time-record>
      <v-btn
        class="add-timesheet-button"
        color="btnPrimary"
        dark
        @click="newTimeRecord"
      >+ Add Time Record</v-btn>
    </v-flex>
  </v-layout>
</template>

<script>
import TimesheetsCalendar from './TimesheetsCalendar.vue';
import AddExpense from './AddExpense.vue';
import AddNewTimeRecord from './AddNewTimeRecord.vue';
import TimesheetBillable from './TimesheetBillable.vue';

export default {
  data() {
    return {};
  },
  components: {
    TimesheetsCalendar,
    AddNewTimeRecord,
    AddExpense,
   TimesheetBillable
  },
  props: {
    title: String,
    addTimeRecord: {
      type: Function,
      default: () => {},
    },
      AddExpense: {
      type: Function,
      default: () => {},
    },
      TimesheetBillable: {
      type: Function,
      default: () => {},
    },
  },
  methods: {
    newTimeRecord() {
      this.$refs.AddNewTimeRecord.reset();
      this.$refs.AddNewTimeRecord.open();
    },
    newExpenses() {
      console
      this.$refs.AddExpense.reset();
      this.$refs.AddExpense.open();
    },
    newTimeSheetBillable() {
      this.$refs.TimesheetBillable.reset();
      this.$refs.TimesheetBillable.open();
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
