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
            <td>{{ props.item.projectName }}</td>
            <td
              class="text-xs-left"
            >{{ [props.item.client.ministry.ministryName, props.item.orgDivision].join(" ") }}</td>
            <td class="text-xs-left table-dropdown">
              <v-select
                :items="userList"
                label="Select Project Lead"
                @click.native="getProjectLead(props.item.projectLeadUserId)"
                @change="assignLead(props.item.projectLeadUserId, props.item)"
                hide-details
                single-line
                v-model="props.item.projectLeadUserId"
                return-object
                item-value="id"
                item-text="contact.fullName"
              ></v-select>
            </td>
            <td class="text-xs-left table-dropdown">
              <v-select
                :items="userList"
                @click.native="getProjectBackup(props.item.projectBackupUserId)"
                @change="assignBackup(props.item.projectBackupUserId, props.item)"
                label="Select Project Backup"
                hide-details
                single-line
                v-model="props.item.projectBackupUserId"
                return-object
                item-value="id"
                item-text="contact.fullName"
              ></v-select>
            </td>
            <td class="text-xs-left">{{ props.item.completionDate }}</td>
            <td class="text-xs-right">
              <!-- <v-btn flat icon color="grey" @click="viewProjectTimesheets">
                <v-icon color="btnPrimary">timer</v-icon>
              </v-btn> -->
              <v-btn flat icon color="grey" @click="editProject(props.item.id)">
                <v-icon>edit</v-icon>
              </v-btn>
              <v-btn flat icon color="grey" @click="archiveProject(props.item.id)">
              <v-icon>archive</v-icon>
              </v-btn>
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
        { text: 'Project Deadline', value: 'completionDate', sortable: true },
        { text: 'Actions', value: 'action', align: 'center', width: '145px', sortable: false,
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
    archiveProject(id) {
      if(this.$refs.confirm.open('info','Do you want to archive this project?'))
      {
        //yes
        this.$store.dispatch('updateProject');
      }
    },

    viewProjectTimesheets() {
      this.$router.push({ path: 'timesheets' });
    },
    getProjectLead(projectLeadUserId) {
      this.selectedLeadUser = projectLeadUserId;
    },
    async assignLead(projectLead, project) {
      const projectId = project && project.id ? project.id : '';
      const projectName = project && project.projectName ? project.projectName : '';
      const leadName = projectLead && projectLead.contact && projectLead.contact.fullName
        ? projectLead.contact.fullName
        : '';
      const leadId = projectLead && projectLead.id ? projectLead.id : '';
      if (projectId && leadId) {
        if (
          await this.$refs.confirm.open(
            'info',
            `Are you sure to assign ${leadName} to ${projectName}?`,
          )
        ) {
          this.$store
            .dispatch('assignProjectLead', { projectId,
              userId: leadId })
            .then(() => {
              this.$refs.snackbar.displaySnackbar(
                'success',
                'Project lead succesfully assigned.',
              );
            })
            .catch((err) => {
              if (
                err
                  && err.response
                  && err.response.data
                  && err.response.data.error
                  && err.response.data.error.message
              ) {
                const { message } = err.response.data.error;
                this.$refs.snackbar.displaySnackbar('error', message);
                project.projectLeadUserId = this.selectedLeadUser;
              } else {
                this.$refs.snackbar.displaySnackbar('error', 'Unable to assign Project lead');
                project.projectLeadUserId = this.selectedLeadUser;
              }
            });
        } else {
          project.projectLeadUserId = this.selectedLeadUser;
        }
      } else {
        this.$refs.snackbar.displaySnackbar('error', 'Error.');
      }
    },
    getProjectBackup(projectBackupId) {
      this.selectedProjectBackup = projectBackupId;
    },
    async assignBackup(projectBackup, project) {
      const projectId = project && project.id ? project.id : '';
      const projectName = project && project.projectName ? project.projectName : '';
      const backupName = projectBackup && projectBackup.contact && projectBackup.contact.fullName
        ? projectBackup.contact.fullName
        : '';
      const backupId = projectBackup && projectBackup.id ? projectBackup.id : '';
      if (projectId && backupId) {
        if (
          await this.$refs.confirm.open(
            'info',
            `Are you sure to assign ${backupName} to ${projectName}?`,
          )
        ) {
          this.$store
            .dispatch('assignProjectBackup', { projectId,
              userId: backupId })
            .then(() => {
              this.$refs.snackbar.displaySnackbar(
                'success',
                'Project backup succesfully assigned.',
              );
            })
            .catch((err) => {
              if (
                err
                  && err.response
                  && err.response.data
                  && err.response.data.error
                  && err.response.data.error.message
              ) {
                const { message } = err.response.data.error;
                this.$refs.snackbar.displaySnackbar('error', message);
                project.projectBackupUserId = this.selectedProjectBackup;
              } else {
                this.$refs.snackbar.displaySnackbar('error', 'Unable to assign Project Backup');
                project.projectBackupUserId = this.selectedProjectBackup;
              }
            });
        } else {
          // cancel
          project.projectBackupUserId = this.selectedProjectBackup;
        }
      } else {
        this.$refs.snackbar.displaySnackbar('error', 'Error.');
      }
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
