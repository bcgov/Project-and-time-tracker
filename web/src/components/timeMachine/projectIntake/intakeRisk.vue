<template>
  <v-layout row wrap py-2>
    <v-form id="intake-risk-assessment" ref="intakeRiskAssessment" v-model="valid" lazy-validation>
      <!-- v-model="risk[itemObjKey].questionId" -->
        <v-flex sm12 v-for="(item,itemObjKey) in intakeRiskQuestions" :key="item.id" >
           
              <v-flex sm12>
                  <div v-html='item.question'  class="question" />
                  <!-- v-model="risk[itemObjKey].answerId" -->
                  <!-- :rules="requireRadioButtondRule" -->
                   <v-radio-group  v-if="item.answer && item.answer[0] && item.answer[0].answer.length< 16" row   >
        <v-radio  class="answer"
          v-for="selection in item.answer" :key="selection.id"
          :label="selection.answer"
          :value="selection.id"
        ></v-radio>
      </v-radio-group>
                 <v-radio-group  v-if="item.answer && item.answer[0] && item.answer[0].answer.length> 15" column  >
        <v-radio  class="answer"
          v-for="selection in item.answer" :key="selection.id"
          :label="selection.answer"
          :value="selection.id"
        ></v-radio>
      </v-radio-group>                     
      </v-flex>
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
      risk: [],   
      requiredRule: [v => !!v || 'This field required'],
      // Initialize using props
       form: { ...form },
      intakeRiskAssessment: this.$store.state.intakeRiskAssessment,
    };
  },
  watch: {
  },
  methods: {
     onNextClicked() {
       this.$emit('next');
      if (this.$refs.intakeRiskAssessment.validate()) {       
       
        this.$store.state.intakeRisk = true;
      }
    },
    reset() {
      this.$refs.intakeRiskAssessment.reset();
    },
    
  },
};
</script>
