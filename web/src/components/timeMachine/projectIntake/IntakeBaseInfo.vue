<template>
  <v-layout row wrap py-2 class="custom-project-base-layout">
    <v-form id="intake-base-info" ref="intakeBaseInfo" v-model="valid" lazy-validation>
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
        <div class="v-form-container">
          <v-select
            :items="projectSectors"
            :rules="requiredRule"
            class="required"
            label="Project Sector"
            v-model="form.projectSector.id"
            item-value="id"
            item-text="projectSectorName"
          ></v-select>
        </div>
      </v-flex>

      <v-flex md6>
        <div class="v-form-container">
          <v-select
            :items="projectIntakeService"
            :rules="requiredRule"
            class="required"
            label="Service"
            v-model="form.projectIntakeServices.id"
            item-value="id"
            item-text="ProjectIntakeServiceName"
          ></v-select>
        </div>
      </v-flex>
      <v-flex md6>
        <div class="v-form-container pl-0">
          <v-menu
            v-model="menu1"
            :close-on-content-click="false"
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
                readonly
                :rules="requiredRule"
                v-model="form.estimatedCompletionDate"
                label="Desired Completion Date"
                persistent-hint
                prepend-inner-icon="event"
                @blur="date = parseDate(dateFormatted)"
                v-on="on"
              ></v-text-field>
            </template>
            <v-date-picker
              v-model="form.estimatedCompletionDate"
              no-title
              @input="menu1 = false"
              :min="new Date().toISOString()"
            ></v-date-picker>
          </v-menu>
        </div>
      </v-flex>
      <v-flex md6>
        <div class="v-form-container">
          <v-select
            :items="projectIntakeCategories"
            :rules="requiredRule"
            class="required"
            label="Category"
            v-model="form.projectIntakeCategory.id"
            item-value="id"
            item-text="projectIntakeCategoryName"
          ></v-select>
        </div>
      </v-flex>
      <v-flex md6>
        <div class="v-form-container">
          <v-text-field label="Commodity Code" v-model="form.commodityCode"></v-text-field>
        </div>
      </v-flex>
      <v-flex md6>
        <div class="v-form-container">
          <v-text-field
            class="required"
            :rules="requiredRule"
            prepend-inner-icon="attach_money"
            label="Estimated Budget"
            type="number"
            :min="0"
            step="any"
            oninput="validity.valid||(value='');"
            v-model="form.estimatedContractValue"
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
        <div>
          <v-container fluid>
            <label class="v-label theme--light" style="margin-left: 4%;">Reprocurement?</label>
            <v-radio-group v-model="chkReprocurement" row>
              <v-radio label="Yes" :value="true"></v-radio>
              <v-radio label="No" :value="false"></v-radio>
            </v-radio-group>
          </v-container>
        </div>
      </v-flex>
      <v-flex md6>
        <div class="v-form-container pl-0">
          <v-menu
            v-model="menu2"
            v-if="chkReprocurement"
            :close-on-content-click="false"
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
                readonly
                :rules="requiredRule"
                v-model="form.dateofReprocurement"
                label="Date of Reprocurement"
                persistent-hint
                prepend-inner-icon="event"
                @blur="date = parseDate(dateFormatted)"
                v-on="on"
              ></v-text-field>
            </template>
            <v-date-picker
              v-model="form.dateofReprocurement"
              no-title
              @input="menu2 = false"
              :min="new Date().toISOString()"
            ></v-date-picker>
          </v-menu>
        </div>
      </v-flex>
      <!-- <v-flex xs12>
        <div class="v-form-container">
          <v-textarea
            class="required"
            name="project-description"
            label="Project Description"
            no-resize
            :rules="requiredRule"
            v-model="form.description"
          ></v-textarea>
        </div>
      </v-flex>-->
      <v-flex xs12>
        <div class="v-form-container">
          <v-textarea
            class="required"
            v-if="chkReprocurement"
            name="project-description"
            label="What is the background from the previous contract?"
            no-resize
            :rules="requiredRule"
            v-model="form.previousContractBackground"
          ></v-textarea>
        </div>
      </v-flex>
      <v-flex xs12>
        <div class="v-form-container">
          <v-textarea
            class="required"
            v-if="chkReprocurement"
            name="project-description"
            label="What is the potential if this project fails?"
            no-resize
            :rules="requiredRule"
            v-model="form.projectFailImpact"
          ></v-textarea>
        </div>
      </v-flex>
      <v-flex xs12>
        <div class="v-form-container">
          <v-textarea
            class="required"
            v-if="chkReprocurement"
            name="project-description"
            label="What does success look like for this project?"
            no-resize
            :rules="requiredRule"
            v-model="form.projectSuccess"
          ></v-textarea>
        </div>
      </v-flex>
      <v-flex xs12>
        <div class="v-form-container">
          <div class="v-form-actions">
            <v-flex md-12 mt-4>
              <v-btn :disabled="!valid" color="primary" @click="onNextClicked">Next</v-btn>
            </v-flex>
          </div>
        </div>
      </v-flex>
    </v-form>
  </v-layout>
