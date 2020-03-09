<template>
  <v-layout row wrap py-2>
    <snackbar ref="snackbar"></snackbar>
    <v-form id="project-rfx" ref="form" v-model="valid" lazy-validation>
      <v-flex md6>
        <div class="v-form-container">
          <v-select
            :items="rfxTypes"
            :rules="required"
            class="required"
            label="RFx Type"
            item-value="id"
            item-text="rfxTypeName"
            v-model="rfxForm.rfxType.id"
          ></v-select>
        </div>
      </v-flex>
      <v-flex md6>
        <div class="v-form-container">
          <v-select
            :items="rfxPhases"
            :rules="required"
            class="required"
            label="Current Phase"
            item-value="id"
            item-text="rfxPhaseName"
            v-model="rfxForm.rfxPhase.id"
          ></v-select>
        </div>
      </v-flex>
      <v-flex md6>
        <div class="v-form-container">
          <v-select
            :items="rfxPhases"
            :rules="required"
            class="required"
            label="RFx Name"
            item-value="id"
            item-text="rfxPhaseName"
            v-model="rfxForm.rfxPhase.id"
          ></v-select>
        </div>
      </v-flex>

      <v-flex md12>
        <div class="v-form-container">
          <v-textarea
            name="rfx-overview"
            class="required"
            label="RFx Overview"
            no-resize
            rows="4"
            :rules="required"
            v-model="rfxForm.rfxOverview"
          ></v-textarea>
        </div>
      </v-flex>

      <v-flex md12>
        <div class="v-form-container">
          <v-textarea
            name="client-responsibilities"
            class="required"
            label="Client Responsibilities"
            no-resize
            rows="4"
            :rules="required"
            v-model="rfxForm.clientResponsibilities"
          ></v-textarea>
        </div>
      </v-flex>
      <v-flex md12>
        <div class="v-form-container">
          <v-textarea
            name="psd-responsibilities"
            class="required"
            label="PSD Responsibilities"
            no-resize
            rows="4"
            :rules="required"
            v-model="rfxForm.psdResponsibilities"
          ></v-textarea>
        </div>
      </v-flex>

    </v-form>
  </v-layout>
</template>

<script>
import Snackbar from '../common/Snackbar.vue';

export default {
  props: { rfxData: Object,
    project: Object,
  },
  components: {
    Snackbar,
  },
  data() {
    const rfxForm = Object.assign({}, this.$props.rfxData);
    return {
      required: [v => !!v || 'This field is required'],
      rfxForm: { ...rfxForm },
      valid: true,
      saveRFxBtnLoading: false,
    };
  },
  computed: {
    rfxTypes() {
      return this.$store.state.rfxTypes;
    },
    rfxPhases() {
      return this.$store.state.rfxPhases;
    },
  },
  methods: {
    async saveRFxForm() {
      if (this.$refs.form.validate()) {
        const rfxFormData = Object.assign({}, this.rfxForm);
        rfxFormData.project = this.project;
        if (rfxFormData && rfxFormData.project && rfxFormData.project.id) {
          this.saveRFxBtnLoading = true;
          if (rfxFormData.id) {
            this.$store.dispatch('updateProjectRFxData', rfxFormData);
            this.$refs.snackbar.displaySnackbar('success', 'Updated');
            this.saveRFxBtnLoading = false;
          } else {
            this.$store
              .dispatch('addProjectRFxData', rfxFormData)
              .then((response) => {
                this.saveRFxBtnLoading = false;
                this.$refs.snackbar.displaySnackbar('success', 'Saved');
                if (response.id) {
                  this.rfxForm.id = response.id;
                }
              });
          }
        }
      }
    },
  },
};
</script>
