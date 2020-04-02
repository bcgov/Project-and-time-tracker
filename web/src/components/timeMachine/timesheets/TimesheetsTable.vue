<template>
  <v-card>
    <spinner ref="spinner"></spinner>
    <confirm ref="confirm"></confirm>
    <snackbar ref="snackbar"></snackbar>
    <v-toolbar v-if="title" card dense color="transparent">
      <v-toolbar-title>
        <h4>{{ title }}</h4>
      </v-toolbar-title>
    </v-toolbar>

    <v-card-title>
      <v-layout class="timesheets-toolbar" d-flex style="width: 100%;">
        <v-flex d-flex justify-start align-start>
          <v-text-field
            class="search-bar"
            v-model="search"
            append-icon="search"
            label="Search Project"
            single-line
            hide-details
          ></v-text-field>
        </v-flex>
        <timesheets-toolbar ref="timesheetstoolbar" @refresh="fetchData"></timesheets-toolbar>
      </v-layout>
    </v-card-title>
    <v-divider></v-divider>
    <v-card-text class="pa-0">
      <template>
        <v-data-table
          :headers="headers"
          :items="timesheetsList"
          hide-actions
          class="elevation-0 tm-v-datatable"
          item-key="id"
        >
          <template slot="items" slot-scope="props">
            <td class="text-xs-left">{{ props.item.startDate }}</td>
            <td class="text-xs-left">{{ props.item.user.contact.fullName }}</td>
            <!-- <td class="text-xs-left">{{ props.item.projectName}} </td> -->
            <td class="text-xs-left">{{ props.item.project.projectName }}</td>
            <!-- <td class="text-xs-left">
              $$$
            </td>-->
            <!-- <td class="text-xs-left"> legal $$$ </td> -->
            <td class="text-xs-left">{{ props.item.hoursAccured }}</td>
            <td class="text-xs-center">
              <v-tooltip top>
                <template v-slot:activator="{ on }">
                  <add-time-record ref="AddTimeRecord" @close="close"></add-time-record>
                  <v-btn flat icon color="grey" @click="editTimesheet(props.item.id)" v-on="on">
                    <v-icon>edit</v-icon>
                  </v-btn>
                </template>
                <span>Edit</span>
              </v-tooltip>

              <v-tooltip top>
                <template v-slot:activator="{ on }">
                  <v-btn flat icon color="grey" v-on="on" @click="deleteTimesheet(props.item.id)">
                    <v-icon>delete</v-icon>
                  </v-btn>
                </template>
                <span>Delete</span>
              </v-tooltip>
            </td>
          </template>
        </v-data-table>
      </template>
      <v-divider></v-divider>
    </v-card-text>
  </v-card>
</template>

<script>
import ProjectExpansionRow from './ProjectExpansionRow.vue';
import TimesheetsToolbar from './TimesheetsToolbar.vue';
import Spinner from '../common/Spinner.vue';
import Snackbar from '../common/Snackbar.vue';
import Confirm from '../common/Confirm.vue';
import AddTimeRecord from './AddTimeRecord.vue';

