<template>
  <v-container grid-list-xl fluid class="custom-manage-projects-container">
    <v-layout>
      <v-flex md12>
        <h1 class="projects-header">Admin Main</h1>
      </v-flex>
    </v-layout>
    <v-layout row wrap>
      <v-flex xs12>

        <!-- <a href="">Ministries</a> -->
        <router-link to="admin/ministries">Ministries</router-link>

      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import Material from 'vuetify/es5/util/colors';


export default {
  data: () => ({
    color: Material,
    selectedTab: 'tab-1',
  }),
  beforeMount() {
    // this.$store.state.collapseNavigationBar = true;
  },
  computed: {},
};
</script>

<style></style>
