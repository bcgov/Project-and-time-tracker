<template>
  <div class="text-xs-center overlay" v-if="showSpinner">
    <v-progress-circular
      :size="50"
      indeterminate
      color="primary"
    ></v-progress-circular>
  </div>
</template>

<script>
import './spinner.styl';

export default {
  data: () => ({
    showSpinner: false,
  }),
  methods: {
    open() {
      this.showSpinner = true;
    },
    close() {
      this.showSpinner = false;
    },
  },
};
</script>
