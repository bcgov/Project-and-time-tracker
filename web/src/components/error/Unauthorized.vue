<template>
  <v-container d-flex justify-center align-center>
    <div class="unauthorized">
      <v-form>
        <v-container d-flex justify-center align-center>
          <v-layout d-flex justify-center align-center>
            <v-flex md12>
              <h1 class="unauthorized-title">Unauthorized</h1>
              <template>
                <v-expansion-panel class="my-5" :value="0">
                  <v-expansion-panel-content >
                    <v-card class="py-5">
                      <v-card-text>
                        <p>Sorry, you do not have permission to access this part of the app. You will automatically be logout in {{ timeUntilRedirect }} seconds.</p>
                        <p>Please contact your system or domain administrator if your require access to this part of the application.</p>
                      </v-card-text>
                    </v-card>
                  </v-expansion-panel-content>
                </v-expansion-panel>
              </template>
            </v-flex>
          </v-layout>
        </v-container>
      </v-form>
    </div>
  </v-container>
</template>

<script>
import Vue from 'vue';
import VeeValidate from 'vee-validate';
import './unauthorized.styl';

Vue.use(VeeValidate);

export default {
  $_veeValidate: {
    validator: 'new',
  },
  data() {
    return {
      timeUntilRedirect: 5,
    };
  },
  mounted() {
    const timer = setInterval(() => {
      this.timeUntilRedirect--;
    }, 1000);

    setTimeout(() => {
      clearInterval(timer);
      // this.$router.push('/logout');
    }, 5000);
  },
};
</script>

<style>
h1.unauthorized-title {
  text-align: center !important;
}
legend {
  margin-left: 1em;
}
p {
  text-align: center !important;
  font-weight: bold !important;
}
</style>
