<template>
  <v-card>
    <confirm ref="confirm"></confirm>
    <snackbar ref="snackbar"></snackbar>
    <v-toolbar v-if="title" card dense color="transparent">
      <v-toolbar-title>
        <h4>{{title}}</h4>
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
            <td>{{ props.item.projectName }}</td>
            <td
              class="text-xs-left"
            >{{props.item.client.ministry.ministryName}}</td>
            <td class="text-xs-left">
              {{props.item.leadUserId}}</td>
              <!-- {{ [props.item.projectLeadUserId,props.user.contact.FirstName].join(" ") }}</td> -->
            <td class="text-xs-left">
              {{props.item.projectBackupUserId}}</td>
            <td class="text-xs-left">{{props.item.completionDate}}</td>
            <td class="text-xs-right">
              <v-btn flat icon color="grey" @click="deleteProject(props.item.id)">
                <v-icon>delete</v-icon>
              </v-btn>
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
        { text: 'Project Name', value: 'projectName', align: 'left', sortable: true },
        { text: 'Client', value: 'client.ministry.ministryName', sortable: true },
        { text: 'Project Lead', value: 'projectLeadId', sortable: false },
        { text: 'Project Backup', value: 'projectBackup', sortable: false },
        { text: 'Project Completed', value: 'completionDate', sortable: true },
        { text: 'Actions', value: 'action', align: 'right', width: '145px', sortable: false,
        },
      ],
      selectedLeadUser: '',
      selectedProjectBackup: '',
    };
  },
  computed: {
    projects() {
      return this.$store.state.projects;
    },
    userList() {
      return this.$store.state.users;
    },
  },
  methods: {
    fetchData() {
      this.$store.dispatch('fetchProjects');
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
    
    async deleteProject() {
      if (await this.$refs.confirm.open('danger', '')) {
        // yes
        this.$store.dispatch('fetchProjects');
        this.$refs.snackbar.displaySnackbar('success', 'Deleted.');
      }
    },
  },
  created() {
    this.fetchData();
  },
};
</script>
