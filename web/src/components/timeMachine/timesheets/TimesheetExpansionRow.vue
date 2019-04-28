<template>
  <div>
    <v-layout>
      <v-flex>
        <div class="lane">
          <div class="lane-label">
            <span class="lane-label-text">Billable</span>
          </div>
          <div class="lane-content">
            <timesheet-entries-table
              addBillableRecordLabel="+ Add Billable"
              addNonBillableRecordLabel="+ Add Non-Billable"
              :projectRfx="selectedRfxData"
              :project="project"
              :filter="filterBillableRecords"
              :onAddNonBillableRecord="showNonBillableRecords"
              :displayAddBillableRecordButton="true"
              :displayAddNonBillableRecordButton="false"
              :selectedRfxData="selectedRfxData"
            />
          </div>
        </div>
        <div class="lane">
          <div class="lane-label dark">
            <span class="lane-label-text">Non-Billable</span>
          </div>
          <div class="lane-content">
            <timesheet-entries-table
              addBillableRecordLabel="+ Add Billable"
              addNonBillableRecordLabel="+ Add Non-Billable"
              :projectRfx="selectedRfxData"
              :project="project"
              :filter="filterNonBillableRecords"
              :displayAddNonBillableRecordButton="true"
              :displayNonBillableRecords="true"
              :selectedRfxData="selectedRfxData"
            />
          </div>
        </div>
      </v-flex>
    </v-layout>
  </div>
</template>

<script>
import TimesheetEntriesTable from './TimesheetEntriesTable.vue';

export default {
  components: {
    TimesheetEntriesTable,
  },
  props: {
    title: String,
    selectedRfxData: Object,
    project: Object,
  },
  data() {
    return {
      selected: [],
      dialog: false,
      headers: [
        { text: 'Project Name', value: 'projectName', align: 'left', sortable: true },
        { text: 'Client', value: 'client', sortable: true },
        { text: 'Project Lead', value: 'projectLeadId', sortable: true },
        { text: 'Budget Remaining', value: 'budgetRemaining', sortable: true },
        { text: 'Project Deadline', value: 'projectDeadline', sortable: true },
        { text: 'Action', value: 'action', align: 'right', sortable: false },
      ],
      expand: false,
      rfxExpand: false,
      rfxHeaders: [
        {
          text: 'RFx Type',
          value: 'rfxType',
        },
      ],
      phaseHeaders: [
        { text: 'Phase Name', value: 'phaseName' },
        { text: 'User', value: 'user' },
        { text: 'Hours', value: 'hours' },
        { text: 'M', value: 'hoursMonday' },
        { text: 'T', value: 'hoursTuesday' },
        { text: 'W', value: 'hoursWednesday' },
        { text: 'Th', value: 'hoursThursday' },
        { text: 'F', value: 'hoursFriday' },
        { text: 'S', value: 'hoursSaturday' },
        { text: 'Su', value: 'hoursSunday' },
        {
          text: 'Actions',
          value: 'action',
          align: 'right',
          sortable: false,
        },
      ],
    };
  },
  computed: {
    projects() {
      return this.$store.state.projects;
    },
    projectsRfx() {
      return this.$store.state.projectsRfx;
    },
    projectRfx() {
      return this.getProjectRfx(this.project.id);
    },
    displayNonBillableRecords() {
      return this.hasNonBillableTimesheets();
    },
  },
  methods: {
    showNonBillableRecords() {
      this.displayNonBillableRecords = true;
    },
    filterBillableRecords(item) {
      return item.isBillable !== false;
    },
    filterNonBillableRecords(item) {
      return item.isBillable === false;
    },
    fetchData() {
      this.$store.dispatch('fetchProjects');
    },
    fetchProjectRfx(project) {
      this.$store.dispatch('fetchProjectRfx', { id: project.id });
    },
    getRfxType(id) {
      const filtered = this.$store.state.rfxTypes.filter(
        type => type.id === id,
      );
      return filtered[0];
    },
    getRfxTypeName(id) {
      const type = this.getRfxType(id);
      return type.rfxTypeName;
    },
    getProjectRfx(id) {
      const projectsRfx = this.projectsRfx || undefined;

      if (projectsRfx !== undefined) {
        return this.projectsRfx.get(id);
      }

      return undefined;
    },
    /**
     * Get timesheets from Vuex store.
     */
    getTimesheets() {
      let timesheets = this.$store.state.timesheets || [];

      if (timesheets instanceof Array) {
        timesheets = timesheets.filter(
          timesheet => timesheet.project.id === this.project.id,
        );
        timesheets = typeof this.filter === 'function'
          ? timesheets.filter(this.filter)
          : timesheets;
      }

      return timesheets;
    },
    hasNonBillableTimesheets() {
      let timesheets = this.$store.state.timesheets || [];

      if (timesheets instanceof Array) {
        timesheets = timesheets.filter(
          timesheet => timesheet.project.id === this.project.id
            && timesheet.isBillable === false,
        );
      }

      return timesheets.length > 0;
    },
  },
  created() {
    this.fetchData();
  },
};
</script>

<style>
.v-datatable td .grid-input.input-hours {
  width: 4.5rem;
}

.week-switcher-cal {
  margin: 0 !important;
  padding: 0;
}

hr {
  color: lightgrey;
}
</style>
