<template>
  <v-container grid-list-xl fluid class="custom-intake-request-success">
    <v-layout row wrap class="intake-success-layot">
      <v-flex xs12>
        <div class="v-form-container">
          <h1>You have successfully submitted your project</h1>
        </div>
      </v-flex>
      <v-flex xs12>
        <div class="v-form-container">
          <h3
            class="intake-secondary-header"
          >You will receive an email with next steps within 24 hours</h3>
        </div>
      </v-flex>
      <v-flex xs12 class="intake-success-button">
        <v-btn color="btnPrimary" class="white--text" @click="logout">Logout</v-btn>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import './intakesuccess.styl';

export default {
  methods: {
    logout() {
      this.$router.push({ path: 'logout' });
    },
  },
};
</script>
