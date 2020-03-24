<template>
  <v-card>
    <spinner ref="spinner"></spinner>
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
        <timesheets-toolbar></timesheets-toolbar>
      </v-layout>
    </v-card-title>
    <v-divider></v-divider>
    <v-card-text class="pa-0">
      <template>
        <!-- <v-flex xs3 md1>
              <span>Sort by</span>
            <v-select :items='["Day", "Week"]'>
            </v-select>
        </v-flex>-->

        <v-data-table
          :headers="headers"
          :items="allTimesheets"
          hide-actions
          class="elevation-0 tm-v-datatable"
          item-key="id"
        >
          <template slot="items" slot-scope="props">
            <td class="text-xs-left">{{ props.item.startDate }}</td>
            <td class="text-xs-left">{{props.item.user.contact.fullName}}</td>
            <!-- <td class="text-xs-left">{{ props.item.projectName}} </td> -->
            <td class="text-xs-left">{{ props.item.project.projectName }}</td>
            <!-- <td class="text-xs-left">
              $$$
            </td>-->
            <!-- <td class="text-xs-left"> legal $$$ </td> -->
            <td class="text-xs-left">TODO hours for</td>
            <td class="text-xs-center">
              <v-tooltip top>
                <template v-slot:activator="{ on }">
                  <add-time-record ref="AddTimeRecord"></add-time-record>
                  <v-btn flat icon color="grey" @click="editProject(props.item.id)" v-on="on">
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
import ProjectExpansionRow from "./ProjectExpansionRow.vue";
import TimesheetsToolbar from "./TimesheetsToolbar.vue";
import Spinner from "../common/Spinner.vue";
import AddTimeRecord from "./AddTimeRecord.vue";

export default {
  components: {
    ProjectExpansionRow,
    TimesheetsToolbar,
    Spinner,
    AddTimeRecord
  },
  props: {
    title: String,
    addTimeRecord: {
      type: Function,
      default: () => {}
    }
  },
  data() {
    return {
      pagination: {
        sortBy: "name",
        rowsPerPage: 25
      },
      selected: [],
      dialog: false,
      search: "",
      headers: [
        {
          text: "Date of Entry",
          value: "startDate",
          align: "left",
          sortable: true
        },
        {
          text: "Person",
          value: "user.contact.fullName",
          align: "left",
          sortable: true
        },
        { text: "Proj. Name", value: "project.projectName", sortable: true },
        // { text: 'Budget Remaining', value: 'projectBackup', sortable: false },
        // { text: 'Legal Billing', value: 'completionDate', sortable: true },
        { text: "Hours Accrued", value: "dateModified", sortable: true },
        {
          text: "Actions",
          value: "is_archived",
          align: "center",
          width: "145px",
          sortable: false
        }
      ],
      timesheets: [],
      projects: [],
      expand: false,
      rfxExpand: false
    };
  },
  computed: {
    projectsRfx() {
      return this.$store.state.projectsRfx;
    },
    allTimesheets() {
      if (this.search) {
        return this.$store.state.allTimesheets.filter(item => {
          return item.project.projectName
            .toLowerCase()
            .includes(this.search.toLowerCase());
        });
      }
      return this.$store.state.allTimesheets;
    }
  },
  methods: {
    editProject(value) {
      console.log(value);
      console.log("complete list:", this.$store.state.allTimesheets);
      const found = this.$store.state.allTimesheets.find(
        element => element.id == value
      );
      console.log("result:", found);
      sessionStorage.setItem("selectedStartDate", found.startDate);
      sessionStorage.setItem("selectedEndDate", found.endDate);
      this.$refs.AddTimeRecord.getTimeEntriesById(found);
      this.$refs.AddTimeRecord.open();
    },
    getFullname(projectLeadId) {
      let projectLeadName = null;
      if (projectLeadId != null) {
        const ProjectLeadMatches = this.$store.state.users.filter(
          Type => Type.id === projectLeadId
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
      let timesheets = await this.$store.dispatch("fetchAllTimesheets");
      await this.$store.dispatch("fetchProjects"); // Needed in AddTimeRecord
      console.log("gottimesheets", { timesheets });
      this.$refs.spinner.close();

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
      // TODO - Confirm popup
      await this.$store.dispatch("deleteTimesheet", { id });
      await this.fetchData();
      // TODO - Show notification (snackbar?) to user.
    }
  },
  created() {
    this.fetchData();
  }
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
