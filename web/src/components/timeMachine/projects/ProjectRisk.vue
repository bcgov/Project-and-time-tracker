<template>
  <v-layout row wrap py-2>
       <snackbar ref="snackbar"></snackbar>
       <spinner ref="spinner"></spinner>
    <!-- <h2>Risk Assessment</h2> -->
    <v-flex class="mb-4">
      <label class="primary-heading sub-header-large">Risk Assessment</label>

      <div v-if="intakeScore" class="all-risk-scores">
        <!-- PROBLEM: RISK LEVEL SHOULD RE-CALCULATE EVERY TIME USERS MODIFY CHECKBOXES BELOW -->
        <div class="risk-items"> <span class="bold">Intake Risk Score: &nbsp;</span>
        <span :class="`level-${intakeScore.level}`">{{ intakeScore.level }} ( {{ intakeScore.percentage }}% )</span></div>
       <div class="risk-items"> <span class="bold">PSB Risk Score: &nbsp;</span>
        <span :class="`level-${psbScore.level}`">{{ psbScore.level }} ( {{ psbScore.percentage }}% )</span></div>
        <div class="risk-items"> <span class="bold">Total Risk Score: &nbsp;</span>
        <span :class="`level-${totalScore.level}`">{{ totalScore.level }} ( {{ totalScore.percentage }}% )</span></div>
        <div class="risk-items"> <span class="bold">SPO Engagement Need? &nbsp;</span>
        <span >{{needSpo}}</span></div>
      </div>

      <pre>

intake:{{ intakeScore }}
psb:{{ psbScore }}
total:{{ totalScore }}
spo:{{ spoScore }}

</pre>
    </v-flex>

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
              <h3>{{ categoryList[item.category - 1].text }}</h3>
              <br />
            </div>
            <div v-if="categoryList[item.category - 1].showStatus || item.questionNo == 1">
              <div v-html="item.question" class="question" />
              <v-radio-group
                v-if="item.answer && item.answer[0] && item.answer[0].answer.length < 16"
                row
                v-model="item.selectedAnswerId"
                :rules="requireRadioButtondRule"
                @change="calculateData()"
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
                @change="calculateData()"
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
                <v-btn color="secondary" @click="onCancel">cancel</v-btn>
              </v-flex>
            </div>
          </div>
        </v-flex>
      </div>
      <div v-else class="project-risk-anaysis">
        <v-flex md12>
          <v-btn color="primary" @click="editProjectRisk" class="edit-btn">edit</v-btn>
        </v-flex>

        <v-expansion-panel :value="0">
          <v-expansion-panel-content>
            <template v-slot:header>
              <div class="primary-heading">
                <v-flex xs11>
                  <label class="sub-header-large">SIZE & SCOPE</label>
                </v-flex>
              </div>
            </template>
            <v-card>
              <v-card-text>
                <v-flex
                  sm12
                  v-for="item in projectRiskAnswers"
                  :key="item.id"
                  class="risk-analysis"
                >
                  <div v-if="item.category == 1">
                    <v-card-text class="pl-4">
                      <v-flex>
                        <v-flex sm11
                          ><b><div v-html="item.question" class="question-text"></div></b>
                        </v-flex>
                        <v-flex
                          ><v-btn :ripple="false" class="edit-link" @click="editProjectRisk"
                            >edit</v-btn
                          ></v-flex
                        >
                        <v-flex sm12>{{ item.answer }}</v-flex>
                      </v-flex>
                    </v-card-text>
                  </div></v-flex
                >
              </v-card-text>
            </v-card>
          </v-expansion-panel-content>
          <v-expansion-panel-content>
            <template v-slot:header>
              <div class="primary-heading">
                <v-flex xs11>
                  <label class="sub-header-large">PROCESS COMPLEXITY</label>
                </v-flex>
              </div>
            </template>
            <v-card>
              <v-card-text>
                <v-flex
                  sm12
                  v-for="item in projectRiskAnswers"
                  :key="item.id"
                  class="risk-analysis"
                >
                  <div v-if="item.category == 2">
                    <v-card-text class="pl-4">
                      <v-flex>
                        <v-flex sm11
                          ><b><div v-html="item.question" class="question-text"></div></b>
                        </v-flex>
                        <v-flex
                          ><v-btn :ripple="false" class="edit-link" @click="editProjectRisk"
                            >edit</v-btn
                          ></v-flex
                        >
                        <v-flex sm12>{{ item.answer }}</v-flex>
                      </v-flex>
                    </v-card-text>
                  </div></v-flex
                >
              </v-card-text>
            </v-card>
          </v-expansion-panel-content>

          <v-expansion-panel-content>
            <template v-slot:header>
              <div class="primary-heading">
                <v-flex xs11>
                  <label class="sub-header-large">CAPACITY</label>
                </v-flex>
              </div>
            </template>
            <v-card>
              <v-card-text>
                <v-flex
                  sm12
                  v-for="item in projectRiskAnswers"
                  :key="item.id"
                  class="risk-analysis"
                >
                  <div v-if="item.category == 3">
                    <v-card-text class="pl-4">
                      <v-flex>
                        <v-flex sm11
                          ><b><div v-html="item.question" class="question-text"></div></b>
                        </v-flex>
                        <v-flex
                          ><v-btn :ripple="false" class="edit-link" @click="editProjectRisk"
                            >edit</v-btn
                          ></v-flex
                        >
                        <v-flex sm12>{{ item.answer }}</v-flex>
                      </v-flex>
                    </v-card-text>
                  </div></v-flex
                >
              </v-card-text>
            </v-card>
          </v-expansion-panel-content>


          <v-expansion-panel-content>
            <template v-slot:header>
              <div class="primary-heading">
                <v-flex xs11>
                  <label class="sub-header-large">UNIQUE ATTRIBUTES</label>
                </v-flex>
              </div>
            </template>
            <v-card>
              <v-card-text>
                <v-flex
                  sm12
                  v-for="item in projectRiskAnswers"
                  :key="item.id"
                  class="risk-analysis"
                >
                  <div v-if="item.category == 4">
                    <v-card-text class="pl-4">
                      <v-flex>
                        <v-flex sm11
                          ><b><div v-html="item.question" class="question-text"></div></b>
                        </v-flex>
                        <v-flex
                          ><v-btn :ripple="false" class="edit-link" @click="editProjectRisk"
                            >edit</v-btn
                          ></v-flex
                        >
                        <v-flex sm12>{{ item.answer }}</v-flex>
                      </v-flex>
                    </v-card-text>
                  </div></v-flex
                >
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
import Snackbar from '../common/Snackbar.vue';
import Spinner from '../common/Spinner.vue';

