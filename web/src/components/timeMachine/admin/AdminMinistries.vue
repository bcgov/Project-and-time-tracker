<template>
  <v-container grid-list-xl fluid class="custom-manage-projects-container">
    <v-layout>
      <v-flex md12>
        <h1 class="projects-header">Admin &mdash; Ministries</h1>
      </v-flex>
    </v-layout>
    <v-layout row wrap>
      <v-flex xs12>
        <p>Welcome to ministries list</p>
        <p>TODO: Modify, re-name</p>

        <v-list>
          <v-list-tile
            v-for="ministry in ministries"
            :key="ministry.id"
          >
            <v-list-tile-content>
              <v-list-tile-title v-text="ministry.ministryName"></v-list-tile-title>
            </v-list-tile-content>
          </v-list-tile>
        </v-list>


      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import Material from "vuetify/es5/util/colors";

export default {
  // data: () => ({
  //   color: Material,
  //   selectedTab: 'tab-1',
  //   ministries: this.$store.state.ministryInformation,
  // }),
  components: {

  },
  // data() {
  //   return {
  //     ministryInformation: this.$store.state.ministryInformation
  //   };
  // },
  beforeMount() {
    // this.$store.state.collapseNavigationBar = true;
  },
  // computed: {},
  computed: {
    ministries() {
      return this.$store.state.ministries;
    }
  },
};
</script>

<style></style>