export default {
  components: {
    ProjectExpansionRow,
    TimesheetsToolbar,
    Spinner,
    AddTimeRecord,
    Snackbar,
    Confirm,
  },
  props: {
    title: String,
    addTimeRecord: {
      type: Function,
      default: () => {},
    },
  },
  data() {
    return {
      startDateMain: this.$store.state.timesheetsWeek.startDate,
      endDateMain: this.$store.state.timesheetsWeek.endDate,
      pagination: {
        sortBy: 'name',
        rowsPerPage: 25,
      },
      selected: [],
      dialog: false,
      search: '',
      headers: [
        {
          text: 'Date of Entry',
          value: 'startDate',
          align: 'left',
          sortable: true,
        },
        {
          text: 'Person',
          value: 'user.contact.fullName',
          align: 'left',
          sortable: true,
        },
        { text: 'Proj. Name', value: 'project.projectName', sortable: true },
        // { text: 'Budget Remaining', value: 'projectBackup', sortable: false },
        // { text: 'Legal Billing', value: 'completionDate', sortable: true },
        { text: 'Hours Accrued', value: 'dateModified', sortable: true },
        {
          text: 'Actions',
          value: 'is_archived',
          align: 'center',
          width: '145px',
          sortable: false,
        },
      ],
      timesheets: [],
      projects: [],
      expand: false,
      rfxExpand: false,
    };
  },
  computed: {
    projectsRfx() {
      return this.$store.state.projectsRfx;
    },
    timesheetsList() {
      let timeRecords = this.$store.state.userTimesheets;
      if (this.$refs.timesheetstoolbar) {
        if (this.$refs.timesheetstoolbar.selectedFilter === 'All') {
          timeRecords = this.$store.state.allTimesheets;
        }
      }

      if (this.search) {
        timeRecords = timeRecords.filter(item => item.project.projectName.toLowerCase().includes(this.search.toLowerCase()));
      }
      return timeRecords;
    },
  },
  methods: {
    fetchUser() {
      const referenceId = this.$store.state.activeUser.refId;
      const user = this.$store.state.users.find(value => value.referenceId === referenceId);
      if (user && user.id) {
        return user.id;
      }
    },
    close() {
      sessionStorage.setItem('selectedStartDate', this.startDateMain);
      sessionStorage.setItem('selectedEndDate', this.endDateMain);
      this.$store.state.timesheetsWeek.startDate = this.startDateMain;
      this.$store.state.timesheetsWeek.endDate = this.endDateMain;
      this.fetchData();
    },
    editTimesheet(value) {
      this.startDateMain = this.$store.state.timesheetsWeek.startDate;
      this.endDateMain = this.$store.state.timesheetsWeek.endDate;
      const found = this.timesheetsList.find(element => element.id === value);
      sessionStorage.setItem('selectedStartDate', found.startDate);
      sessionStorage.setItem('selectedEndDate', found.endDate);
      this.$refs.AddTimeRecord.reset();
      this.$refs.AddTimeRecord.open();
      this.$refs.AddTimeRecord.editTimeEntries(found);
    },
    getFullname(projectLeadId) {
      let projectLeadName = null;
      if (projectLeadId != null) {
        const ProjectLeadMatches = this.$store.state.users.filter(
          Type => Type.id === projectLeadId,
        );

        if (ProjectLeadMatches.length > 0) {
          projectLeadName = ProjectLeadMatches[0].contact.fullName;
        }
      }
      return projectLeadName;
    },
    async fetchData() {
      if (this.$refs.spinner) {
        this.$refs.spinner.open();
      }
      await this.$store.dispatch('fetchUserTimesheets');
      await this.$store.dispatch('fetchAllTimesheets');

      if (this.$refs.spinner) {
        this.$refs.spinner.close();
      }

      // this.$store
      //   .dispatch('fetchProjects')
      //   .then(() => {
      //     this.projects = this.$store.state.projects;
      //     this.$refs.spinner.close();
      //   });
    },
    goToProject(projectId) {
      this.$router.push({ path: `project/${projectId}` });
    },
    // async onToggleRow(props) {
    //   this.$store
    //     .dispatch('fetchProjectRfx', { id: props.item.id })
    //     .then((ret) => {
    //       props.expanded = !props.expanded;
    //       props.item.projectRfxData = ret;
    //     });
    // },
    async deleteTimesheet(id) {
      if (await this.$refs.confirm.open('danger', 'Are you sure to delete this record?')) {
        await this.$store.dispatch('deleteTimesheet', { id });
        this.$refs.snackbar.displaySnackbar('success', 'Successfully deleted the record.');
        await this.fetchData();
      }
    },
    async initalfetch() {
      await this.$store.dispatch('fetchAllProjects');// Needed in AddTimeRecord
    },
  },
  created() {
    this.initalfetch();
    this.fetchData();
  },
};
</script>

<style>
.v-datatable td .grid-input.input-hours {
  width: 4.5rem;
}

.btntoggle .v-icon {
  -webkit-transform: rotate(-180deg);
  transform: rotate(-180deg);
}
hr {
  color: lightgrey;
}
.projectname:hover {
  text-decoration: underline;
}
</style>
