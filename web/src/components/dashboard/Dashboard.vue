<template>
  <v-container grid-list-xl fluid class="page-container custom-dashboard-container">
    <confirm ref="confirm"></confirm>
    <v-flex md12>
        <h1 class="mx-0">My Dashboard</h1>
    </v-flex>
    <v-layout row wrap>
      <v-flex md12 px-2 class="dummy-dashboard">
        <img src="@/images/dashboard.svg" @click="goToMockup">
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>

import Confirm from '../timeMachine/common/Confirm.vue';

import './dashboard.styl';

export default {
  components: {
    Confirm,
  },
  methods: {
    async goToMockup() {
      if (await this.$refs.confirm.open('info', 'This is an upcoming feature, Would you like to see an interactive mockup for the upcoming dashboard page?')) {
        window.open('https://xd.adobe.com/view/cf0b2fe2-65dd-4ecd-4085-bd256d678250-b93a/?fullscreen', '_blank');
      }
    },
  },
};
</script>
