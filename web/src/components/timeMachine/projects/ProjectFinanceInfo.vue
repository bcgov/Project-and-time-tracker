<template>
  <v-layout row wrap py-2>
    <v-form id="projectFinanceInfo" ref="projectFinance" v-model="valid">
      <v-flex xs12>
        <div class="v-form-container">
          <div class="finance-code-block">
            <h3 class="finance-header">
              Finance Codes
            </h3>
             <span class='mb-4 d-block'>
               Please note: To complete the intake form these fields are optional. However, a project cannot be assigned without finance codes.
             </span>
          </div>
        </div>
      </v-flex>
      <v-flex xs12>
        <div class="v-form-container">
          <v-text-field
            label="Client No. (3 characters)"
            :rules="[rules.clientNoRules]"
            maxlength = 3
            v-model="financeInfo.clientNo"
          ></v-text-field>
        </div>
      </v-flex>
      <v-flex xs6>
        <div class="v-form-container">
          <v-text-field
            label="Responsibility Center (5 characters)"
            :rules="[rules.responsibilityCenterRules]"
            maxlength = 5
            v-model="financeInfo.responsibilityCenter"
          ></v-text-field>
        </div>
      </v-flex>
      <v-flex xs6>
        <div class="v-form-container">
          <v-text-field
            label="Service Center (5 characters)"
            :rules="[rules.serviceCenterRules]"
            maxlength = 5
            v-model="financeInfo.serviceCenter"
          ></v-text-field>
        </div>
      </v-flex>
      <v-flex xs6>
        <div class="v-form-container">
          <v-text-field
            label="STOB (4 characters)"
            :rules="[rules.stobRules]"
            maxlength = 4
            v-model="financeInfo.stob"
          ></v-text-field>
        </div>
      </v-flex>
      <v-flex xs6>
        <div class="v-form-container">
          <v-text-field
            label="Project Code (7 characters)"
            :rules="[rules.projectCodeRules]"
            maxlength = 7
            v-model="financeInfo.projectCode"
          ></v-text-field>
        </div>
      </v-flex>
    </v-form>
  </v-layout>
</template>

<script>
import './projectfinanceinfo.styl';

export default {
  props: { financeInfo: Object },
  data() {
    const form = Object.assign({}, this.$props.financeInfo);
    return {
      valid: true,
      // maskClient: '###',
      // maskStob: '####',
      // maskResponsibility: '#####',
      // maskService: '#####',
      // maskProject: '#######',
      rules: {
        clientNoRules: v => this.showValidationMessage(v, 3),
        responsibilityCenterRules: v => this.showValidationMessage(v, 5),
        serviceCenterRules: v => this.showValidationMessage(v, 5),
        stobRules: v => this.showValidationMessage(v, 4),
        projectCodeRules: v => this.showValidationMessage(v, 7),
      },
      form: { ...form },
    };
  },
  watch: {
    financeInfo(value) {
      this.form = value;
    },
  },
  methods: {
    showValidationMessage(value, count) {
      if (value && value.length && value.length !== count) {
        return `Exactly ${count} characters required`;
      }
      return true; // added to avoid warning 'rules can't be undefined' after atyping valid value
    },
    validate() {
      return this.$refs.projectFinance.validate();
    },
  },
};
</script>
