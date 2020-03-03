<template>
  <v-app>
    <v-navigation-drawer
      v-model="drawer"
      fixed
      app
      :mini-variant.sync="mini" v-bind="loadDefaultMenuStyle()"
    >
      <v-btn icon @click.stop="toggleMenuStyle()" class="navdraw-mini-expander">
        <v-icon>{{ mini ? "chevron_right" : "chevron_left" }}</v-icon>
      </v-btn>
      <v-list>
        <template v-for="item in menu">
          <div v-bind:key="JSON.stringify(item)" v-if="shouldDisplayMenuItem(item)">
            <!-- If the item is a heading -->
            <v-subheader v-if="item.header">
              {{ item.header }}
            </v-subheader>
            <!-- If the item is a divider -->
            <v-divider v-else-if="item.divider" v-bind:key="JSON.stringify(item)" />
            <!-- If the item has children -->
            <v-list-group
              v-else-if="item.items instanceof Array"
              v-bind:key="JSON.stringify(item)"
              v-bind:group="item.group"
              value="true"
            >
              <template v-slot:activator>
                <v-list-tile
                  v-bind:key="JSON.stringify(item)"
                  v-bind:to="item.href"
                  v-bind:title="item.title"
                  v-bind:disabled="item.disabled"
                  router
                  ripple
                >
                  <v-list-tile-action v-if="item.icon">
                    <v-icon>{{ item.icon }}</v-icon>
                  </v-list-tile-action>
                  <v-list-tile-content>
                    <v-list-tile-title> {{ $t(item.title) }}</v-list-tile-title>
                  </v-list-tile-content>
                  <v-list-tile-action>
                    <v-icon></v-icon>
                  </v-list-tile-action>
                </v-list-tile>
              </template>
            </v-list-group>
            <!-- If the item doesn't have any children -->
            <v-list-tile
              v-else
              v-bind:key="JSON.stringify(item)"
              v-bind:to="item.href"
              v-bind:title="item.title"
              v-bind:disabled="item.disabled"
              router
              ripple
            >
              <v-list-tile-action v-if="item.icon">
                <v-icon>{{ item.icon }}</v-icon>
              </v-list-tile-action>
              <v-list-tile-content>
                <v-list-tile-title> {{ $t(item.title) }}</v-list-tile-title>
              </v-list-tile-content>
            </v-list-tile>
          </div>
        </template>
      </v-list>
    </v-navigation-drawer>

    <v-toolbar app fixed class="app-toolbar" color="background" v-if="!isToolbarHide">
      <v-toolbar-side-icon dark @click.native.stop="drawer = !drawer" />
      <v-toolbar-title class="App-toolbar-title">
        <img src="./images/logo.svg" alt="avatar" class="app-logo"/>
      </v-toolbar-title>
      <div class="app-title">Time Machine - dev</div>
      <v-spacer></v-spacer>
       <div class="user-name" v-if="userName">Hi, {{userName}}</div>
    </v-toolbar>

    <v-content>
      <v-container pa-0 fluid fill-height>
        <v-layout justify-center align-top>
          <router-view />
        </v-layout>
      </v-container>
    </v-content>

  </v-app>
</template>

<script>
import { mapState } from 'vuex';
import { shouldDisplayItem } from './menu';


import './App.styl';

export default {
  name: 'App',
  methods: {
    changeLocale(to) {
      global.helper.ls.set('locale', to);
      this.$i18n.locale = to;
    },
    toggleMenuStyle() {
      this.mini = !this.mini;
      this.$store.state.collapseNavigationBar = false;
    },
    loadDefaultMenuStyle() {
      if (this.$store.state.collapseNavigationBar) this.mini = this.$store.state.collapseNavigationBar;
    },
    shouldDisplayMenuItem(item) {
      return shouldDisplayItem(item, this.$router, this.$store.getters.SECURITY_AUTH);
    },
    fetchInitialData() {
      this.$store.dispatch('fetchintakeRiskQuestions');
      this.$store.dispatch('fetchMinistries');
      this.$store.dispatch('fetchRFxPhases');
      this.$store.dispatch('fetchRFxTypes');
      this.$store.dispatch('fetchProjectSectors');
      this.$store.dispatch('fetchUsers');
      this.initialLoadDone = true;
      this.userName = JSON.parse(localStorage.getItem('keycloak_user')).name;
    },
  },
  created() {
    this.$store.state.collapseNavigationBar = false;
  },
  data() {
    return {
      dark: false,
      theme: 'primary',
      mini: false,
      drawer: true,
      locales: ['en-US'],
      colors: ['blue', 'green', 'purple', 'red'],
      isLoggedIn: this.$store.state.isLoggedIn,
      isToolbarHide: (this.$router.currentRoute.name === 'login' || this.$router.currentRoute.name === 'register'),
      initialLoadDone: false,
      userName: '',
    };
  },
  computed: {
    ...mapState(['message', 'menu', 'pageTitle']),
    fetchToken() {
      return this.$store.getters.SECURITY_AUTH.token;
    },
  },
  watch: {
    $route(to) {
      this.isToolbarHide = to.name === 'login' || to.name === 'register';
      this.$store.state.collapseNavigationBar = false;
    },
    fetchToken(newValue, oldValue) {
      if (newValue !== oldValue) {
        this.$store.dispatch('verifyTokenServer')
          .then(() => {
            // Verify token success
            // loading master data only for the first time after page refresh
            if (!this.initialLoadDone) {
              this.fetchInitialData();
            }
          });
      }
    },
  },
};
</script>
