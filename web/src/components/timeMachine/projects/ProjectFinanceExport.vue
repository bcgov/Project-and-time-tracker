<template>
  <v-container grid-list-xl fluid class="custom-manage-projects-container">
    <h1 class="projects-header">View {{ selected }}</h1>
    <v-radio-group v-model="selected" row>
        <v-radio label="New Finance Report" value="New Finance Report"></v-radio>
        <v-radio label="Finance Records" value="Finance Records"></v-radio>
      </v-radio-group>
    
    <v-layout row wrap>
      <v-flex xs12>
        <projects-table v-if="selected === 'New Finance Report'" ref="projectFinanceExport"></projects-table>
      </v-flex>
    </v-layout>
    <v-flex md12></v-flex>
  </v-container>
</template>

<script>
import Material from 'vuetify/es5/util/colors';

import ProjectsTable from './ProjectTableExport.vue';
import './projects.styl';

export default {
  components: {
    ProjectsTable,
  },
  data: () => ({
    color: Material,
    selected: 'New Finance Report',
  
  }),
  computed: {},
  methods: {
  
  },
};
</script>
<style>
.start-button-style {
  margin-right: 6%;
  float: right;
}
</style>
