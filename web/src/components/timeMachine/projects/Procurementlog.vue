<template>
  <p>Todo</p>
  <!-- <v-layout row wrap py-2>
    <snackbar ref="snackbar"></snackbar>
    <v-form id="procurementlog" ref="procurementlog" v-model="valid" lazy-validation>
      <v-flex xs12>
        <div class="v-form-container">
          <div class="v-form-actions">
            <v-flex md-12>
              <v-btn
                :disabled="!valid || saveProjectLoading"
                :loading="saveProjectLoading"
                color="primary"
                @click="onSave"
                >Save
              </v-btn>
            </v-flex>
          </div>
        </div>
      </v-flex>
      <v-flex md6>
        <div class="v-form-container">
          <v-text-field
            :rules="requiredRule"
            class="required"
            label="What is the estimated contract annual cost estimate?"
            v-model="form.costestimate"
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
          > </v-menu>

            <template v-slot:activator="{ on }">
              <v-text-field
                class="required"
                :rules="requiredRule"
                v-model="form.completionDate"
                label="How many separate contracts are estimated for this project?">
              </v-text-field>

         <v-flex md6>
        <div class="v-form-container">
          <v-text-field
            :rules="requiredRule"
            class="required"
            label="Anticipated Procurement approach"
            readonly
            ></v-text-field>
        </div>
      </v-flex>
      <v-flex md6>
        <div class="v-form-container">
          <v-text-field
            :rules="requiredRule"
            class="required"
            label="Is this project susceptible to time delays?"
            readonly
            ></v-text-field>
        </div>
      </v-flex>
      <v-flex md6>
        <div class="v-form-container">
          <v-text-field
            class="required"
            :rules="requiredRule"
            prepend-inner-icon="attach_money"
            label="Contract Amount"
            type="number"
            oninput="validity.valid||(value='');"
            v-model="form.contractValue"
          ></v-text-field>
        </div>
      </v-flex>
      <v-flex md6>
        <div class="v-form-container">
          <v-text-field
            prepend-inner-icon="attach_money"
            label="MOU Amount"
            type="number"
            :min="0"
            step="any"
            oninput="validity.valid||(value='');"
            v-model="form.mouAmount"
          ></v-text-field>
        </div>
      </v-flex>
      <v-flex md6>
        <div class="v-form-container">
          <v-select
            :items="userList"
            :rules="requiredRule"
            class="required"
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
            :items="userList"
            label="Project Backup"
            item-value="id"
            item-text="contact.fullName"
            v-model="form.backupUserId"
          ></v-select>
        </div>
      </v-flex>

        <v-flex md6>
        <div class="v-form-container">
          <v-text-field
            name="Reprocurement?"
            label="Reprocurement?"
            no-resize
            rows="1"
            :rules="requiredRule"
            v-model="form.reprocurement"
          ></v-text-field>
        </div>
      </v-flex>
          <v-menu
            v-model="menu2"
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
                v-model="form.procurement_date"
                label="Date of Procurement"
                persistent-hint
                prepend-inner-icon="event"
                @blur="date = parseDate(dateFormatted)"
                v-on="on"
              ></v-text-field>
            </template>
            <v-date-picker v-model="form.procurement_date" no-title @input="menu2 = false"></v-date-picker>
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
            v-model="form.background"
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
            v-model="form.impact"
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
            v-model="form.success"
          ></v-textarea>
        </div>
      </v-flex>
      </v-form>
  </v-layout> -->
</template>

<script>
import './projectBaseInfo.styl';

import ProjectSectorDto from '@/domain/models/ProjectSector.dto';
import ClientDto from '@/domain/models/Client.dto';

import Snackbar from '../common/Snackbar.vue';

export default {
  components: { Snackbar },
  props: { nextPanel: Function,
    panelName: String,
    project: Object },
  computed: { computedDateFormatted() {
    return this.formatDate(this.date);
  },
  projectSectors() {
    return this.$store.state.projectSectors;
  },
  userList() {
    return this.$store.state.users;
  } },
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
      requiredRule: [v => !!v || 'This field is required'],
      // Initialize using props
      form: { ...form },
      selectedLeadUser: '',
      menu1: false,
      saveProjectLoading: false,
    };
  },
  watch: { date() {
    this.dateFormatted = this.formatDate(this.date);
  },
  project(value) {
    this.form = value;

    const inputProjectSector = this.form.projectSector || null;
    if (!inputProjectSector) {
      this.form.projectSector = new ProjectSectorDto();
    }
  } },
  methods: {
    formatDate(date) {
      if (!date) return null;

      const [year, month, day] = date.split('-');
      return `${month}/${day}/${year}`;
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
        const projectData = Object.assign({}, this.form);
        this.saveProjectLoading = true;
        this.$store.dispatch('updateProject', projectData).then(
          () => {
            this.saveProjectLoading = false;
            scope.$store.dispatch('updateProject', projectData);
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
              scope.$refs.snackbar.displaySnackbar('error', 'Failed to update project.');
            }
          },
        );
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
