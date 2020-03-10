<template>
  <v-layout row wrap py-2>
    <h2 class='heading-txt'>Risk Assessment</h2>
    <v-form
      id="project-risk-assessment"
      ref="projectRiskAssessment"
      v-model="valid"
      lazy-validation
      class="project-risk"
    >
      <div v-if="editScreen">
        <v-flex sm12 v-for="item in intakeRiskQuestions" :key="item.id">
          <v-flex sm12>
            <div v-if="item.questionNo == 1">
              <h2>{{ categoryList[item.category - 1].text }}</h2>
              <br />
            </div>
            <div v-if="categoryList[item.category - 1].showStatus || item.questionNo == 1">
              <div v-html="item.question" class="question" />
              <v-radio-group
                v-if="item.answer && item.answer[0] && item.answer[0].answer.length < 16"
                row
                v-model="item.selectedAnswerId"
                :rules="requireRadioButtondRule"
              >
                <v-radio
                  v-on:change="upateCategoryStatus(item, index)"
                  class="answer"
                  v-for="(selection, index) in item.answer"
                  :key="selection.id"
                  :label="selection.answer"
                  :value="selection.id"
                ></v-radio>
              </v-radio-group>
              <v-radio-group
                v-if="item.answer && item.answer[0] && item.answer[0].answer.length > 15"
                v-model="item.selectedAnswerId"
                :rules="requireRadioButtondRule"
                column
              >
                <v-radio
                  class="answer"
                  v-on:change="upateCategoryStatus(item, index)"
                  v-for="(selection, index) in item.answer"
                  :key="selection.id"
                  :label="selection.answer"
                  :value="selection.id"
                ></v-radio>
              </v-radio-group>
            </div>
          </v-flex>
        </v-flex>
        <v-flex xs12>
          <div class="v-form-container">
            <div class="v-form-actions">
              <v-flex md-12 mt-4>
                <v-btn :disabled="!valid" color="primary" @click="onSave">Save</v-btn>
              </v-flex>
            </div>
          </div>
        </v-flex>
      </div>
      <div v-else class="project-risk-anaysis">
        <v-flex md12>
          <v-btn color="primary" @click="editProjectRisk" class="edit-btn">edit</v-btn>
        </v-flex>
        <v-flex md12>
          Current Risk Level:
        </v-flex>
        <v-expansion-panel :value="0">
          <v-expansion-panel-content>
            <template v-slot:header>
              <div class="primary-heading">
                <v-flex xs11>
                  <label class="sub-header-large">High Impact Risk Factors</label>
                </v-flex>
              </div>
            </template>
            <v-card>
              <v-card-text>
                <v-flex sm12 v-for="item in projectRiskAnswers" :key="item.id" class="risk-analysis">
                  <div v-if="item.riskLevel == 1">
                    <v-card-text class="pl-4">
                      <v-flex>
                        <v-flex sm12
                          ><h4>{{ item.question }}</h4></v-flex
                        >
                        <v-flex sm12>{{ item.answer }}</v-flex>
                      </v-flex>
                    </v-card-text>
                  </div></v-flex>
              </v-card-text>
            </v-card>
          </v-expansion-panel-content>
          <v-expansion-panel-content>
            <template v-slot:header>
              <div class="primary-heading">
                <v-flex xs11>
                  <label class="sub-header-large">Low Impact Risk Factors</label>
                </v-flex>
              </div>
            </template>
            <v-card>
              <v-card-text>
                <v-flex sm12 v-for="item in projectRiskAnswers" :key="item.id" class="risk-analysis">
                  <div v-if="item.riskLevel == 2">
                    <v-card-text class="pl-4">
                      <v-flex>
                        <v-flex sm12
                          ><h4>{{ item.question }}</h4></v-flex
                        >
                        <v-flex sm12>{{ item.answer }}</v-flex>
                      </v-flex>
                    </v-card-text>
                  </div></v-flex>
              </v-card-text>
            </v-card>
          </v-expansion-panel-content>
        </v-expansion-panel>
      </div>
    </v-form>
  </v-layout>
</template>
<script>
import './ProjectRisk.styl';

export default {
  components: {},
  props: {
    intakeRisk: Array,
  },
  computed: {
    intakeRiskQuestions() {
      return this.$store.state.intakeRiskQuestions;
    },
    projectRiskAnswers() {
      return this.$store.state.projectRiskAnswers;
    },
  },
  data() {
    const form = Object.assign({}, this.$props.intakeRisk);
    return {
      editScreen: false,
      valid: true,
      categoryList: [
        { id: 1, text: 'SIZE & SCOPE', showStatus: true },
        { id: 2, text: 'PROCESS COMPLEXITY', showStatus: true },
        { id: 3, text: 'CAPACITY', showStatus: true },
        { id: 4, text: 'UNIQUE ATTRIBUTES', showStatus: true },
      ],
      requireRadioButtondRule: [v => ((v || !v) && v != null) || 'This field required'],
      // Initialize using props
      form: { ...form },
      intakeRiskAssessment: this.$store.state.intakeRiskAssessment,
    };
  },
  watch: {},
  methods: {
    onSave() {
      this.editScreen = false;
    },
    onCancel() {
      this.editScreen = false;
    },
    editProjectRisk() {
      this.editScreen = true;
    },
    upateCategoryStatus(item, index) {
      if (item.questionNo === 1 && index === 0) {
        this.categoryList[item.category - 1].showStatus = false;
        item.showStatus = false;
      } else if (item.questionNo === 1) {
        this.categoryList[item.category - 1].showStatus = true;
        item.showStatus = true;
      }
    },
    onNextClicked() {
      if (this.$refs.intakeRiskAssessment.validate()) {
        this.$store.state.intakeRisk = true;
        this.$emit('next');
      }
    },
    reset() {
      this.$data.requireRadioButtondRule = this.data.requireRadioButtondRule;
      this.$refs.intakeRiskAssessment.reset();
    },
  },
};
</script>