</template>

<script>
import "./intakebaseinfo.styl";
import ProjectSectorDto from "@/domain/models/ProjectSector.dto";
import ProjectIntakeCategoryDto from "@/domain/models/ProjectIntakeCategory.dto";
import ProjectIntakeServicesDto from "@/domain/models/ProjectIntakeServices.dto";
import ClientDto from "@/domain/models/Client.dto";

export default {
  components: {},
  props: {
    nextPanel: Function,
    panelName: String,
    project: Object
  },
  computed: {
    computedDateFormatted() {
      return this.formatDate(this.date);
    },
    projectSectors() {
      return this.$store.state.projectSectors;
    },
    projectIntakeCategories() {
      return this.$store.state.projectIntakeCategory;
    },
    projectIntakeService() {
      return this.$store.state.projectIntakeServices;
    }
  },
  data() {
    const form = Object.assign({}, this.$props.project);
    const inputProjectSector = form.projectSector || null;
    if (!inputProjectSector) {
      form.projectSector = new ProjectSectorDto();
    }
    const inputProjectIntakeCategory = form.projectIntakeCategory || null;
    if (!inputProjectIntakeCategory) {
      form.projectIntakeCategory = new ProjectIntakeCategoryDto();
    }
    const inputProjectIntakeServices = form.projectIntakeServices || null;
    if (!inputProjectIntakeServices) {
      form.projectIntakeServices = new ProjectIntakeServicesDto();
    }
    const inputClient = form.client || null;
    if (!inputClient) {
      form.client = new ClientDto();
    }

    return {
      valid: true,
      requiredRule: [v => !!v || "This field required"],
      // Initialize using props
      form: { ...form },
      chkReprocurement: false,
      menu1: false,
      menu2: false,
      dateFormatted: undefined,
      projectInformation: this.$store.state.projectInformation,
      row: null
    };
  },
  watch: {
    valid(newVal) {
      this.$store.state.projectInformation = newVal;
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
      const inputProjectIntakeCategory = form.projectIntakeCategory || null;
      if (!inputProjectIntakeCategory) {
        form.projectIntakeCategory = new ProjectIntakeCategoryDto();
      }
      const inputProjectIntakeServices = form.projectIntakeServices || null;
      if (!inputProjectIntakeServices) {
        form.projectIntakeServices = new ProjectIntakeServicesDto();
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
    onNextClicked() {
      if (this.$refs.intakeBaseInfo.validate()) {
        //this.nextPanel(this.panelName);
        this.$emit("next");
        this.$store.state.projectInformation = true;
      }
    },
    reset() {
      this.$refs.intakeBaseInfo.reset();
    },
    submitForm() {
      const formData = this.form;
      this.$store.dispatch("addIntakeRequest", formData);
    }
  }
};
</script>
