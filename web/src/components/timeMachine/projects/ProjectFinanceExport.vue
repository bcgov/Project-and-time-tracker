<template>
  <v-container grid-list-xl fluid class="custom-manage-projects-container">
    <h1 class="projects-header">Finance Report</h1>
    <v-layout>
    <v-flex md-2>
      <v-menu
        ref="menu"
        v-model="menu"
        :close-on-content-click="false"
        :return-value.sync="date"
        transition="scale-transition"
        offset-y
      >
        <template v-slot:activator="{ on }">
          <v-text-field
            v-model="date"
            label="Choose Month"
            prepend-icon="event"
            readonly
            v-on="on"
           style="width:50%"
          ></v-text-field>
        </template>
        <v-date-picker v-model="date" type="month" no-title scrollable>
          <v-spacer></v-spacer>
          <v-btn text color="primary" @click="menu = false">Cancel</v-btn>
          <v-btn text color="primary" @click="$refs.menu.save(date)">OK</v-btn>
        </v-date-picker>
      </v-menu>
    </v-flex>
    <v-flex md-10 >
      <div class="start-button-div">
      <v-btn color="primary" class="start-button-style" >Export Finance to PDF</v-btn></div>
    </v-flex></v-layout>
    <v-layout row wrap>
      <v-flex xs12>
        <projects-table></projects-table>
      </v-flex>
    </v-layout>
    <v-flex md12></v-flex>
  </v-container>
</template>

<script>
import Material from "vuetify/es5/util/colors";
import ProjectsTable from "./ProjectTableExport.vue";

import "./projects.styl";

export default {
  components: {
    ProjectsTable
  },
  data: () => ({
    color: Material,
    selected: "My Projects",
    date: new Date().toISOString().substr(0, 7),
    menu: false,
    modal: false
  }),
  computed: {}
};
</script>
<style>
.start-button-style {
    margin-right: 6%;
    float: right;
}
</style>
