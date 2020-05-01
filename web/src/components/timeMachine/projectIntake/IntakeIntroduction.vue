<template>
  <v-layout row wrap py-2>
    <v-form id="intake-client-info" style="background:#f1f1f1" lazy-validation>
      <v-flex xs12>
        <div class="v-form-container">
          <div class="v-form-actions">
            <v-card style="width:100%">
              <v-card-text class="card-contents">
                <v-layout class="outer-layout" row wrap py-2>
                  <v-flex md12 class="inner-div-content">
                    <span class="intake-intro-header">BC Procurement Intake Form</span>
                  </v-flex>

                  <v-flex md12 row-wrap>
                    <span class="sub-content-span"
                      >Procurement Services, on behalf of Government, provides its clients in the
                      Province and the Broader Public Sector (BPS) <br />assistance to obtain the
                      best rates, terms and conditions when buying goods, services and/or
                      construction.</span
                    >
                  </v-flex>
                  <v-flex md12>
                    <span class="content-header-span"
                      >Before you begin, please ensure you have the following which will help you in
                      completing the intake process:</span
                    >
                  </v-flex>
                  <v-flex md12>
                    <span class="content-span">&bull; Finance/Accounting Codes</span>
                  </v-flex>
                  <v-flex md12>
                    <span class="content-span"
                      >&bull; Names of the Lead and Executive Sponsor for this procurement</span
                    >
                  </v-flex>
                  <v-flex md12>
                    <span class="content-span"
                      >&bull; The expected date of the contract execution or contract start
                      date</span
                    >
                  </v-flex>
                  <v-flex md12>
                    <span class="content-span"
                      >&bull; Estimated contract value for this procurement</span
                    >
                  </v-flex>
                  <v-flex md12>
                    <span class="content-span"
                      >&bull; A general understanding of the procurement project in order to
                      complete an initial risk assessment</span
                    >
                  </v-flex>
                  <v-flex md12></v-flex>
                  <v-flex md-12 mt-4 class="start-button-div">
                    <v-btn color="primary" class="start-button-style" @click="onStart">START</v-btn>
                  </v-flex>
                </v-layout>
              </v-card-text>
            </v-card>
          </div>
        </div>
      </v-flex>
    </v-form>
  </v-layout>
</template>

<script>
export default {
  components: {},
  props: {},
  computed: {},
  data() {
    return {};
  },
  watch: {},
  methods: {
    onStart() {
      this.$router.push('intake');
    },
  },
};
</script>
<style scoped>
.card-contents {
  background: #f1f1f1 !important;
}

.intake-intro-header {
  font-size: 24px !important;
  margin-left: 0px !important;
}
.inner-div-content {
  display: inherit;
  margin-left: 10%;
  font-weight: bold;
  margin-top: 5%;
}
.outer-layout {
  border: solid 1px #eae8e8 !important;
  border-radius: 6px !important;
  margin-top: 15px;
  background: #ffffff;
}
.content-span {
  float: left;
  margin-left: 15%;
  font-weight: bold;
  padding-top: 15px;
}
.content-header-span {
  float: left;
  margin-left: 10%;
  font-weight: bold;
  padding-top: 50px;
  color: #000;
  text-shadow: 0.5px 0 #000;
}
.start-button-div {
  background: #cdd9e4;
  padding: 10px;
  margin-bottom: -9px;
}
.start-button-style {
  margin-right: 6%;
}
.sub-content-span {
  float: left;
  margin-left: 10%;
  font-weight: bold;
  padding-top: 15px;
  text-align: justify;
}
</style>
