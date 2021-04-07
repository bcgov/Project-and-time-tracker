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
    },
    disableWeekPicker(flag = false) {
      this.disabledatepicker = flag;
    },
    getCalendarText() {
      const months = [];
      months[1] = 'Jan';
      months[2] = 'Feb';
      months[3] = 'Mar';
      months[4] = 'Apr';
      months[5] = 'May';
      months[6] = 'Jun';
      months[7] = 'Jul';
      months[8] = 'Aug';
      months[9] = 'Sep';
      months[10] = 'Oct';
      months[11] = 'Nov';
      months[12] = 'Dec';


      // eslint-disable-next-line radix
      this.calendarMonth = parseInt(new Date().getMonth()) === '0' ? 12 : parseInt(new Date().getMonth());
      this.calendarYear = new Date().getFullYear();

      this.$emit('changedMonth', `${this.calendarYear}-${this.calendarMonth}`);
      // eslint-disable-next-line radix
      return `${months[parseInt(new Date().getMonth()) === '0' ? 12 : parseInt(new Date().getMonth())]} ${new Date().getFullYear()}`;
    },
    setCalendarText() {
      this.calendarText = this.getCalendarText();
    },
    setPreviousMonth(value) {
      const months = {
        Jan: '01',
        Feb: '02',
        Mar: '03',
        Apr: '04',
        May: '05',
        Jun: '06',
        Jul: '07',
        Aug: '08',
        Sep: '09',
        Oct: '10',
        Nov: '11',
        Dec: '12',
      };
      const yearAndMonth = value.split(' ');
      // eslint-disable-next-line radix
      const monthNumber = yearAndMonth[0] === 'Jan' ? 12 : parseInt(months[yearAndMonth[0]]) - 1;
      this.calendarMonth = `0${monthNumber}`.slice(-2);
      // eslint-disable-next-line prefer-destructuring
      // eslint-disable-next-line radix
      this.calendarYear = yearAndMonth[0] === 'Jan' ? parseInt(yearAndMonth[1]) - 1 : yearAndMonth[1];
      this.hideDatePicker();
      const monthName = this.getMonthName(monthNumber);
      this.calendarText = `${monthName} ${this.calendarYear}`;
      this.$emit('changedMonth', `${this.calendarYear}-${this.calendarMonth}`);
    },
    setNextMonth(value) {
      const months = {
        Jan: '01',
        Feb: '02',
        Mar: '03',
        Apr: '04',
        May: '05',
        Jun: '06',
        Jul: '07',
        Aug: '08',
        Sep: '09',
        Oct: '10',
        Nov: '11',
        Dec: '12',
      };
      const yearAndMonth = value.split(' ');
      // eslint-disable-next-line radix
      const monthNumber = yearAndMonth[0] === 'Dec' ? 1 : parseInt(months[yearAndMonth[0]]) + 1;
      this.calendarMonth = `0${monthNumber}`.slice(-2);
      // eslint-disable-next-line prefer-destructuring
      // eslint-disable-next-line radix
      this.calendarYear = yearAndMonth[0] === 'Dec' ? parseInt(yearAndMonth[1]) + 1 : yearAndMonth[1];
      this.hideDatePicker();
      const monthName = this.getMonthName(monthNumber);
      this.calendarText = `${monthName} ${this.calendarYear}`;
      this.$emit('changedMonth', `${this.calendarYear}-${this.calendarMonth}`);
    },
    getMonthName(monthNum) {
      const months = [];
      months[1] = 'Jan';
      months[2] = 'Feb';
      months[3] = 'Mar';
      months[4] = 'Apr';
      months[5] = 'May';
      months[6] = 'Jun';
      months[7] = 'Jul';
      months[8] = 'Aug';
      months[9] = 'Sep';
      months[10] = 'Oct';
      months[11] = 'Nov';
      months[12] = 'Dec';
      return months[monthNum];
    },
    setTimesheetsWeek(dateString, isToggle = true) {
      // Set start day to start of week, which in our case is Monday
      const startDate = moment(dateString).day(1);
      dateString = dateString.slice(0, -3);
      const yearAndMonth = dateString.split('-');
      const months = [];
      months[1] = 'Jan';
      months[2] = 'Feb';
      months[3] = 'Mar';
      months[4] = 'Apr';
      months[5] = 'May';
      months[6] = 'Jun';
      months[7] = 'Jul';
      months[8] = 'Aug';
      months[9] = 'Sep';
      months[10] = 'Oct';
      months[11] = 'Nov';
      months[12] = 'Dec';

      if (!startDate) {
        return 'Change Week';
      }
      if (isToggle) {
        this.toggleDatePicker();
      }

      // eslint-disable-next-line radix
      this.calendarText = `${months[parseInt(yearAndMonth[1])]} ${yearAndMonth[0]}`;
      this.$emit('changedMonth', `${yearAndMonth[0]}-${yearAndMonth[1]}`);
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
