<template>
  <v-layout row wrap py-2>
    <v-form id="intake-risk-assessment" ref="intakeRiskAssessment" v-model="valid" lazy-validation>
         <v-flex sm12 v-for="item in intakeRiskQuestions" :key="item.id">
           
              <v-flex sm12>
                  <div v-html='item.question'/>
                   <v-radio-group>
        <v-radio
          v-for="selection in item.answer" :key="selection.id"
          :label="selection.answer"
          :value="selection.id"
        ></v-radio>
      </v-radio-group>                    
      </v-flex>
       </v-flex>
     
    </v-form>
  </v-layout>
</template>
<script>

import './intakeRisk.styl';

export default {
  components: {
  },
  props: {
    intakeRisk: Array,
    nextPanel: Function,
    panelName: String,
  },
  computed: {
    intakeRiskQuestions() {    
      return this.$store.state.intakeRiskQuestions;
    },
  },
  data() {
    const form = Object.assign({}, this.$props.intakeRisk);
    return {
      valid: true,
      requiredRule: [v => !!v || 'This field required'],
      // Initialize using props
      form: { ...form },
      intakeRiskAssessment: this.$store.state.intakeRiskAssessment,
    };
  },
  watch: {
  },
  methods: {
  },
};
</script>
