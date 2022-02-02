<template>
  <v-menu
    :close-on-content-click="false"
    :nudge-top="-15"
    :nudge-right="0"
    lazy
    transition="scale-transition"
    offset-y
    full-width
    left
    min-width="285px"
    max-width="285px"
  >
    <template v-slot:activator="{ on }">
      <v-layout column>
        <v-flex my1 justify-center>
          <div class="month-picker-container">
            <v-btn-toggle class="v-btn-toggle--selected" style="flex: 0 0 auto !important;">
              <v-btn @click="setPreviousMonth(calendarText)" flat :disabled="disabledatepicker">
                <v-icon>arrow_left</v-icon>
              </v-btn>
              <v-btn @click="toggleDatePicker" flat :disabled="disabledatepicker">
                <span style="padding-left: 1rem; padding-right: 1rem;">{{ calendarText }}</span>
              </v-btn>
              <v-btn @click="setNextMonth(calendarText)" flat :disabled="disabledatepicker">
                <v-icon>arrow_right</v-icon>
              </v-btn>
            </v-btn-toggle>
          </div>
          <div :class="`date-picker-month date-picker-wrapper ${getDatePickerClass()}`">
            <v-date-picker
              class="timesheets-date-picker"
              @input="setTimesheetsWeek"
              v-model="selectedDate"
              first-day-of-week="1"
            ></v-date-picker>
          </div>
        </v-flex>
      </v-layout>
    </template>
  </v-menu>
</template>

<script>
import { mapState } from 'vuex';
import moment from 'moment';

const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
export default {
  props: {
    title: String,
    addTimeRecord: Function,
  },
  data() {
    return {
      calendarText: this.getCalendarText(),
      selectedDate: moment().format('YYYY-MM-DD'),
      showDatePicker: false,
      disabledatepicker: false,
      calendarMonth: '',
      calendarYear: '',
    };
  },
  watch: {
    timesheetsWeek: {
      handler() {
        this.setCalendarText();
      },
    },
  },
  computed: {
    ...mapState(['timesheetsWeek']),
  },
  methods: {
    reset() {
      this.setCalendarText();
    },
    disableWeekPicker(flag = false) {
      this.disabledatepicker = flag;
    },
    emitChangedMonth() {
      const formattedMonth = (this.calendarMonth + 1).toString().padStart(2, '0');
      this.$emit('changedMonth', `${this.calendarYear}-${formattedMonth}`);
    },
    getCalendarText() {
      // eslint-disable-next-line radix
      const currentDate = new Date();
      currentDate.setMonth(currentDate.getMonth()-1);
      this.calendarMonth = currentDate.getMonth();
      this.calendarYear = currentDate.getFullYear();
      this.emitChangedMonth();
      return `${months[this.calendarMonth]} ${this.calendarYear}`;
    },
    setCalendarText() {
      this.calendarText = this.getCalendarText();
    },
    setPreviousMonth(value) {
      const yearAndMonth = value.split(' ');
      const month = yearAndMonth[0];
      // eslint-disable-next-line radix
      const year = parseInt(yearAndMonth[1]);
      const monthNumber = months.findIndex(v => v === month);
      this.calendarMonth = monthNumber === 0 ? 11 : monthNumber - 1;
      this.calendarYear = monthNumber === 0 ? year - 1 : year;
      this.hideDatePicker();
      const monthName = this.getMonthName(this.calendarMonth);
      this.calendarText = `${monthName} ${this.calendarYear}`;
      this.emitChangedMonth();
    },
    setNextMonth(value) {
      const yearAndMonth = value.split(' ');
      const month = yearAndMonth[0];
      // eslint-disable-next-line radix
      const year = parseInt(yearAndMonth[1]);
      const monthNumber = months.findIndex(v => v === month);
      this.calendarMonth = monthNumber === 11 ? 0 : monthNumber + 1;
      // eslint-disable-next-line prefer-destructuring
      // eslint-disable-next-line radix
      this.calendarYear = monthNumber === 11 ? year + 1 : year;
      this.hideDatePicker();
      const monthName = this.getMonthName(this.calendarMonth);
      this.calendarText = `${monthName} ${this.calendarYear}`;
      this.emitChangedMonth();
    },
    getMonthName(monthNum) {
      return months[monthNum];
    },
    setTimesheetsWeek(dateString, isToggle = true) {
      // Set start day to start of week, which in our case is Monday
      const startDate = moment(dateString).day(1);
      if (!startDate) {
        return 'Change Week';
      }
      dateString = dateString.slice(0, -3);
      const yearAndMonth = dateString.split('-');
      // eslint-disable-next-line radix
      const year = parseInt(yearAndMonth[0]);
      // eslint-disable-next-line radix
      const monthNumber = parseInt(yearAndMonth[1]) - 1;

      if (isToggle) {
        this.toggleDatePicker();
      }

      this.calendarMonth = monthNumber;
      this.calendarYear = year;
      this.calendarText = `${months[monthNumber]} ${year}`;
      this.emitChangedMonth();
      return this.calendarText;
    },
    toggleDatePicker() {
      this.showDatePicker = !this.showDatePicker;
    },
    hideDatePicker() {
      this.showDatePicker = false;
    },
    getDatePickerClass() {
      return this.showDatePicker ? 'date-picker-active' : '';
    },
  },
};
</script>

<style>
.month-picker-container {
  margin: 0 auto;
  width: 290px;
  margin-bottom: 8px;
  margin-top: 8px;
  display: flex;
  justify-content: center;
  align-items: flex-start;
  float: left;
}

.date-picker-wrapper:not(.date-picker-active) {
  display: none;
}

.timesheets-date-picker {
  position: absolute;
  z-index: 555;
}

.week-switcher-cal {
  margin: 0 !important;
  padding: 0;
}
.date-picker-month
{
position: absolute;
top: 60px;
left:20px;
}
.v-btn-toggle .v-btn {
  opacity: 1;
}
</style>
