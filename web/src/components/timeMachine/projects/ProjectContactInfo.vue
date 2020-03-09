<template>
  <v-layout row wrap>
    <v-form id="projectSponsor projectLead" ref="projectContact" v-model="valid" lazy-validation>
      <v-flex md12>
        <div class="v-form-container">
          <v-text-field
            :rules="requiredRule"
            :class="inputClass"
            :label="contactNameLabel"
            v-model="form.fullName"
          ></v-text-field>
        </div>
      </v-flex>
      <v-flex md12>
        <div class="v-form-container">
          <v-text-field
            :rules="emailRules"
            :class="inputClass"
            label="Email Address"
            v-model="form.email"
          ></v-text-field>
        </div>
      </v-flex>
      <v-flex md12>
        <div class="v-form-container">
          <v-text-field
            :rules="requiredRule"
            :class="inputClass"
            label="Organization"
            v-model="form.orgName"
          ></v-text-field>
        </div>
      </v-flex>
      <v-flex md12>
        <div class="v-form-container">
          <v-text-field
            :rules="requiredRule"
            :class="inputClass"
            label="Position Title"
            v-model="form.orgPosition"
          ></v-text-field>
        </div>
      </v-flex>
      <v-flex md12>
        <div class="v-form-container">
          <v-text-field
            :rules="phoneRule"
            :class="inputClass"
            label="Phone Number"
            mask="phone"
            v-model="form.phoneNumber"
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
  props: {
    contact: Object,
    contactNameLabel: String,
    isRequired: Boolean,
  },
  data() {
    const form = Object.assign({}, new ContactDto(), this.$props.contact);
    return {
      valid: true,
      requiredRule: this.$props.isRequired
        ? [v => !!v || 'This field is required']
        : [],
      emailPattern: /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/,
      emailRules: this.$props.isRequired
        ? [
          v => !!v || 'This field is required',
          v => this.emailPattern.test(v) || 'Email must be valid',
        ]
        : [v => this.emailPattern.test(v) || 'Email must be valid'],
      phoneRule: [
        v => !!v || 'This field is required',
        v => v.length >= 10 || 'Invalid Phone',
      ],

      contactInformation: this.$store.state.contactInformation,
      // Initialize using props
      form: { ...form },
      inputClass: this.$props.isRequired ? 'required' : '',
    };
  },
  watch: {
    valid(newVal) {
      this.$store.state.contactInformation = newVal;
    },
    date() {
      this.dateFormatted = this.formatDate(this.date);
    },
    contact(value) {
      this.form = value || new ContactDto();
    } },
  methods: {
    onNextClicked() {
      if (this.$refs.projectContact.validate())
      { 
      this.$store.state.contactInformation = true;
         // this.$emit('next');
      }
      else {
         this.$store.state.contactInformation = false;
      }
      return this.$store.state.contactInformation;
    },
    reset() {
      this.$refs.projectContact.reset();
    },
    Validate() {
      this.$refs.projectContact.validate();
    },
  },
};
</script>
