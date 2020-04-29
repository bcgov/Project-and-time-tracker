<template>
  <v-layout row wrap py-2>
    <snackbar ref="snackbar"></snackbar>
    <v-form id="projectBaseInfo" ref="projectBaseInfo" v-model="valid" lazy-validation>
      <v-flex xs12>
        <div class="v-form-container">
          <div class="v-form-actions">

            <v-flex md-12>
              <v-btn
                :disabled="!valid || saveProjectLoading"
                :loading="saveProjectLoading"
                color="primary"
                @click="onSave"
              >Save</v-btn>
            </v-flex>
          </div>
        </div>
      </v-flex>
      <v-flex xs12>
        <v-flex md6>
          <div class="v-form-container">

               <v-checkbox v-model="form.teamWideProject" label="This is a Teamwide Project" class="team-wide-check" @change="onTeamWideProject()"></v-checkbox>

            <v-combobox
                v-model="project.mou"
                :items="mouList"
                label='Assign or Create MOU'
                persistent-hint
                item-text='name'
                v-on:keyup.enter='createMOU'
                :search-input.sync="mouSearch">

                <template v-slot:no-data v-if='mouSearch && mouSearch.length'>
                  <v-list-tile>
                    <v-list-tile-content>
                      <v-list-tile-title>
                        No results matching "<strong>{{mouSearch}}</strong>".
                        Press <kbd>enter</kbd> to create a new one
                      </v-list-tile-title>
                    </v-list-tile-content>
                  </v-list-tile>
                </template>

              </v-combobox>
          </div>
        </v-flex>
      </v-flex>
      <v-flex md6>
        <div class="v-form-container">
          <v-text-field
            :rules="requiredRule"
            class="required"
            label="Project Name"
            v-model="form.projectName"
          ></v-text-field>
        </div>
      </v-flex>
      <v-flex md6>
        <div class="v-form-container pl-0">
          <v-menu
            v-model="menu1"
            :close-on-content-click="true"
            :nudge-right="40"
            lazy
            transition="scale-transition"
            offset-y
            full-width
            max-width="290px"
            min-width="290px"
          >
            <template v-slot:activator="{ on }">
              <v-text-field
                class="required"
                :rules="requiredRule"
                v-model="form.completionDate"
                label="Project Deadline"
                persistent-hint
                prepend-inner-icon="event"
                @blur="date = parseDate(dateFormatted)"
                v-on="on"
              ></v-text-field>
            </template>
            <v-date-picker v-model="form.completionDate" no-title @input="menu1 = false"></v-date-picker>
          </v-menu>
        </div>
      </v-flex>
      <v-flex md6>
        <div class="v-form-container">
          <!-- <v-text-field
            :rules="requiredRule"
            class="required"
            label="Ministry"
            readonly
            v-model="form.client.ministry.ministryName"
          ></v-text-field>-->
          <v-container
            fluid
            row
            wrap
            align-start
            justify-end
            fill-height
            style="padding:0px !important"
          >
             <v-flex md3> <label class="v-label theme--light" style="margin-left: 2%;">Non-Ministry</label>  </v-flex>
            <v-flex md1><v-checkbox v-model="form.client.isNonMinistry"></v-checkbox></v-flex>
           <v-flex md8> <v-text-field
              :rules="requiredRule"
              v-if="form.client.isNonMinistry"
              class="required"
              label="Non Ministry Name"
              v-model="form.client.nonMinistryName"
            ></v-text-field>
            <v-select
              :items="ministries"
              label="Ministry"
              class="required"
              :rules="requiredRule"
              v-model="form.client.ministry.id"
              v-if="!form.client.isNonMinistry"
              item-value="id"
              item-text="ministryName"
            ></v-select></v-flex>
          </v-container>
        </div>
      </v-flex>
      <v-flex md6>
        <div class="v-form-container">
          <v-text-field
            :rules="requiredRule"
            class="required"
            label="Branch"
            readonly
            v-model="form.client.orgDivision"
          ></v-text-field>
        </div>
      </v-flex>
      <v-flex md6>
        <div class="v-form-container">
          <v-text-field
            class="required"
            :rules="amountRule"
            prepend-inner-icon="attach_money"
            label="Contract Amount"
            oninput="validity.valid||(value='');"
            :value='form.contractValue | withCommas'
            @blur="v => (form.contractValue = parseFloat(v.target.value.toString().replace(/,/g, '')))"
          ></v-text-field>
        </div>
      </v-flex>
      <v-flex md6>
        <div class="v-form-container">
          <v-text-field
            :rules="mouRule"
            prepend-inner-icon="attach_money"
            label="MOU Amount"
            oninput="validity.valid||(value='');"
            :value='form.mouAmount | withCommas'
            @blur="v => (form.mouAmount = parseFloat(v.target.value.toString().replace(/,/g, '')))"
          ></v-text-field>
        </div>
      </v-flex>
      <v-flex md6>
        <div class="v-form-container">
          <v-select
            :disabled = form.teamWideProject
            :items="userList"
            :rules="requiredTeamRule"
            :class="form.teamWideProject ? '': 'required'"
            label="Project Lead"
            item-value="id"
            item-text="contact.fullName"
            v-model="form.leadUserId"
            @click.native="getProjectLead(form.leadUserId)"
          ></v-select>
        </div>
      </v-flex>
      <v-flex md6>
        <div class="v-form-container">
          <v-select
            :disabled = form.teamWideProject
            :items="userList"
            label="Project Backup"
            item-value="id"
            item-text="contact.fullName"
            v-model="form.backupUserId"
          ></v-select>
        </div>
      </v-flex>
       <v-flex md6>
        <div>
          <v-container fluid>
            <label class="v-label theme--light" style="margin-left: 4%;">Reprocurement?</label>
            <v-radio-group v-model="form.isReprocurement" row>
              <v-radio label=" Yes" :value="true" form.isReprocurement></v-radio>
              <v-radio label=" No" :value="false" form.isReprocurement></v-radio>
            </v-radio-group>
          </v-container>
        </div>
      </v-flex>
      <v-menu
        v-model="menu2"
        v-if="form.isReprocurement"
        :close-on-content-click="true"
        :nudge-right="40"
        lazy
        transition="scale-transition"
        offset-y
        full-width
        max-width="290px"
        min-width="290px"
      >
        <template v-slot:activator="{ on }">
          <v-text-field
            class="required"
            :rules="requiredRule"
            v-model="form.dateOfReprocurement"
            label="Date of Procurement"
            persistent-hint
            prepend-inner-icon="event"
            @blur="date = parseDate(dateFormatted)"
            v-on="on"
          ></v-text-field>
        </template>
        <v-date-picker v-model="form.dateOfReprocurement" no-title @input="menu2 = false"></v-date-picker>
      </v-menu>
      <v-flex xs12>
        <div class="v-form-container">
          <v-textarea
            class="required"
            name="background"
            label="Background of project"
            no-resize
            rows="4"
            :rules="requiredRule"
            v-if="form.isReprocurement"
            v-model="form.previousContractBackground"
          ></v-textarea>
        </div>
      </v-flex>
      <v-flex xs12>
        <div class="v-form-container">
          <v-textarea
            class="required"
            name="impact"
            label="Impact if Project fails"
            no-resize
            rows="4"
            :rules="requiredRule"
            v-model="form.projectFailImpact"
          ></v-textarea>
        </div>
      </v-flex>
      <v-flex xs12>
        <div class="v-form-container">
          <v-textarea
            class="required"
            name="success"
            label="Overview of success"
            no-resize
            rows="4"
            :rules="requiredRule"
            v-model="form.projectSuccess"
          ></v-textarea>
        </div>
      </v-flex>
    </v-form>
  </v-layout>
