<template>
  <v-layout row wrap>
    <v-flex sm12>
      <div class="v-form-container">
        <v-text-field
          :rules="requiredRule"
          class="required"
          label="Address Line 1"
          v-model="contact.addressLine1"
        ></v-text-field>
      </div>
    </v-flex>
    <v-flex sm12>
      <div class="v-form-container">
        <v-text-field
          label="Address Line 2"
          v-model="contact.addressLine2"
        ></v-text-field>
      </div>
    </v-flex>
    <v-flex sm6>
      <div class="v-form-container">
        <v-text-field
          :rules="requiredRule"
          class="required"
          label="City"
          v-model="contact.city"
        >
        </v-text-field>
      </div>
    </v-flex>
    <v-flex sm6>
      <div class="v-form-container">
        <v-text-field
          :rules="requiredRule"
          class="required"
          label="Postal"
          v-model="contact.postalCode"
        ></v-text-field>
      </div>
    </v-flex>
  </v-layout>
</template>

<script>
export default {
  props: {
    contact: Object,
  },
  data() {
    return {
      valid: true,
      requiredRule: [v => !!v || 'This field is required'],
    };
  },
};
</script>
