<template>
    <v-container grid-list-xl fluid class="custom-manage-projects-container">
    <v-layout row wrap>
      <v-flex d-flex justify-center align-start style="width: 100%;">
      <v-flex md4>
        <h1 class="projects-header">View {{ selected }}</h1>
      </v-flex>
       <v-flex md8><v-radio-group class="right-position" row v-model="selected">
        <v-radio label="My Projects" value="My Projects"></v-radio>
        <v-radio v-if="($store.state.activeRoles && $store.state.activeRoles.role && $store.state.activeRoles.role.includes('PSB_Admin')? $store.state.activeRoles.role.includes('PSB_Admin'):'')||($store.state.activeRoles && $store.state.activeRoles.role && $store.state.activeRoles.role.includes('PSB_Intake_User')?$store.state.activeRoles.role.includes('PSB_Intake_User'):'')" label="All Projects" value="All Projects"></v-radio>
        <v-radio label="Archived Projects" value="Archived Projects"></v-radio>
      </v-radio-group></v-flex></v-flex>
    </v-layout>
      <v-layout row wrap>
      <v-flex xs12>
        <projects-table v-if="selected === 'My Projects'" :selectedItem="2"></projects-table>
        <projects-table v-if="selected === 'All Projects'" :selectedItem="1"></projects-table>
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
    ProjectsTable, ArchivedProjectsTable,
  },
  data: () => ({
    color: Material,
    selected: 'My Projects',

  }),
  computed: {
  },
};
</script>
<style>
.v-input--radio-group--row .v-radio{
     display: flex;
 }
 .right-position {
   float: right;
 }
 </style>
