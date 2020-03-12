<template>
  <v-container grid-list-xl fluid class="page-container custom-timesheets-container">
    <v-layout>
      <v-flex md12>
        <h1 class="timesheet-header">Timesheets</h1>
      </v-flex>
    </v-layout>
    <v-layout row wrap>
      <v-flex xs12>
        <timesheets-table></timesheets-table>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import Material from 'vuetify/es5/util/colors';
import TimesheetsTable from './TimesheetsTable.vue';

import './timesheets.styl';

export default {
  components: {
    TimesheetsTable,
  },
  data: () => ({
    color: Material,
    selectedTab: 'tab-1',
  }),
  beforeMount() {
    // Disabled per client request
    // this.$store.state.collapseNavigationBar = true;
  },
  computed: {},
};
</script>

<style></style>
