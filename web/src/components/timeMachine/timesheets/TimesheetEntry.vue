<template>
  <v-layout row justify-center>
    <v-form ref="form" v-model="valid" lazy-validation class="timesheet-entry">
      <v-container grid-list-xl>
        <v-layout row wrap class="list-header">
          <v-flex md1>Day</v-flex>
          <v-flex md2>Hours</v-flex>
          <v-flex md8>Description</v-flex>
          <v-flex md1></v-flex>
        </v-layout>
        <v-layout
          v-for="(item, index) in timesheet[projectIndex].entries"
          :key="item.entryDate"
          class="time-records"
        >
          <v-flex md1>{{ days[index] }}</v-flex>

          <v-flex md2 v-if="selectedItem == 1">
            <v-text-field
            :disabled="timesheet[projectIndex].is_locked"
              type="number"
              max="24"
              step="0.01"
              min="0"
              :rules="hoursRule"
              oninput="validity.valid||(value=0);"
              v-model="item.hoursBillable"
            ></v-text-field>
          </v-flex>
          <v-flex md2 v-else>
            <v-text-field
            :disabled="timesheet[projectIndex].is_locked"
              type="number"
              max="24"
              step="0.01"
              min="0"
              :rules="hoursRule"
              oninput="validity.valid||(value=0);"
              v-model="item.hoursUnBillable"
            ></v-text-field>
          </v-flex>
          <v-flex md8 v-if="selectedItem == 1">

              <v-text-field v-model="item.commentsBillable" :disabled="timesheet[projectIndex].is_locked"></v-text-field>
            </v-flex>
            <v-flex md8 v-else>
              <v-text-field v-model="item.commentsUnBillable" :disabled="timesheet[projectIndex].is_locked"></v-text-field>
            </v-flex>

          <v-flex md2>
            <v-tooltip top open-delay="500">
              <template v-slot:activator="{ on }">
                <v-btn flat icon @click="copyfunc(item)" v-on="on" :disabled="timesheet[projectIndex].is_locked">
                  <v-icon>file_copy</v-icon>
                </v-btn>
              </template>
              <span>Copy</span>
            </v-tooltip>

            <v-tooltip v-if="isCopy" top open-delay="500">
              <template v-slot:activator="{ on }">
                <v-btn flat icon @click="pastefunc(index)" v-on="on" :disabled="timesheet[projectIndex].is_locked">
                  <v-icon>post_add</v-icon>
                </v-btn>
              </template>
              <span>Paste</span>
            </v-tooltip>
          </v-flex>
        </v-layout>
      </v-container>
    </v-form>
  </v-layout>
</template>
<script>
import './TimesheetEntry.styl';

export default {
  computed: {},
  components: {},
  data() {
    return {
      valid: true,
      isCopy:false,
      hoursRule: [v => v % 0.25 === 0 || 'Please enter in quarter hours (0.25 = 15min)'],
    };
  },
  watch: {},
  props: {
    timesheet: Array,
    selectedItem: Number,
    days: Array,
    projectIndex: Number,
  },
  created() {},
  methods: {
    validate() {
      return this.$refs.form.validate();
    },
    stringToDate(dateString) {
      const parts = dateString.split('-');
      return new Date(parts[0], parts[1] - 1, parts[2]);
    },
    copyfunc(item) {
      this.isCopy = true;
      this.itemHours = this.selectedItem === 1 ? item.hoursBillable : item.hoursUnBillable;
      this.itemDescription = this.selectedItem === 1 ? item.commentsBillable : item.commentsUnBillable;
    },
    pastefunc(index) {
      if (this.selectedItem === 1) {
        this.timesheet[this.projectIndex].entries[index].hoursBillable = this.itemHours;
        this.timesheet[this.projectIndex].entries[index].commentsBillable = this.itemDescription;
      } else {
        this.timesheet[this.projectIndex].entries[index].hoursUnBillable = this.itemHours;
        this.timesheet[this.projectIndex].entries[index].commentsUnBillable = this.itemDescription;
      }
    },
  },
};
</script>
