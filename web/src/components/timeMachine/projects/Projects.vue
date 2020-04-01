<template>
  <v-container grid-list-xl fluid class="custom-manage-projects-container">
      <v-flex md12>
        <v-radio-group v-model="selected" row>
        <v-radio label="My Projects" value="My Projects"></v-radio>
        <v-radio label="All Projects" value="All Projects"></v-radio>
        <v-radio label="Archived Projects" value="Archived Projects"></v-radio>
      </v-radio-group>
      </v-flex>  
      <h1 class="projects-header">View {{ selected }}</h1>
      <v-layout row wrap>
      <v-flex xs12>
        <projects-table v-if="selected === 'My Projects'"></projects-table>
        <projects-table v-if="selected === 'All Projects'"></projects-table> 
        <archived-projects-table v-if="selected === 'Archived Projects'"></archived-projects-table> 
      </v-flex>
    </v-layout>
      <v-flex md12>
      </v-flex>  
  </v-container>
</template>

<script>
import Material from 'vuetify/es5/util/colors';
import ProjectsTable from './ProjectsTable.vue';
import ArchivedProjectsTable from './ArchivedProjectsTable.vue';

import './projects.styl';

export default {
  components: {
    ProjectsTable,ArchivedProjectsTable,
  },
  data: () => ({
    color: Material,
    selected: 'My Projects',
    
  }),
  computed: {},
};
</script>
<style></style>
