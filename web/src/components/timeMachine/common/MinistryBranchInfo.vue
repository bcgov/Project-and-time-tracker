<template>
  <v-layout row wrap py-2>
    <v-form id="intake-client-info" ref="intakeClientInfo" v-model="valid" lazy-validation>
      <v-flex sm6>
        <div class="v-form-container">
          <v-select
            :items="ministries"
            label="Ministry"
            class="required"
            :rules="requiredRule"
            v-model="form.ministry.id"
            item-value="id"
            item-text="ministryName"
          ></v-select>
        </div>
      </v-flex>
      <v-flex sm6>
        <div class="v-form-container">
          <v-text-field
            label="Branch"
            v-model="form.orgDivision"
            class="required"
            :rules="requiredRule"
            ></v-text-field>
        </div>
      </v-flex>
      <v-flex xs12>
        <generic-contact-info :contact="form"></generic-contact-info>
      </v-flex>
      <v-flex xs12 pt-2>
        <project-finance-info :financeInfo="form"></project-finance-info>
      </v-flex>
      <v-flex xs12 py-2>
        <div class="v-form-container">
          <div class="v-form-actions">
            <v-flex md-12 mt-4>
              <v-btn :disabled="!valid" color="primary" @click="onNextClicked">
                Next
              </v-btn>
            </v-flex>
          </div>
        </div>
      </v-flex>
    </v-form>
  </v-layout>
</template>

<script>
import ProjectFinanceInfo from '../projects/ProjectFinanceInfo.vue';
import GenericContactInfo from './GenericContactInfo.vue';

import MinistryDto from '@/domain/models/Ministry.dto';

export default {
  components: {
    ProjectFinanceInfo,
    GenericContactInfo,
  },
  props: {
    nextPanel: Function,
    panelName: String,
    ministry: Object,
  },
  computed: {
    ministries() {
      return this.$store.state.ministries;
    },
  },
  data() {
    const form = Object.assign({}, this.$props.ministry);

    const inputMinistry = form.ministry || null;
    if (!inputMinistry) {
      form.ministry = new MinistryDto();
    }

    return {
      valid: true,
      requiredRule: [v => !!v || 'This field required'],
      form: { ...form },
      ministryInformation: this.$store.state.ministryInformation,
    };
  },
  watch: {
    valid(newVal) {
      this.$store.state.ministryInformation = newVal;
    },
    ministry(value) {
      this.form = value;

      const inputMinistry = this.form.ministry || null;
      if (!inputMinistry) {
        this.form.ministry = new MinistryDto();
      }
    },
  },
  methods: {
    onNextClicked() {
      if (this.$refs.intakeClientInfo.validate()) {
        this.nextPanel(this.panelName);
        this.$store.state.ministryInformation = true;
      }
    },
    reset() {
      this.$refs.intakeClientInfo.reset();
    },
  },
};
</script>
