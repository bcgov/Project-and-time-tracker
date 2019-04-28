<template>
  <v-snackbar top fixed auto-height :value="open" :color="color">
    <div  v-if="!haveMultipleErrors">
      <v-icon color="white" class="snackbar-v-icon">{{icon}}</v-icon>
      <span style="vertical-align: text-bottom;">{{message}}</span>
    </div>
    <v-layout row wrap v-else>
      <v-flex xs12 text-xs-center v-for="message in messages" v-bind:key="message.message" py-0>
        <v-icon color="white">{{icon}}</v-icon>
        <span style="vertical-align: text-bottom;">{{message.message}}</span>
      </v-flex>
    </v-layout>
  </v-snackbar>
</template>

<script>
import { setTimeout } from 'timers';

export default {
  data: () => ({
    message: null,
    open: false,
    color: null,
    icon: null,
    haveMultipleErrors: false,
    messages: [],
  }),
  methods: {
    async displaySnackbar(type, message) {
      this.haveMultipleErrors = false;
      if (type === 'success') {
        this.color = 'success';
        this.icon = 'check_circle';
      } else if (type === 'error') {
        this.color = 'error';
        this.icon = 'error';
      } else if (type === 'info') {
        this.color = 'info';
        this.icon = 'info';
      } else if (type === 'warning') {
        this.color = 'warning';
        this.icon = 'warning';
      }

      this.open = true;
      this.message = message;
      setTimeout(() => {
        this.open = false;
      }, 3000);
    },

    async displayMultipleErrorSnackbar(type, errList) {
      if (type === 'error') {
        this.haveMultipleErrors = true;
        this.color = 'error';
        this.icon = 'error';

        this.messages = errList;
        this.open = true;
      }
      setTimeout(() => {
        this.open = false;
      }, 3000);
    },

  },
};
</script>

<style>
.width-100{
  width:100%;
  display:block;
  height:auto;
}
.snackbar-v-icon
{
margin-right: 0.5rem;
}
</style>
