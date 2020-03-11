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
          <v-select
            :items="ministries"
            label="Ministry"
            class="required"
            :rules="requiredRule"
            v-model="ministryname"
            v-if="!form.client.isNonMinistry"
            item-value="id"
            item-text="ministryName"
          ></v-select>
           <v-container fluid row wrap align-start justify-end fill-height style="padding:0px !important">
          <label class="v-label theme--light" style="margin-left: 2%;">Non-Ministry</label>
          <v-checkbox v-model="form.client.isNonMinistry"></v-checkbox>
            <v-text-field
            :rules="requiredRule"
            v-if="form.client.isNonMinistry"
            class="required"
            label="Non Ministry Name"
            v-model="form.client.nonMinistryName"
          ></v-text-field>
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
            :rules="requiredRule"
            prepend-inner-icon="attach_money"
            label="Contract Amount"
            type="number"
            :min="0"
            step="any"
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
import "./projectBaseInfo.styl";
import MinistryDto from "@/domain/models/Ministry.dto";
import ProjectSectorDto from "@/domain/models/ProjectSector.dto";
import ClientDto from "@/domain/models/Client.dto";

import Snackbar from "../common/Snackbar.vue";

export default {
  components: { Snackbar },
  props: {
    nextPanel: Function,
    panelName: String,
    project: Object,
    ministry: Object
  },
  computed: {
    computedDateFormatted() {
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
    }
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
      requiredRule: [v => !!v || "This field is required"],
      // Initialize using props
      form: { ...form },
      selectedLeadUser: "",
      menu1: false,
      menu2: false,
      ministryname:  form.client.ministry? form.client.ministry.id : form.client.nonMinistryName,
      saveProjectLoading: false,
      ministryInformation: this.$store.state.ministryInformation
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
    }
  },
  methods: {
    formatDate(date) {
      if (!date) return null;

      const [year, month, day] = date.split("-");
      return `${month}/${day}/${year}`;
    },
    parseDate(date) {
      if (!date) return null;

      const [month, day, year] = date.split("/");
      return `${year}-${month.padStart(2, "0")}-${day.padStart(2, "0")}`;
    },
    getProjectLead(projectLeadUserId) {
      this.selectedLeadUser = projectLeadUserId;
    },
    onSave() {
      const scope = this;
      if (this.$refs.projectBaseInfo.validate()) {
        // ministry part starts

         if (this.form.client.isNonMinistry) {
          this.form.client.ministry = undefined;
        } else {
          this.form.NonMinistryName = undefined;
        }
        this.$store.state.ministryInformation = true;

        // ministry part ends

        const projectData = Object.assign({}, this.form);
        this.saveProjectLoading = true;
        this.$store.dispatch("updateProject", projectData).then(
          () => {
            this.saveProjectLoading = false;
            scope.$store.dispatch("updateProject", projectData);
            scope.$refs.snackbar.displaySnackbar("success", "Updated");
            scope.$store.dispatch("fetchProjects");
          },
          err => {
            this.saveProjectLoading = false;
            if (
              err &&
              err.response &&
              err.response.data &&
              err.response.data.error
            ) {
              scope.form.leadUserId = scope.selectedLeadUser;
              const { message } = err.response.data.error;
              scope.$refs.snackbar.displaySnackbar("error", message);
            } else {
              scope.form.leadUserId = scope.selectedLeadUser;
              scope.$refs.snackbar.displaySnackbar(
                "error",
                "Failed to update project."
              );
            }
          }
        );
      }
    },
    fetchData() {
      // Fetching all the users for now
      this.$store.dispatch("fetchUsers");
    }
  },
  created() {
    this.fetchData();
  }
};
</script>
