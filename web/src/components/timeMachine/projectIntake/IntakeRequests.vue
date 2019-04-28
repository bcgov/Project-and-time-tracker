<template>
  <v-container grid-list-xl fluid class="page-container custom-intake-request-container">
    <v-layout>
      <v-flex md12>
        <h1 class="intake-request-header">Intake Requests</h1>
      </v-flex>
    </v-layout>
    <v-layout row wrap>
      <v-flex xs12>
        <intake-forms-table></intake-forms-table>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import Material from 'vuetify/es5/util/colors';
import IntakeFormsTable from './IntakeFormsTable.vue';
import './intakeRequest.styl';

export default {
  components: {
    IntakeFormsTable,
  },
  data: () => ({
    color: Material,
    selectedTab: 'tab-1',
  }),
};
</script>

<style></style>
