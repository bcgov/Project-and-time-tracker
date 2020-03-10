<template>
  <v-layout column>
   <v-layout>
      <v-flex md4>
        <div class="body-1">Address Line 1:</div>
      </v-flex>
      <v-flex md8>
        <div class="body-2">{{contact.addressLine1}}</div>
      </v-flex>
    </v-layout>
    <v-layout>
      <v-flex md4>
        <div class="body-1">Address Line 2:</div>
      </v-flex>
      <v-flex md8>
        <div class="body-2">{{contact.addressLine2}}</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md4>
        <div class="body-1">City:</div>
      </v-flex>
      <v-flex md8>
        <div class="body-2">{{contact.city}}</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md4>
        <div class="body-1">Postal</div>
      </v-flex>
      <v-flex md8>
        <div class="body-2">{{contact.postalCode}}</div>
      </v-flex>
    </v-layout>
  </v-layout>
</template>

<script>
export default {
  props: {
    contact: Object,
  },
  data() {
    return {};
  },
};
</script>
