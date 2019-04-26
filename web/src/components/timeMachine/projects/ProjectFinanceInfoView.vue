<template>
  <v-layout column py-2>
    <v-flex xs12>
      <h3>Finance Codes</h3>
    </v-flex>

    <v-layout>
      <v-flex md4>
        <div class="body-1">Client No:</div>
      </v-flex>
      <v-flex md8>
        <div class="body-2">{{financeInfo.clientNo}}</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md4>
        <div class="body-1">Responsibility Center:</div>
      </v-flex>
      <v-flex md8>
        <div class="body-2">{{financeInfo.responsibilityCenter}}</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md4>
        <div class="body-1">Service Center:</div>
      </v-flex>
      <v-flex md8>
        <div class="body-2">{{financeInfo.serviceCenter}}</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md4>
        <div class="body-1">Service STOB:</div>
      </v-flex>
      <v-flex md8>
        <div class="body-2">{{financeInfo.stob}}</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md4>
        <div class="body-1">Project Code:</div>
      </v-flex>
      <v-flex md8>
        <div class="body-2">{{financeInfo.projectCode}}</div>
      </v-flex>
    </v-layout>
  </v-layout>
</template>

<script>
import './projectfinanceinfo.styl';

export default {
  props: {
    financeInfo: Object,
  },
};
</script>
