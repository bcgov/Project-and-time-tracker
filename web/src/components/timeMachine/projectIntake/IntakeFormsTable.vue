<template>
  <v-card>
    <snackbar ref="snackbar"></snackbar>
    <confirm ref="confirm"></confirm>
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
          :items="intakeRequests"
          hide-actions
          class="elevation-0 tm-v-datatable"
          disable-initial-sort
        >
          <template slot="items" slot-scope="props">
            <td class='pl-3'>
              <v-btn v-if='!props.item.mouName'  color="btnPrimary"
                class="white--text intake-table-approve-btn ma-0"
                @click.native='showMOUModal(props.item)'>
                  ASSIGN MOU
               </v-btn>
               <span v-else @click='showMOUModal(props.item)'>{{ props.item.mouName }}</span>
            </td>
            <td>{{ props.item.projectName }}</td>
            <td
              class="text-xs-left"
            >{{ [props.item.ministryName|| props.item.nonMinistryName, props.item.orgDivision].join(" ") }}</td>
            <td class="text-xs-left table-dropdown">
              <!-- TODO: is below v-if necessary on v-select?

              ARC - v-if is because you need to approve before you can assign
              Question - Why can't we show the users name properly? Name exists on contact? what?

               -->
              <v-select
                v-if="props.item.status !== 'submitted'"
                :items="userList"
                label="Select Project Lead"
                @click.native="getProjectLead(props.item.projectLeadId)"
                @change="assignLead(props.item.projectLeadId, props.item)"
                hide-details
                single-line
                v-model="props.item.projectLeadId"
                return-object
                item-value="id"
                item-text="contact.fullName"
              ></v-select>
            </td>
            <td class="text-xs-left table-dropdown">
              <v-select
                v-if="props.item.status !== 'submitted'"
                :items="userList"
                @click.native="getProjectBackup(props.item.projectBackupId)"
                @change="assignBackup(props.item.projectBackupId, props.item)"
                label="Select Project Backup"
                hide-details
                single-line
                v-model="props.item.projectBackupId"
                return-object
                item-value="id"
                item-text="contact.fullName"
              ></v-select>
            </td>
            <td class="text-xs-left">{{ props.item.estimatedCompletionDate | formatDate }}</td>
            <td class="text-xs-center">
              <div v-if="(props.item.status === 'approved')" class="approved-label caption">Approved</div>
              <v-btn
                small
                v-if="(props.item.status === 'submitted')"
                color="btnPrimary"
                class="white--text intake-table-approve-btn ma-0"
                @click="approveRequest(props.item.id)"
              >APPROVE</v-btn>
            </td>
            <td class="text-xs-center">
              <v-btn flat icon color="grey" @click="viewRequest(props.item.id)">
                <v-icon>visibility</v-icon>
              </v-btn>
              <v-btn flat icon color="grey" @click="deleteRequest(props.item.id)">
                <v-icon>delete</v-icon>
              </v-btn>
            </td>
          </template>
        </v-data-table>
        <v-dialog v-if="dialog" v-model="dialog" width="800" margin-top="91px">
          <v-card>
            <v-card-text>
              <v-icon
                class="v-model-close-icon"
                color="blue darken-1"
                flat
                @click="dialog = false"
              >close</v-icon>
              <intake-form-view :id="id"></intake-form-view>
            </v-card-text>
          </v-card>
        </v-dialog>
      </template>
      <v-divider></v-divider>
    </v-card-text>

  <v-dialog v-model="mouDialog" persistent max-width="600px">
      <v-card>
        <v-card-title>
          <span class="headline">Assign or Create</span>
        </v-card-title>
        <v-card-text>
          <v-container grid-list-md>
            <v-layout wrap>
              <v-flex xs12>
                Project: {{ mouProjectName }}

                <v-select
                  v-model="mou"
                  :items="mouList"
                  item-text='name'
                  item-value='name'
                  label="Assign MOU"
                  ref="mouCombobox"
                  v-if="!isNewMOU"
                ></v-select>
                <v-text-field
                  v-model="mou"
                  item-text='name'
                  label="New MOU"
                  ref="mouCombobox"
                  v-else
                ></v-text-field>

                <v-checkbox v-model='isNewMOU'
                            :label="`${isNewMOU ? 'Create' : 'Assign'} MOU`"
                 ></v-checkbox>
              </v-flex>
               <v-flex xs12>
              </v-flex>
            </v-layout>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" flat @click="mouDialog = false">Close</v-btn>
          <v-btn color="blue darken-1" flat
           @click="assignMOU()">Save</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>


  </v-card>
 </template>

<script>
import Vue from 'vue';
import './intakeformtable.styl';
import IntakeFormView from './IntakeFormView.vue';
import Snackbar from '../common/Snackbar.vue';
import Confirm from '../common/Confirm.vue';

