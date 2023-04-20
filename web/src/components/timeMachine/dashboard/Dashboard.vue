<template>
  <v-container>
    <v-sheet>
    <confirm ref="confirm"></confirm>
    <v-layout>
      <v-flex md12>
        <h1>Dashboard</h1>
      </v-flex>
    </v-layout>
    <div class="d-flex flex-row mb-6 bg-surface-variant">
      <v-card color="#ff9800" dark class="ma-4 pa-4" elevation="25" outlined>
        <v-card-title>Total Projects</v-card-title>
        <v-card-subtitle>Listen to your favorite artists and albums whenever and wherever, online and offline.</v-card-subtitle>
      </v-card>
      <v-card color="#009688" dark class="ma-4 pa-4">
        <v-card-title>Total Projects</v-card-title>
        <v-card-subtitle>Listen to your favorite artists and albums whenever and wherever, online and offline.</v-card-subtitle>
      </v-card>
      <v-card color="#03a9f4" dark class="ma-4 pa-4">
        <v-card-title>Total Projects</v-card-title>
        <v-card-subtitle>Listen to your favorite artists and albums whenever and wherever, online and offline.</v-card-subtitle>
      </v-card>
      <v-card color="#ce61d2" dark class="ma-4 pa-4">
        <v-card-title>Total Projects</v-card-title>
        <v-card-subtitle>Listen to your favorite artists and albums whenever and wherever, online and offline.</v-card-subtitle>
      </v-card>
    </div>
    <v-card color="#ff9800" dark class="ma-4 pa-4" elevation="25" outlined>
        <v-card-title>Total Projects</v-card-title>
        <v-card-subtitle>Listen to your favorite artists and albums whenever and wherever, online and offline.</v-card-subtitle>
      </v-card>
    </v-sheet>
  </v-container>
</template>

<script>

import Confirm from '../common/Confirm.vue';

import './dashboard.styl';

export default {
  components: {
    Confirm,
  },
  methods: {
    /* async goToMockup() {
      if (await this.$refs.confirm.open('info', 'This is an upcoming feature, Would you like to see an interactive mockup for the upcoming dashboard page?')) {
        window.open('https://xd.adobe.com/view/cf0b2fe2-65dd-4ecd-4085-bd256d678250-b93a/?fullscreen', '_blank');
      }
    }, */
  },
};
</script>
