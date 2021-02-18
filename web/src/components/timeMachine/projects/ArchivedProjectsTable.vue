<template>
  <v-card>
    <confirm ref="confirm"></confirm>
    <snackbar ref="snackbar"></snackbar>
    <v-toolbar v-if="title" card dense color="transparent">
      <v-toolbar-title>
        <h4>{{ title }}</h4>
      </v-toolbar-title>
    </v-toolbar>
    <v-divider></v-divider>
    <v-card-text class="pa-0">
      <template>
        <v-data-table
          :headers="headers"
          :items="projects"
          hide-actions
          class="elevation-0 tm-v-datatable"
          disable-initial-sort
        >
          <template slot="items" slot-scope="props">
            <td class="text-xs-left">{{ props.item.mou ? props.item.mou.name : "n/a" }}</td>
            <!-- <td class="text-xs-left">{{ props.item.mouAmount }} </td> -->
            <td v-bind:class="{ archived: props.item.is_archived }">
              {{ props.item.projectName }}
            </td>
            <!-- <td class="text-xs-left">{{ props.item.projectName }}</td> -->
            <td class="text-xs-left">
              {{ [props.item.client.ministry.ministryName, props.item.orgDivision].join(" ") }}
            </td>
            <td class="text-xs-left">
              {{ props.item.teamWideProject ? "teamWideProject" : getUserName(props.item.leadUserId) }}
            </td>
            <td class="text-xs-left">
              {{ props.item.teamWideProject ? "" : getUserName(props.item.backupUserId) }}
            </td>
            <td class="text-xs-left">{{ props.item.completionDate | formatDate }}</td>
            <td class="text-xs-left">{{ props.item.dateModified | formatDate }}</td>
            <td class="text-xs-center">
              <v-tooltip top>
                <template v-slot:activator="{ on }">
                  <v-btn flat icon color="grey" v-on="on" @click="archivePrompt(props.item, false)">
                    <v-icon>unarchive</v-icon>
                  </v-btn>
                </template>
                <span>Un-archive</span>
              </v-tooltip>
              <!--
                <v-tooltip top>
                <template v-slot:activator="{ on }">
                  <v-btn flat icon color="grey" v-on="on" @click="deleteProject(props.item.id)">
                    <v-icon >delete</v-icon>
                  </v-btn>
                </template>
                <span>Delete</span>
              </v-tooltip> -->
            </td>
          </template>
        </v-data-table>
      </template>
      <v-divider></v-divider>
    </v-card-text>
  </v-card>
</template>

<script>
import Confirm from '../common/Confirm.vue';
import Snackbar from '../common/Snackbar.vue';

export default {
  props: {
    title: String,
  },
  components: {
    Snackbar,
    Confirm,
  },
  data() {
    return {
      headers: [
        { text: 'MOU', value: 'mouAmount', align: 'left', sortable: true },
        { text: 'Project Name', value: 'projectName', align: 'left', sortable: true },
        // { text: 'Phase', value: 'rfxPhaseName', align: 'left', sortable: true },
        { text: 'Client', value: 'client.ministry.ministryName', sortable: true },
        { text: 'Project Lead', value: 'projectLeadId', sortable: false },
        { text: 'Project Backup', value: 'projectBackup', sortable: false },
        { text: 'Project Deadline', value: 'completionDate', sortable: true },
        { text: 'Last Updated', value: 'dateModified', sortable: true },
        { text: 'Actions', value: 'is_archived', align: 'center', width: '145px', sortable: false },
      ],
      archivedprojects: [],
      selectedLeadUser: '',
      selectedProjectBackup: '',
    };
  },
  computed: {
    projects() {
      return this.$store.state.archivedProjects;
    },
    userList() {
      return this.$store.state.users;
    },
  },
  methods: {
    getUserName(id) {
      if (id) {
        const value = this.$store.state.users.filter(el => el.id === id);
        return value.length>0 && value[0].contact?value[0].contact.fullName:'';
      }
      return '';
    },
    fetchArchivedData() {
      this.$store.dispatch('fetchArchivedProjects');
    },
    editProject(id) {
      this.$router.push({ path: `project/${id}` });
    },
    viewProjectTimesheets() {
      this.$router.push({ path: 'timesheets' });
    },
    getProjectLead(projectLeadUserId) {
      this.selectedLeadUser = projectLeadUserId;
    },
    getProjectBackup(projectBackupId) {
      this.selectedProjectBackup = projectBackupId;
    },

    // Vue.filter('formatDate', function(value)
    // {
    // if (value) {
    // return moment(String(value)).format('MM/DD/YYYY hh:mm')
    // }
    // },
    async deleteProject() {
      if (await this.$refs.confirm.open('danger', '')) {
        // yes
        this.$store.dispatch('fetchArchivedProjects');
        this.$refs.snackbar.displaySnackbar('success', 'Deleted.');
      }
    },
    async archivePrompt(item, archiveVal) {
      if (
        await this.$refs.confirm.open(
          'info',
          `Are you sure to un-archive project: ${item.projectName}?`,
        )
      ) {
        item.is_archived = archiveVal;
        await this.$store.dispatch('archiveProject', { id: item.id, is_archived: archiveVal });
        this.fetchArchivedData();
      }
    },
  },
  created() {
    this.fetchArchivedData();
  },
};
</script>
