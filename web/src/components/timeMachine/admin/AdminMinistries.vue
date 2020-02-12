<template>
  <v-container grid-list-xl fluid class="custom-manage-projects-container">
    <v-layout>
      <v-flex md12>
        <h1 class="projects-header">Admin &mdash; Ministries</h1>
      </v-flex>
    </v-layout>
    <v-layout row wrap>
      <v-flex xs12>


        Lorem ipsum dolor sit amet consectetur adipisicing elit. Nam itaque, asperiores blanditiis ducimus laborum pariatur facere tenetur quo doloribus temporibus culpa eaque sit nihil quasi magni! Mollitia ducimus porro ratione!

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
