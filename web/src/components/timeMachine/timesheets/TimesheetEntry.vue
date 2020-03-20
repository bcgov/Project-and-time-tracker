<template>
  <v-layout row justify-center>
    <snackbar ref="snackbar"></snackbar>

    <v-form ref="form" v-model="valid" lazy-validation class="timesheet-entry">
      <spinner ref="spinner"></spinner>
      <!-- {{formatDate($store.state.timesheetsWeek.startDate)}} -->
      <v-container grid-list-xl>
        <v-layout row wrap>
          <v-flex md1>Day</v-flex>
          <v-flex md2>Hours</v-flex>

          <v-flex md8>Description</v-flex>
          <v-flex md1></v-flex>
        </v-layout>

        <v-layout v-for="(item, index) in weekData" :key="item.day" class="time-records">
          <v-flex md1>{{ item.day }}</v-flex>
          <v-flex md2>
            <v-text-field
              type="number"
              max="24"
              step="0.1"
              min="0"
              oninput="validity.valid||(value=0);"
              v-model="item.hours"
            ></v-text-field>
          </v-flex>

          <v-flex md8>
            <v-text-field v-model="item.description"></v-text-field>
          </v-flex>
          <v-flex md2>
            <v-tooltip top open-delay="500">
              <template v-slot:activator="{ on }">
                <v-btn flat icon @click="copyfunc(item.hours, item.description)" v-on="on">
                  <v-icon>file_copy</v-icon>
                </v-btn>
              </template>
              <span>Copy</span>
            </v-tooltip>

            <v-tooltip top open-delay="500">
              <template v-slot:activator="{ on }">
                <v-btn flat icon @click="pastefunc(index)" v-on="on">
                  <v-icon>post_add</v-icon>
                </v-btn>
              </template>
              <span>Paste</span>
            </v-tooltip>

            <!-- <i class="material-icons mouseover" @click="yoursFunc()">file_copy</i> -->
            <!-- <i class="material-icons mouseover" @click="yoursFunc()">post_add</i> -->
          </v-flex>
        </v-layout>
      </v-container>
    </v-form>
  </v-layout>
</template>
<script>
import TimesheetEntryDto from '@/domain/models/TimesheetEntry.dto';
import RFxDto from '@/domain/models/RFx.dto';
import RFxPhaseDto from '@/domain/models/RFxPhase.dto';
import ProjectDto from '@/domain/models/Project.dto';

import merge from 'object-merge';
import './TimesheetEntry.styl';
import moment from 'moment';
import Snackbar from '../common/Snackbar.vue';
import Spinner from '../common/Spinner.vue';

