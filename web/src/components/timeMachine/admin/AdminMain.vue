<template>
  <v-container grid-list-xl fluid class="custom-manage-projects-container">
    <v-layout>
      <v-flex md12>
        <h1 class="projects-header">Admin</h1>
      </v-flex>
    </v-layout>
    <v-layout row wrap>
      <v-flex xs12>
        <v-list two-line subheader>
          <v-subheader>Admininistrator Controls</v-subheader>

          <v-list-item avatar>
            <v-list-item-content>
              <v-list-item-title>
                <router-link to="admin/ministries">Ministries</router-link>
              </v-list-item-title>
              <v-list-item-sub-title>Add or archive ministries</v-list-item-sub-title>
            </v-list-item-content>
          </v-list-item>

          <v-list-item avatar>
            <v-list-item-content>
              <v-list-item-title>
                <router-link to="admin/hourly-rates">Set hourly rates</router-link>
              </v-list-item-title>
              <v-list-item-sub-title>Set hourly rates for users</v-list-item-sub-title>
            </v-list-item-content>
          </v-list-item>

           <v-list-item avatar>
            <v-list-item-content>
              <v-list-item-title>
                <router-link to="admin/revenue-rates">Set revenue rates</router-link>
              </v-list-item-title>
              <v-list-item-sub-title>Set revenue rates for users</v-list-item-sub-title>
            </v-list-item-content>
          </v-list-item>

          <v-list-item avatar>
            <v-list-item-content>
              <v-list-item-title>
                <router-link to="/admin/financecodes">Set finance codes</router-link>
              </v-list-item-title>
              <v-list-item-sub-title>Add or remove finance code's of users</v-list-item-sub-title>
            </v-list-item-content>
          </v-list-item>


          <v-list-item avatar>
            <v-list-item-content>
              <v-list-item-title>
                <router-link to="admin/remove-mou">Remove MOU</router-link>
              </v-list-item-title>
              <v-list-item-sub-title>Remove MOU's not connected with projects</v-list-item-sub-title>
            </v-list-item-content>
          </v-list-item>

          <v-list-item avatar>
            <v-list-item-content>
              <v-list-item-title>
                <router-link to="admin/rfx-phase">Set Rfx Phase</router-link>
              </v-list-item-title>
              <v-list-item-sub-title>Add edit or remove Rfx Phases</v-list-item-sub-title>
            </v-list-item-content>
          </v-list-item>


          <v-list-item avatar>
            <v-list-item-content>
              <v-list-item-title>
                <router-link to="admin/rfx-type">Set Rfx Type</router-link>
              </v-list-item-title>
              <v-list-item-sub-title>Add edit or remove Rfx Types</v-list-item-sub-title>
            </v-list-item-content>
          </v-list-item>
        </v-list>
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
};
</script>

<style></style>
