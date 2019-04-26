<template>
  <v-navigation-drawer
    v-model="drawerComments"
    fixed
    right
    ma-2
    width="500"
    class="navigation-drawer-scroll"
    disable-resize-watcher
  >
    <div class="drawer-main">
      <label class="sub-header-large">Comments</label>
      <v-icon
        class="drawer-close-icon"
        color="blue darken-1"
        flat
        @click="drawerComments = false"
      >close</v-icon>

      <v-data-iterator :items="commentsList" hide-actions hide-headers>
        <template v-slot:item="props">
          <v-textarea
            name="props.item.day"
            :label="props.item.label"
            no-resize
            rows="2"
            :ref="'cmnt_'+props.index"
            v-model="props.item.comments"
          ></v-textarea>
        </template>
      </v-data-iterator>
    </div>
    <div class="drawer-buttons">
      <v-btn @click="closeCommentModal">Discard</v-btn>
      <v-btn class="add-new-row" color="btnPrimary" dark @click="saveComment">Save</v-btn>
    </div>
  </v-navigation-drawer>
</template>
<script>
import './commentsdrawer.styl';
import moment from 'moment';

export default {
  data() {
    return {
      drawerComments: false,
      commentsList: [],
      updateTimesheetFunc: undefined,
      selectedTimesheetRow: undefined,
    };
  },
  methods: {
    saveComment() {
      this.selectedTimesheetRow.entries = this.commentsList;
      this.updateTimesheetFunc(this.selectedTimesheetRow);
      this.closeCommentModal();
    },
    openComments(selectedRowPayload, updateTimesheetFunction) {
      this.drawerComments = true;
      this.prepareData(selectedRowPayload.entries);
      this.updateTimesheetFunc = updateTimesheetFunction;
      this.selectedTimesheetRow = selectedRowPayload;
    },
    prepareData(timeEntires) {
      timeEntires.forEach((entry, index) => {
        const startDate = sessionStorage.getItem('selectedStartDate');
        const nextDay = moment(startDate).add(index, 'days');

        const date = (`0${nextDay.get('date')}`).slice(-2);
        const month = nextDay.get('month');
        entry.hoursBilled = entry.hoursBilled ? entry.hoursBilled : 0;
        entry.label = `${this.dayOftheWeek(index)} : ${date}/${this.monthOfTheYear(month)}  |  Hours Logged ${entry.hoursBilled}`;
      });
      this.commentsList = timeEntires;
    },
    focusOnFirstField() {
      if (this.$refs.cmnt_0) {
        this.$refs.cmnt_0.focus();
      }
    },
    dayOftheWeek(index) {
      const daysOfWeek = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
      return daysOfWeek[index];
    },
    monthOfTheYear(index) {
      const month = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return month[index];
    },
    closeCommentModal() {
      this.drawerComments = false;
    },
  },
  updated() {
    this.focusOnFirstField();
  },
};
</script>
