<template>
  <v-container grid-list-xl fluid class="page-container custom-timesheets-container">
    <v-layout>
      <v-flex md12 style="padding: 0px;">
        <h1 class="timesheet-header" style="margin-bottom: -10px;">Reports</h1>
      </v-flex>
    </v-layout>
    <v-layout row wrap class="mt-4" style="margin-top: 10px;">
      <v-flex xs12 sm6 md4>
        <v-card 
          hover 
          raised
          :to="{ name: 'timesheet-details'}"
          class="custom-report-card mb-3"
        >
          <v-card-title primary-title>
            <v-avatar color="blue lighten-4" size="48" class="mr-3">
              <v-icon color="blue darken-2">assessment</v-icon>
            </v-avatar>
            <div>
              <div class="headline">Timesheet Details</div>
              <span class="grey--text">Click to view report</span>
            </div>
          </v-card-title> 
        </v-card>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>

export default {
  components: {
  },
  data: () => ({
    //color: Material,
    selectedTab: 'tab-1',
  }),
};
</script>

<style scoped>
  /* A softer, more modern elevation-2 look */
  .custom-report-card {
    box-shadow: 0 3px 1px -2px rgba(0,0,0,.1), 
                0 2px 2px 0 rgba(0,0,0,.07), 
                0 1px 5px 0 rgba(0,0,0,.05) !important;
    transition: box-shadow 0.3s ease-in-out; /* Smooth transition for hover */
  }

  /* Make it slightly stronger when hovering */
  .custom-report-card:hover {
    box-shadow: 0 5px 5px -3px rgba(0,0,0,.1), 
                0 8px 10px 1px rgba(0,0,0,.07), 
                0 3px 14px 2px rgba(0,0,0,.06) !important;
  }
</style>