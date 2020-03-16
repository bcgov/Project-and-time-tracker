<template>
  <v-layout row wrap>
    <v-form id="clientcontact" ref="projectContact">
      <v-flex md12>
        <div class="v-form-container">
          <v-text-field label="Role Name" v-model="form.contactType"></v-text-field>
        </div>
      </v-flex>
      <v-flex md12>
        <div class="v-form-container">
          <v-text-field :label="contactNameLabel" v-model="form.fullName"></v-text-field>
        </div>
      </v-flex>
      <v-flex md12>
        <div class="v-form-container">
          <v-text-field
            label="Email Address"
            :error-messages="emailError()"
            v-model="form.email"
          ></v-text-field>
        </div>
      </v-flex>
      <v-flex md12>
        <div class="v-form-container">
          <v-text-field label="Organization" v-model="form.orgName"></v-text-field>
        </div>
      </v-flex>
      <v-flex md12>
        <div class="v-form-container">
          <v-text-field label="Position Title" v-model="form.orgPosition"></v-text-field>
        </div>
      </v-flex>
      <v-flex md12>
        <div class="v-form-container">
          <v-text-field
            label="Phone Number"
            :error-messages="phoneError()"
            v-model="form.phoneNumber"
            mask="phone"
          ></v-text-field>
        </div>
      </v-flex>
    </v-form>
  </v-layout>
</template>

<script>
import ContactDto from '@/domain/models/Contact.dto';

import './projectcontactinfo.styl';

export default {
  components: {},
  props: { contact: Object, contactNameLabel: String },
  data() {
    const form = Object.assign({}, new ContactDto(), this.$props.contact);
    return { form: { ...form } };
  },
  watch: {
    date() {
      this.dateFormatted = this.formatDate(this.date);
    },
    contact(value) {
      this.form = value || new ContactDto();
    },
  },
  methods: {
    emailError() {
      const emailPattern = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      if (this.form.email && this.form.email.length > 0) {
        if (emailPattern.test(this.form.email)) return '';
        return 'Email must be valid';
      }
      return '';
    },
    phoneError() {
      if (this.form.phoneNumber && this.form.phoneNumber.length > 0) {
        if (this.form.phoneNumber.length >= 10) return '';
        return 'Invalid Phone';
      }
      return '';
    },
    reset() {
      this.$refs.projectContact.reset();
      this.form.phoneNumber = '';
    },
  },
};
</script>
