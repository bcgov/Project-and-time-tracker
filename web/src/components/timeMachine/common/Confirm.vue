<template>
  <v-dialog
    id="Confirm"
    v-model="dialog"
    content-class="intake-dialog"
    max-width="390"
    @keydown.esc="cancel"
    v-bind:style="{ zIndex: 200}"
  >
    <v-card>
      <v-toolbar dark :color="color" dense flat>
        <v-icon>{{icon}}</v-icon>
        <v-toolbar-title class="white--text">{{ title }}</v-toolbar-title>
      </v-toolbar>
      <v-card-text v-show="!!message">{{ message }}</v-card-text>
      <v-card-actions class="pt-0 clear-margin">
        <v-spacer></v-spacer>
        <v-btn color="primary darken-1" flat="flat" @click.native="agree">Yes</v-btn>
        <v-btn color="grey" flat="flat" @click.native="cancel">Cancel</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import './confirm.styl';

export default {
  data: () => ({
    dialog: false,
    resolve: null,
    reject: null,
    message: null,
    title: null,
    type: null,
    color: 'primary',
    icon: null,
  }),
  methods: {
    open(type, message) {
      this.dialog = true;
      if (type === 'info') {
        this.title = 'Confirmation';
        if (message === '') {
          this.message = 'Are you sure to confirm this?';
        } else {
          this.message = message;
          this.color = 'primary';
          this.icon = 'info';
        }
      } else if (type === 'danger') {
        this.title = 'Delete';
        this.message = message || 'Are you sure you want to delete this record?';
        this.color = 'red';
        this.icon = 'delete';
      } else if (type === 'warning') {
        this.title = 'Warning';
        this.message = 'Are you sure to delete this?';
        this.color = 'primary';
        this.icon = 'warning';
      }
      return new Promise((resolve, reject) => {
        this.resolve = resolve;
        this.reject = reject;
      });
    },
    agree() {
      this.resolve(true);
      this.dialog = false;
    },
    cancel() {
      this.resolve(false);
      this.dialog = false;
    },
  },
};
</script>
