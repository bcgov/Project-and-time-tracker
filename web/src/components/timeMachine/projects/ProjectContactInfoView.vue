<template>
  <v-layout column>
    <v-layout>
      <v-flex md4>
        <div class="body-1">Contact Name:</div>
      </v-flex>
      <v-flex md8>
        <div class="body-2">{{form.fullName}}</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md4>
        <div class="body-1">Email Address:</div>
      </v-flex>
      <v-flex md8>
        <div class="body-2">{{form.email}}</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md4>
        <div class="body-1">Organization:</div>
      </v-flex>
      <v-flex md8>
        <div class="body-2">{{form.orgName}}</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md4>
        <div class="body-1">Position Title:</div>
      </v-flex>
      <v-flex md8>
        <div class="body-2">{{form.orgPosition}}</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md4>
        <div class="body-1">Phone Number:</div>
      </v-flex>
      <v-flex md8>
        <div class="body-2">{{form.phoneNumber}}</div>
      </v-flex>
    </v-layout>
  </v-layout>
</template>

<script>
import ContactDto from '@/domain/models/Contact.dto';
import './projectcontactinfo.styl';

export default {
  props: {
    contact: Object,
  },
  data() {
    const form = Object.assign({}, new ContactDto(), this.$props.contact);
    return {
      contactInformation: this.$store.state.contactInformation,
      // Initialize using props
      form: { ...form },
    };
  },
  watch: {
    contact(value) {
      this.form = value || new ContactDto();
    },
  },
};
</script>
