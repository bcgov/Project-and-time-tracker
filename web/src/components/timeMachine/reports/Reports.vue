<template>
  <v-container grid-list-xl fluid class="page-container custom-timesheets-container">
    <v-layout>
      <v-flex md12>
        <h1 class="timesheet-header">Reports</h1>
      </v-flex>
    </v-layout>
    <v-layout row wrap>
        <ul>
            <li>       
                <router-link to="/reports/timesheet-details" style="font-size: 1.2rem;">Timesheet Details</router-link>
            </li>  
        </ul>
    </v-layout>
  </v-container>
</template>

<script>

export default {
  components: {
  },
  data: () => ({
    color: Material,
    selectedTab: 'tab-1',
  }),
};
</script>

<style></style>