export default {
  props: {
    title: String,
  },
  components: {
    Snackbar,
    Confirm,
    IntakeFormView,
  },

  data() {
    return {
      headers: [
        { text: 'MOU', value: 'mou', align: 'left', sortable: true },
        { text: 'Project Name', value: 'projectName', align: 'left', sortable: true },
        { text: 'Client', value: 'ministryName', sortable: true },
        { text: 'Project Lead', value: 'projectLeadId', sortable: false },
        { text: 'Project Backup', value: 'projectBackup', sortable: false },
        { text: 'Project Deadline', value: 'estimatedCompletionDate', sortable: true },
        { text: 'Status', value: 'approved', align: 'center', sortable: false },
        { text: 'Action', value: 'action', align: 'right', width: '110px', sortable: false },
      ],
      selectedLeadUser: '',
      selectedProjectBackup: '',
      pagination: {
        sortBy: 'name',
      },
      dialog: false,
      mouDialog: false,
      id: '',
      mouProjectName: '',
      mou: '',
      isNewMOU: false,
    };
  },
  computed: {
    intakeRequests() {
      // console.log('intakeRequests', this.$store.state.intakeRequests);
      return this.$store.state.intakeRequests;
    },
    userList() {
      console.log('userList called', this.$store.state.users);
      // ARC - UserList doesn't seem to come back with names? What?
      // potentially issue is 'contact' is null. How to get it non-null?
      return this.$store.state.users;
    },
    mouList(){
      return this.$store.state.mouList;
    }
  },
  methods: {
    fetchData() {
      this.$store.dispatch('fetchIntakeRequests');
      this.$store.dispatch('fetchMOUs');
    },
    viewRequest(intakeId) {
      this.id = intakeId;
      this.dialog = true;
    },
    async approveRequest(id) {
      if (
        await this.$refs.confirm.open(
          'info',
          'Are you sure to approve this request?',
        )
      ) {
        this.$store.dispatch('approveIntakeRequest', { id }).then(() => {
          this.$store.dispatch('fetchIntakeRequests');
          this.$refs.snackbar.displaySnackbar('success', 'Request Approved.');
        });
      }
    },
    getProjectLead(projectLeadUserId) {
      this.selectedLeadUser = projectLeadUserId;
    },
    async assignLead(projectLead, project) {
      const projectId = project && project.projectId ? project.projectId : '';
      const projectName = project && project.projectName ? project.projectName : '';
      const leadName = projectLead && projectLead.contact && projectLead.contact.fullName ? projectLead.contact.fullName : '';
      const leadId = projectLead && projectLead.id ? projectLead.id : '';
      if (projectId && leadId) {
        if (
          await this.$refs.confirm.open(
            'info',
            `Are you sure to assign ${leadName} to ${projectName}?`,
          )
        ) {
          this.$store
            .dispatch('assignProjectLead', {
              projectId,
              userId: leadId,
            })
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
                project.projectLeadId = this.selectedLeadUser;
              } else {
                project.projectLeadId = this.selectedLeadUser;
                this.$refs.snackbar.displaySnackbar(
                  'error',
                  'Unable to assign Project Lead',
                );
              }
            });
        } else {
          project.projectLeadId = this.selectedLeadUser;
        }
      } else {
        this.$refs.snackbar.displaySnackbar(
          'error',
          'Unable to assign Project Lead',
        );
      }
    },
    getProjectBackup(projectBackupId) {
      this.selectedProjectBackup = projectBackupId;
    },
    async assignBackup(projectBackup, project) {
      const projectId = project && project.projectId ? project.projectId : '';
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
            .dispatch('assignProjectBackup', {
              projectId,
              userId: backupId,
            })
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
                project.projectBackupId = this.selectedProjectBackup;
              } else {
                project.projectBackupId = this.selectedProjectBackup;
                this.$refs.snackbar.displaySnackbar(
                  'error',
                  'Unable to assign Project Backup',
                );
              }
            });
        } else {
          project.projectBackupId = this.selectedProjectBackup;
        }
      } else {
        this.$refs.snackbar.displaySnackbar(
          'error',
          'Unable to assign Project Backup',
        );
      }
    },
    async deleteRequest(id) {
      if (await this.$refs.confirm.open('danger', '')) {
        this.$store.dispatch('deleteIntakeRequest', { id });
        this.$refs.snackbar.displaySnackbar('success', 'Deleted.');
        this.$router.push({ path: 'intake-requests' });
      }
    },
    showMOUModal(item) {
      this.mouProjectName = item.projectName;
      this.mouProjectId = item.id;
      this.mouProject = item;

      if (item.mouName){
        console.log('has mou!', item);
        this.mou = {id: item.mouId, name: item.mouName};
      }

      this.mouDialog = true;
    },
    async assignMOU(){
      // We have to use blur/nextTick in order to force the combobox to update it's value
      // This only happens if user goes from focusing on combobox to directly clicking 'Save'
      this.$refs.mouCombobox.blur();
      this.$nextTick(async () => {

        if (!this.mou || this.mou === '') return;
        console.log('assignMOU', {project: this.mouProject, mou: this.mou})
        let mouID = this.mou.id;

        // Create MOU if does not exist.
        if (!mouID && this.mou){
          console.log('creating mou', {mouID, mou: this.mou})
          mouID = await this.$store.dispatch('createMOU', {name: this.mou});
        }

        const project = this.mouProject;
        project.mou = {id: mouID, name: this.mou}
        const projResponse = await this.$store.dispatch('updateIntakeRequest', project);
        // console.log('assignMOU projResponse', {projResponse});

        this.fetchData();
        this.mouDialog = false;
        // Clear modal for next time
        this.mou = undefined;
      })
    },
    toggleNewMou(event){
      console.log('toggle called');
      // this.isNewMOU = !this.isNewMOU;
      this.mou = undefined;
    }
  },
  created() {
    this.fetchData();
  },
};
</script>
