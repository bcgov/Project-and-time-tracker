<template>
  <v-container grid-list-xl fluid class="page-container custom-timesheets-container">
        
    <!-- Year-end notification -->
    <div class="red white--text pa-3 mb-4" style="border-radius: 4px; margin-bottom: 6px !important; text-align: center;">
      <strong>Important fiscal year-end notice:</strong>
      Time for <strong>March 30 and March 31</strong> must be entered on timesheet
      dates <strong>on or before March 29</strong>.
      <br>Please complete all March entries by end of day <strong>April 7</strong>.
    </div>
    
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
