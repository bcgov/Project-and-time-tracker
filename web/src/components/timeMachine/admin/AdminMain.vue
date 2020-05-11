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

          <v-list-tile avatar>
            <v-list-tile-content>
              <v-list-tile-title>
                <router-link to="admin/ministries">Ministries</router-link>
              </v-list-tile-title>
              <v-list-tile-sub-title>Add or archive ministries</v-list-tile-sub-title>
            </v-list-tile-content>
          </v-list-tile>

          <v-list-tile avatar>
            <v-list-tile-content>
              <v-list-tile-title>
                <a v-bind:href="AUTH_URL" target="_blank">Keycloak - IAM</a>
              </v-list-tile-title>
              <v-list-tile-sub-title>Login to Keycloak - to manage users</v-list-tile-sub-title>
            </v-list-tile-content>
          </v-list-tile>


          <v-list-tile avatar>
            <v-list-tile-content>
              <v-list-tile-title>
                <router-link to="admin/hourly-rates">Set hourly rates</router-link>
              </v-list-tile-title>
              <v-list-tile-sub-title>Set hourly rates for users</v-list-tile-sub-title>
            </v-list-tile-content>
          </v-list-tile>

           <v-list-tile avatar>
            <v-list-tile-content>
              <v-list-tile-title>
                <router-link to="admin/revenue-rates">Set revenue rates</router-link>
              </v-list-tile-title>
              <v-list-tile-sub-title>Set revenue rates for users</v-list-tile-sub-title>
            </v-list-tile-content>
          </v-list-tile>

          <v-list-tile avatar>
            <v-list-tile-content>
              <v-list-tile-title>
                <router-link to="/admin/financecodes">FinanceCodes</router-link>
              </v-list-tile-title>
              <v-list-tile-sub-title>Add or remove FinanceCode's of Users</v-list-tile-sub-title>
            </v-list-tile-content>
          </v-list-tile>


          <v-list-tile avatar>
            <v-list-tile-content>
              <v-list-tile-title>
                <router-link to="admin/remove-mou">Remove MOU</router-link>
              </v-list-tile-title>
              <v-list-tile-sub-title>Remove MOU's not connected with projects</v-list-tile-sub-title>
            </v-list-tile-content>
          </v-list-tile>
        </v-list>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import Material from 'vuetify/es5/util/colors';
// web/src/modules/security/init.js
import { getAuthURL } from '../../../modules/security/init';

export default {
  data: () => ({
    color: Material,
    selectedTab: 'tab-1',
    AUTH_URL: getAuthURL(),
  }),
  beforeMount() {
    // this.$store.state.collapseNavigationBar = true;
  },
};
</script>

<style></style>