export default {
  computed: {
    computedDateFormatted() {
      return this.formatDate(this.date);
    },
    userList() {
      return this.$store.state.users;
    },
    rfxPhases() {
      return this.$store.state.rfxPhases;
    },
    rfxTypes() {
      return this.$store.state.activeProjectRfxData;
    },
    projects() {
      return this.$store.state.projects;
    },
  },
  components: {
    Snackbar,
    Spinner,
  },
  data() {
    const form = Object.assign({}, this.$props.timeEntry);
    // let itemHours ='';
    // let itemDescription = '';
    if (!form.date) {
      form.date = moment().format('YYYY-MM-DD');
    }
    console.log('Timesheet entry data, singlerow?', this.singleRow);
    return {
      valid: true,
      requiredRule: [v => !!v || 'This field required'],
      requireRadioButtondRule: [v => ((v || !v) && v != null) || 'This field required'],
      dialog: false,
      menu1: false,
      form: { ...form },
      dateFormatted: undefined,
      existingTimeEntries: [],
      addRecordLoading: false,
      itemHours: '',
      itemDescription: '',
      weekDates: [],
      startDate: sessionStorage.getItem('selectedStartDate'),
      weekData: this.singleRow
        ? [{ day: 'Day', description: '', hours: 0, date: '' }]
        : [
          { day: 'Mon', description: '', hours: 0, date: '' },
          { day: 'Tue', description: '', hours: 0, date: '' },
          { day: 'Wed', description: '', hours: 0, date: '' },
          { day: 'Thu', description: '', hours: 0, date: '' },
          { day: 'Fri', description: '', hours: 0, date: '' },
          { day: 'Sat', description: '', hours: 0, date: '' },
          { day: 'Sun', description: '', hours: 0, date: '' },
        ],
    };
  },
  watch: {
    date() {
      this.dateFormatted = this.formatDate(this.date);
    },
    project(val) {
      this.$store.dispatch('fetchProjectRfx', { id: val });
    },
  },
  props: {
    timeEntry: Object,
    billableDetails: Object,
    nonBillableDetails: Object,
    singleRow: Boolean,
    AddExpense: {
      type: Function,
      default: () => {},
    },
    TimesheetEntry: {
      type: Function,
      default: () => {},
    },
  },
  created() {
    this.form.date = moment().format('YYYY-MM-DD');

    const referenceId = JSON.parse(localStorage.getItem('keycloak_user')).sub;
    const user = this.$store.state.users.find(value => value.referenceId === referenceId);
    if (user && user.id) {
      this.form.userId = user.id;
    }
    // setTimeout(() => {
    //   document.getElementsByClassName(
    //     'v-dialog v-dialog--active',
    //   )[0].scrollTop = 0;
    // }, 400);
  },
  methods: {
    formatDate(date) {
      date = new Date(date);
      const dates = [];
      for (let I = 0; I < Math.abs(-7); I++) {
        const d = new Date(
          new Date(date - (-7 >= 0 ? I : I - I - I) * 24 * 60 * 60 * 1000).toLocaleString(),
        );
        let month = `${d.getMonth() + 1}`;
        let day = `${d.getDate()}`;
        const year = d.getFullYear();

        if (month.length < 2) month = `0${month}`;
        if (day.length < 2) day = `0${day}`;
        dates.push([year, month, day].join('-'));
      }
      this.weekDates = dates;
      return dates;
    },
    onBillableclick() {
      this.formatDate(this.$store.state.timesheetsWeek.startDate);
      this.weekData[0].date = this.weekDates[0];
      this.weekData[1].date = this.weekDates[1];
      this.weekData[2].date = this.weekDates[2];
      this.weekData[3].date = this.weekDates[3];
      this.weekData[4].date = this.weekDates[4];
      this.weekData[5].date = this.weekDates[5];
      this.weekData[6].date = this.weekDates[6];
      console.log(this.weekData);
      // this.$store.state.billableDetails = this.weekData;
      return this.weekData;
    },
    nonBillableclick() {
      this.formatDate(this.$store.state.timesheetsWeek.startDate);
      this.weekData[0].date = this.weekDates[0];
      this.weekData[1].date = this.weekDates[1];
      this.weekData[2].date = this.weekDates[2];
      this.weekData[3].date = this.weekDates[3];
      this.weekData[4].date = this.weekDates[4];
      this.weekData[5].date = this.weekDates[5];
      this.weekData[6].date = this.weekDates[6];
      // this.$store.state.billableDetails = this.weekData;
      console.log(this.weekData);
      return this.weekData;
    },
    copyfunc(hours, description) {
      this.itemHours = hours;
      this.itemDescription = description;
    },
    pastefunc(index) {
      console.log('index:', index);
      this.weekData[index].hours = this.itemHours;
      this.weekData[index].description = this.itemDescription;
    },
    reset() {
      // this.$refs.form.resetValidation();
      const data = this.initData();
      this.$data.valid = data.valid;
      this.$data.requiredRule = data.requiredRule;
      this.$data.requireRadioButtondRule = data.requireRadioButtondRule;
      this.$data.dialog = data.dialog;
      this.$data.menu1 = data.menu1;
      this.$data.form = data.form;
      this.$data.dateFormatted = data.dateFormatted;
      this.$data.existingTimeEntries = data.existingTimeEntries;
    },

    saveNewRow() {
      if (this.$refs.form.validate()) {
        const formData = this.form;
        formData.hour = parseFloat(formData.hour.toFixed(2));
        const payload = this.timesheetUpdatePayload(formData);
        // this.updateTimesheet(payload);
      } else {
        this.dialog = true;
      }
    },
    handleMultipleErrors(errorList) {
      this.$refs.snackbar.displayMultipleErrorSnackbar('error', errorList);
    },
  },
};
</script>
