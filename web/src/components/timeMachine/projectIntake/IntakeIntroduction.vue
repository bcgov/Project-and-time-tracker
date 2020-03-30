<template>
  <v-layout  row wrap py-2>
    <v-form id="intake-client-info"  lazy-validation>
      <v-flex xs12>
        <div class="v-form-container" style="background: ##eaeaea;">
          <div class="v-form-actions" style="background: #eaeaea !important;">
            <v-card style="width:100%">
              <v-card-text class="card-contents">
                <v-layout class="outer-layout" row wrap py-2>
                  <v-flex md12 class="inner-div-content">
                    <span class="intake-intro-header">BC Procurement Intake Form</span>
                     
                  </v-flex>
           
                  <v-flex md12 row-wrap>
                    <span class="sub-content-span">Procurement Services, on behalf of government, provides its clients in the Province and the border public.<br>Sector assistance to obtain the best rates, terms and conditions when buying goods, services and/or construction</span>
                  </v-flex>
                  <v-flex md12 >
                    <span class="content-header-span">Before you begin, please ensure you have the following:</span>
                  </v-flex>
                  <v-flex md12>
                    <span class="content-span">&bull; Finance/Accounting Codes</span>
                  </v-flex>
                  <v-flex md12>
                    <span class="content-span">&bull; Names of the Lead and Executive sponsers</span>
                  </v-flex>
                  <v-flex md12>
                    <span class="content-span">&bull; The required date of completion</span>
                  </v-flex>
                  <v-flex md12>
                    <span class="content-span">&bull; Contract Value</span>
                  </v-flex>
                  <v-flex md12>
                    <span class="content-span">&bull; A general understanding of the project to complete a risk assessment</span>
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
  components: {
  },
  props: {},
  computed: {},
  data() {
    return {};
  },
  watch: {},
  methods: {
      onStart() {
        this.$router.push('intake');
      }
  }
};
</script>
<style scoped>
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
}
.content-span {
    float: left;
    margin-left: 15%;
    font-weight: bold;
    padding-top:15px
}
.content-header-span {
    float: left;
    margin-left: 10%;
    font-weight: bold;
    padding-top:50px;
    color:#000;
    text-shadow: 0.5px 0 #000;
}
.start-button-div {
    background:	#cdd9e4;
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
padding-top:15px;
text-align: justify;
}
</style>