</template>

<script>
import './projectBaseInfo.styl';
import MinistryDto from '@/domain/models/Ministry.dto';
import ProjectSectorDto from '@/domain/models/ProjectSector.dto';
import ClientDto from '@/domain/models/Client.dto';

import Snackbar from '../common/Snackbar.vue';

export default {
  components: { Snackbar },
  props: {
    nextPanel: Function,
    panelName: String,
    project: Object,
    ministry: Object,
  },
  computed: {
    dateFormatted() {
      return this.formatDate(this.date);
    },
    projectSectors() {
      return this.$store.state.projectSectors;
    },
    userList() {
      return this.$store.state.users;
    },
    ministries() {
      return this.$store.state.ministries;
    },
    mouList() {
      return this.$store.state.mouList;
    },
  },
  data() {
    const form = Object.assign({}, this.$props.project);

    const inputProjectSector = form.projectSector || null;
    if (!inputProjectSector) {
      form.projectSector = new ProjectSectorDto();
    }

    const inputClient = form.client || null;
    if (!inputClient) {
      form.client = new ClientDto();
    }

    return {
      valid: true,
      requiredTeamRule: [
        (value) => {
          if ((value === undefined || value === '' || !value) && this.form && !(this.form.teamWideProject)) { return 'This field is required'; }
          return true;
        },
      ],
      requiredRule: [v => !!v || 'This field is required'],
      // Initialize using props
      form: { ...form },
      selectedLeadUser: '',
      oldLeadUserID: undefined,
      oldBackupUserID: undefined,
      menu1: false,
      menu2: false,
      ministryname: form.client.ministry
        ? form.client.ministry.id
        : form.client.nonMinistryName,
      saveProjectLoading: false,
      ministryInformation: this.$store.state.ministryInformation,
      mouSearch: null,
      amountRule: [
        (v) => {
          if (!v) return 'This field is required';
          if (v === 0 || v === '0') return 'Field cannot be zero';
          const anyNonNumbers = v.toString().match(/^[0-9,_.-]*$/g, '');
          if (!anyNonNumbers) {
            return 'Field must just be a number.';
          }
          return true;
        },
      ],
      mouRule: [
        (v) => {
          if (!v) return true;
          const anyNonNumbers = v.toString().match(/^[0-9,_.-]*$/g, '');
          if (!anyNonNumbers) {
            return 'Field must just be a number.';
          }
          return true;
        },
      ],
    };
  },
  watch: {
    valid(newVal) {
      this.$store.state.ministryInformation = newVal;
    },
    date() {
      this.dateFormatted = this.formatDate(this.date);
    },
    project(value) {
      this.form = value;

      const inputProjectSector = this.form.projectSector || null;
      if (!inputProjectSector) {
        this.form.projectSector = new ProjectSectorDto();
      }
    },
    ministry(value) {
      this.form = value;

      const inputMinistry = this.form.client.ministry || null;
      if (!inputMinistry) {
        this.form.client.ministry = new MinistryDto();
      }
    },
  },
  methods: {
    thousandSeprator(amount) {
      if (
        amount !== ''
        || amount !== undefined
        || amount !== 0
        || amount !== '0'
        || amount !== null
      ) {
        return amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
      }
      return amount;
    },
    onTeamWideProject() {
      if (this.form.teamWideProject) {
        this.oldLeadUserID = this.form.leadUserId;
        this.oldBackupUserID = this.form.backupUserId;
        this.form.leadUserId = undefined;
        this.form.backupUserId = undefined;
      } else {
        this.form.leadUserId = this.oldLeadUserID;
        this.form.backupUserId = this.oldBackupUserID;
      }
      this.$refs.projectBaseInfo.resetValidation();
    },
    formatDate(date) {
      if (!date) return null;

      const [year, month, day] = date.split('-');
      return `${month}/${day}/${year}`;
    },
    onBlurNumber(e) {
      this.visible = false;
      this.temp = this.amount;
      this.amount = this.thousandSeprator(this.amount);
    },
    onFocusText() {
      this.visible = true;
      this.amount = this.temp;
    },
    thousandSeprator(amount) {
      if (amount !== '' || amount !== undefined || amount !== 0 || amount !== '0' || amount !== null) {
        return amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
      }
      return amount;
    },
    parseDate(date) {
      if (!date) return null;

      const [month, day, year] = date.split('/');
      return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
    },
    getProjectLead(projectLeadUserId) {
      this.selectedLeadUser = projectLeadUserId;
    },
    onSave() {
      const scope = this;
      if (this.$refs.projectBaseInfo.validate()) {
        // ministry part starts
        for (let i = 0; i < this.$store.state.ministries.length; i++) {
          if (this.form.client && this.form.client.ministry && this.$store.state.ministries[i].id == this.form.client.ministry.id) {
            this.form.client.ministry.ministryName = this.$store.state.ministries[i].ministryName;
          }
        }
        if (this.form.client.isNonMinistry) {
          // this.form.client.ministry = undefined;
        } else {
          this.form.client.NonMinistryName = undefined;
        }
        this.$store.state.ministryInformation = true;

        // ministry part ends

        const projectData = Object.assign({}, this.form);
        this.saveProjectLoading = true;
        this.$store.dispatch('updateProject', projectData).then(
          () => {
            this.saveProjectLoading = false;
            // Commented out - this is just duplicating the above store.dispatch.  Why do it twice?
            // scope.$store.dispatch('updateProject', projectData);
            scope.$refs.snackbar.displaySnackbar('success', 'Updated');
            scope.$store.dispatch('fetchProjects');
          },
          (err) => {
            this.saveProjectLoading = false;
            if (
              err
              && err.response
              && err.response.data
              && err.response.data.error
            ) {
              scope.form.leadUserId = scope.selectedLeadUser;
              const { message } = err.response.data.error;
              scope.$refs.snackbar.displaySnackbar('error', message);
            } else {
              scope.form.leadUserId = scope.selectedLeadUser;
              scope.$refs.snackbar.displaySnackbar(
                'error',
                'Failed to update project.',
              );
            }
          },
        );
      }
    },
    async createMOU() {
      // TODO - Check that pre-existing MOU doesn't already exist
      if (this.project.mou === '' || this.project.mou === ' ') { return; }
      if (this.project.mou) {
        let mouItem = this.$store.state.mouList.find(item => item.name === this.project.mou);
        if (typeof mouItem === 'undefined') {
          mouItem = this.$store.state.mouList.find(item => item.name === this.project.mou.name);
          if (typeof mouItem === 'undefined') { await this.$store.dispatch('createMOU', { name: this.project.mou }); }
        }
      }
    },
    fetchData() {
      // Fetching all the users for now
      this.$store.dispatch('fetchUsers');
    },
  },
  created() {
    this.fetchData();
  },
};
</script>