export default {
  components: {
    Snackbar,
    Spinner,
  },
  props: {
    intakeRisk: Array,
    projectId: String,
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
      intakeScore: undefined,
      psbScore: undefined,
      totalScore: undefined,
      spoScore: undefined,
      needSpo: 'No',
    };
  },
  watch: {},
  methods: {
    async updateInitalData() {
      for (let i = 0; i < this.intakeRiskQuestions.length; i++) {
        // get the selected answer
        const selectedAnswer = this.projectRiskAnswers.filter(
          item => item.questionId === this.intakeRiskQuestions[i].id,
        );
        if (selectedAnswer && selectedAnswer[0]) {
          // update the selected answer details to main array
          this.intakeRiskQuestions[i].selectedAnswerId = selectedAnswer[0].answerid;
          this.intakeRiskQuestions[i].score = selectedAnswer[0].score;
          this.intakeRiskQuestions[i].analysisId = selectedAnswer[0].id;
        }
        // to set category status i.e to hide and show questions based on the answer of the first question
        for (let index = 0; index < this.intakeRiskQuestions[i].answer.length; index++) {
          if (
            this.intakeRiskQuestions[i].answer[index].id
            === this.intakeRiskQuestions[i].selectedAnswerId
          ) {
            this.upateCategoryStatus(this.intakeRiskQuestions[i], index);
          }
        }
      }
      this.calculateData();
    },
    prepareRiskAnalysis() {
      // prepare data to send to server
      const riskAnalysis = [];
      let riskAnalysisIndex = 0;
      for (let i = 0; i < this.intakeRiskQuestions.length; i++) {
        const question = this.intakeRiskQuestions[i];

        let scoreValue = 0;
        const selectedAnswer = question.answer.filter(
          answer => answer.id === question.selectedAnswerId,
        );
        if (selectedAnswer && selectedAnswer[0]) {
          scoreValue = selectedAnswer[0].score;
        }

        const analysisId = question.analysisId ? question.analysisId : null;
        riskAnalysis[riskAnalysisIndex] = {
          questionId: question.id,
          answerId: question.selectedAnswerId,
          score: scoreValue,
          id: analysisId,
        };
        riskAnalysisIndex++;
      }
      return riskAnalysis;
    },
    onSave() {
      const riskAnalysis = this.prepareRiskAnalysis();
      this.$refs.spinner.open();
      const projectId = this.$store.state.activeProject.id;
      let isSPO = false;
      if (this.needSpo === 'YES') { isSPO = true; }

      let riskLevel = 0;
      if (this.intakeScore.level === 'High') { riskLevel = 1; } else if (this.intakeScore.level === 'Medium') { riskLevel = 2; } else if (this.intakeScore.level === 'Low') { riskLevel = 3; }

      const formData = {
        projectId,
        risk: riskAnalysis,
        scores: {
          IntakeriskScore: this.intakeScore ? this.intakeScore.percentage : undefined,
          psbRiskScore: this.psbScore ? this.psbScore.percentage : undefined,
          riskScore: this.totalScore ? this.totalScore.percentage : undefined,
          intakeRiskLevel: riskLevel,
          isSPOEngagement: isSPO,
        },
      };
      this.$store.dispatch('updateRiskAnalysis', formData).then(
        (res) => {
          this.$store.state.projectRiskAnswers = res;
          this.updateInitalData();
          this.$refs.snackbar.displaySnackbar('success', 'Successfully saved risk analysis.');
          this.$refs.spinner.close();
        },
        (err) => {
          this.$refs.spinner.close();
          if (err && err.response && err.response.data) {
            const { message } = err.response.data.error;
            this.$refs.snackbar.displaySnackbar('error', message);
          } else {
            this.$refs.snackbar.displaySnackbar('error', 'Risk analysis Error');
          }
        },
      );
      this.editScreen = false;
      this.updateInitalData();
    },
    onCancel() {
      this.updateInitalData();
      this.editScreen = false;
    },
    editProjectRisk() {
      this.updateInitalData();
      this.editScreen = true;
    },
    upateCategoryStatus(item, index) {
      // to set status of first question of the category, for the first answer selection from the list
      if (item.questionNo === 1 && index === 0) {
        this.categoryList[item.category - 1].showStatus = false;
      } // to set status of first question of the category
      else if (item.questionNo === 1) {
        this.categoryList[item.category - 1].showStatus = true;
      }
      // to reset the selection & score of the hidden answers
      if (!this.categoryList[item.category - 1].showStatus && item.questionNo === 1) {
        const questionsInThisCategory = this.intakeRiskQuestions.filter(
          question => question.category === this.categoryList[item.category - 1].id,
        );
        for (let i = 0; i < questionsInThisCategory.length; i++) {
          if (questionsInThisCategory[i].questionNo !== 1) {
            questionsInThisCategory[i].selectedAnswerId = null;
            questionsInThisCategory[i].score = 0;
          }
        }
      }
    },
    getRiskLevel(score) {
      let riskLevel = 'Low';
      if (score > 50) {
        riskLevel = 'High';
      } else if (score > 25) {
        riskLevel = 'Medium';
      }
      return riskLevel;
    },
    calculateItemScore(riskQuestions) {
      let totalPossibleScore = 0;
      const score = [...riskQuestions]
        // Convert to scores
        .map((question) => {
          const totalPossible = question.answer.map(answer => answer.score);

          totalPossible.sort((a, b) => b - a);

          totalPossibleScore += totalPossible[0]; // Now that it's sorted, get highest val
          const selectedAnswer = question.answer.filter(
            item => item.id === question.selectedAnswerId,
          );
          if (
            selectedAnswer
            && selectedAnswer[0]
            && typeof selectedAnswer[0].score !== 'undefined'
          ) {
            return selectedAnswer[0].score;
          }
          return 0;
        })
        // Sum all the scores
        .reduce((a, cur) => a + cur);

      const percentage = ((score / totalPossibleScore) * 100).toFixed(2);
      // eslint-disable-next-line consistent-return
      return {
        score,
        totalPossibleScore,
        percentage,
        level: this.getRiskLevel(percentage),
      };
    },
    calculateRiskScore() {
      // Get value of current answer
      if (!this.intakeRiskQuestions) return;

      this.intakeScore = this.calculateItemScore(this.intakeRiskQuestions.filter(item => !(item.is_PSB)));
      this.psbScore = this.calculateItemScore(this.intakeRiskQuestions.filter(item => item.is_PSB));
      this.totalScore = this.calculateItemScore(this.intakeRiskQuestions);
      this.spoScore = this.calculateItemScore(this.intakeRiskQuestions.filter(item => item.isStrategicContact));
      this.needSpo = this.spoScore > 15 ? 'YES' : 'NO';
    },
    calculateData() {
      this.calculateRiskScore();
    },
  },
};
</script>
<style scoped>
.level-Low {
  color: green;
}
.level-High {
  color: red;
}
.level-Medium {
  color: orange;
}
</style>
