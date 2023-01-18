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
      <v-layout column style="width: 100%;">
        <v-flex my1 justify-center>
          <div class="date-picker-container">
            <v-btn-toggle class="v-btn-toggle--selected" style="flex: 0 0 auto !important;">
              <v-btn @click="setPreviousTimesheetsWeek" flat :disabled="disabledatepicker">
                <v-icon>arrow_left</v-icon>
              </v-btn>
              <v-btn @click="toggleDatePicker" flat :disabled="disabledatepicker">
                <span style="padding-left: 1rem; padding-right: 1rem;">{{ calendarText }}</span>
              </v-btn>
              <v-btn @click="setNextTimesheetsWeek" flat :disabled="disabledatepicker">
                <v-icon>arrow_right</v-icon>
              </v-btn>
            </v-btn-toggle>
          </div>
          <div :class="`date-picker-container date-picker-wrapper ${getDatePickerClass()}`">
            <v-date-picker
              class="timesheets-date-picker"
              v-model="selectedDate"
              @input="setTimesheetsWeek"
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
    disableWeekPicker(flag = false) {
      this.disabledatepicker = flag;
    },
    getCalendarText() {
      const months = [];
      months[0] = 'Jan';
      months[1] = 'Feb';
      months[2] = 'Mar';
      months[3] = 'Apr';
      months[4] = 'May';
      months[5] = 'Jun';
      months[6] = 'Jul';
      months[7] = 'Aug';
      months[8] = 'Sep';
      months[9] = 'Oct';
      months[10] = 'Nov';
      months[11] = 'Dec';

      const startDate = moment(sessionStorage.getItem('selectedStartDate'));
      const endDate = moment(sessionStorage.getItem('selectedEndDate'));

      if (!startDate && !endDate) {
        return 'Change Week';
      }

      return `${months[startDate.get('month')]} ${startDate.get('date')} - ${
        months[endDate.get('month')]
      } ${endDate.get('date')}`;
    },
    setCalendarText() {
      this.calendarText = this.getCalendarText();
    },
    setPreviousTimesheetsWeek() {
      // Set start day to start of week, which in our case is Monday
      const startDate = moment(sessionStorage.getItem('selectedStartDate')).subtract(7, 'days');
      const endDate = moment(sessionStorage.getItem('selectedEndDate')).subtract(7, 'days');

      this.hideDatePicker();

      sessionStorage.setItem('selectedStartDate', startDate.format('YYYY-MM-DD'));
      sessionStorage.setItem('selectedEndDate', endDate.format('YYYY-MM-DD'));

      this.$store.dispatch('setTimesheetsWeek', {
        startDate: startDate.format('YYYY-MM-DD'),
        endDate: endDate.format('YYYY-MM-DD'),
      });
      this.$emit('next', moment(sessionStorage.getItem('selectedStartDate')).subtract(14, 'days'));
    },
    setNextTimesheetsWeek() {
      // Set start day to start of week, which in our case is Monday
      const startDate = moment(sessionStorage.getItem('selectedStartDate')).add(7, 'days');
      const endDate = moment(sessionStorage.getItem('selectedEndDate')).add(7, 'days');

      this.hideDatePicker();

      sessionStorage.setItem('selectedStartDate', startDate.format('YYYY-MM-DD'));
      sessionStorage.setItem('selectedEndDate', endDate.format('YYYY-MM-DD'));

      this.$store.dispatch('setTimesheetsWeek', {
        startDate: startDate.format('YYYY-MM-DD'),
        endDate: endDate.format('YYYY-MM-DD'),
      });
      this.$emit('next', moment(sessionStorage.getItem('selectedStartDate')).add(14, 'days'));
    },
    setTimesheetsWeek(dateString, isToggle = true) {
      // Set start day to start of week, which in our case is Monday
      const startDate = moment(dateString).day(1);
      const endDate = moment(dateString).day(7);

      sessionStorage.setItem('selectedStartDate', startDate.format('YYYY-MM-DD'));
      sessionStorage.setItem('selectedEndDate', endDate.format('YYYY-MM-DD'));

      if (isToggle) {
        this.toggleDatePicker();
      }

      this.$store.dispatch('setTimesheetsWeek', {
        startDate: startDate.format('YYYY-MM-DD'),
        endDate: endDate.format('YYYY-MM-DD'),
      });
      this.$emit('next');
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
  created() {
    this.setTimesheetsWeek(moment().format('YYYY-MM-DD'), false);
  },
};
</script>

<style>
.date-picker-container {
  margin: 0 auto;
  width: 290px;
  margin-bottom: 8px;
  margin-top: 8px;
  display: flex;
  justify-content: center;
  align-items: flex-start;
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

.v-btn-toggle .v-btn {
  opacity: 1;
}
</style>
