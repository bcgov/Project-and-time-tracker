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
            label="Filter Projects"
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
        <v-data-table
          class="pb-3 tm-v-datatable"
          :headers="headers"
          :items="projects"
          :expand="expand"
          item-key="id"
          :pagination.sync="pagination"
          :search="search"
        >
          <v-progress-linear v-slot:progress color="blue" indeterminate></v-progress-linear>
          <template slot="items" slot-scope="props">
            <tr class="row-background-lightgrey" @click="onToggleRow(props)">
              <td>
                <span
                  @click="goToProject(props.item.id)"
                  class="projectname"
                >{{ props.item.projectName }}</span>
              </td>
              <td
                class="text-xs-left" v-if ="props.item.client.ministry"
              >{{ [props.item.client.ministry.ministryName, props.item.orgDivision].join(" ") }}</td>
              <td class="text-xs-left" v-text=" getFullname(props.item.leadUserId)"></td>
              <td class="text-xs-left">$ {{ props.item.mouAmount }}</td>
              <td class="text-xs-left">{{ props.item.completionDate | formatDate }}</td>
              <td class="text-xs-right" :class="{'btntoggle': props.expanded}">
                <v-tooltip bottom>
                  <template v-slot:activator="{ on }">
                    <v-icon v-on="on">keyboard_arrow_down</v-icon>
                  </template>
                  <span>Expand to enter time</span>
                </v-tooltip>
              </td>
            </tr>
          </template>
          <!-- Expanded rows -->
          <template v-slot:expand="props">
            <project-expansion-row :project="props.item"></project-expansion-row>
          </template>
          <!-- No data -->
          <template v-slot:no-data>
            <v-alert :value="true" color="error" icon="warning">Sorry, there is no data to display!</v-alert>
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

export default {
  components: {
    ProjectExpansionRow,
    TimesheetsToolbar,
    Spinner,
  },
  props: {
    title: String,
  },
  data() {
    return {
      pagination: {
        sortBy: 'name',
        rowsPerPage: 25,
      },
      selected: [],
      dialog: false,
      search: '',
      headers: [
        {
          text: 'Project Name',
          value: 'projectName',
          align: 'left',
          width: '280px',
          sortable: false,
        },
        {
          text: 'Client',
          value: 'client',
          width: '320px',
          sortable: false,
        },
        {
          text: 'Project Lead',
          value: 'projectLeadId',
          width: '280px',
          sortable: false,
        },
        { text: 'Budget Remaining', value: 'budgetRemaining', sortable: false },
        { text: 'Est. Completion', value: 'projectDeadline', sortable: false },
        {
          text: '',
          value: 'action',
          align: 'right',
          width: '120px',
          sortable: false,
        },
      ],
      projects: [],
      expand: false,
      rfxExpand: false,
    };
  },
  computed: {
    projectsRfx() {
      return this.$store.state.projectsRfx;
    },
  },
  methods: {
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
      this.$store
        .dispatch('fetchProjects')
        .then(() => {
          this.projects = this.$store.state.projects;
          this.$refs.spinner.close();
        });
    },
    goToProject(projectId) {
      this.$router.push({ path: `project/${projectId}` });
    },
    async onToggleRow(props) {
      this.$store
        .dispatch('fetchProjectRfx', { id: props.item.id })
        .then((ret) => {
          props.expanded = !props.expanded;
          props.item.projectRfxData = ret;
        });
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
