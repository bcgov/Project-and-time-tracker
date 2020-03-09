<template>
<div class="review-submit">
  <v-expansion-panel v-bind:value="0">
    <v-expansion-panel-content>
      <template v-slot:header>
        <div class="panel-header">Project Information</div>
      </template>
      <v-card>
        <v-card-text class="pl-4">
          <v-flex>
            <v-flex sm12><h4>Project Name</h4></v-flex>
            <v-flex sm12>{{ $props.intakeValues.projectName }}</v-flex>
          </v-flex>
          <v-flex>
            <v-flex sm12><h4>Project Sector</h4></v-flex>
            <!-- <v-flex sm12>{{ $props.intakeValues.projectSector.projectSectorName }}</v-flex> -->
          </v-flex>
          <v-flex>
            <v-flex sm12><h4>Commodity Code</h4></v-flex>
            <v-flex sm12>{{ $props.intakeValues.commodityCode }}</v-flex>
          </v-flex>
          <v-flex>
            <v-flex sm12><h4>Required Date of Completion</h4></v-flex>
            <v-flex sm12>{{ $props.intakeValues.estimatedCompletionDate }}</v-flex>
          </v-flex>
          <v-flex>
            <v-flex sm12><h4>Desired Date of Completion</h4></v-flex>
            <v-flex sm12>---</v-flex>
          </v-flex>
          <v-flex>
            <v-flex sm12><h4>Is this project a Reprocurement?</h4></v-flex>
            <v-flex sm12>{{ $props.intakeValues.chkReprocurement }}</v-flex>
          </v-flex>
          <v-flex v-if="$props.intakeValues.chkReprocurement">
            <v-flex>
              <v-flex sm12><h4>Date of Reprocurement</h4></v-flex>
              <v-flex sm12>{{ $props.intakeValues.projectName }}</v-flex>
            </v-flex>
            <v-flex>
              <v-flex sm12><h4>What is the background from the previous contract?</h4></v-flex>
              <v-flex sm12>{{ $props.intakeValues.projectName }}</v-flex
              ><!-- Parameter not known -->
            </v-flex>
            <v-flex>
              <v-flex sm12><h4>What is the potential impact if this project fails?</h4></v-flex>
              <v-flex sm12>{{ $props.intakeValues.projectFailImpact }}</v-flex>
            </v-flex>
            <v-flex>
              <v-flex sm12><h4>What does success look like for this project?</h4></v-flex>
              <v-flex sm12>{{ $props.intakeValues.projectSuccess }}</v-flex>
            </v-flex>
          </v-flex>
        </v-card-text>
      </v-card>
    </v-expansion-panel-content>
    <v-expansion-panel-content>
      <template v-slot:header>
        <div class="panel-header">Ministry/Branch Information</div>
      </template>
      <v-card>
        <v-card-text class="pl-4">
          <v-flex sm12><h4>Ministry</h4></v-flex>
          <!-- <v-flex sm12>{{ $props.intakeValues.client.ministryName }}</v-flex> -->
          <v-flex sm12><h4>Branch</h4></v-flex>
          <v-flex sm12>{{ $props.intakeValues.projectName }}</v-flex>
          <v-flex sm12><h4>Address</h4></v-flex>
          <v-flex sm12>
            <!-- {{ $props.intakeValues.client.contacts.addressLine1 }}+','+{{ $props.intakeValues.client.contacts.addressLine2}}+','+{{$props.intakeValues.client.contacts.city}}+','+{{$props.intakeValues.client.contacts.province}}+','+{{$props.intakeValues.client.contacts.country}}+','+{{$props.intakeValues.client.contacts.postalCode}} -->
          </v-flex>
        </v-card-text>
      </v-card>
    </v-expansion-panel-content>
    <v-expansion-panel-content>
      <template v-slot:header>
        <div class="panel-header">Risk Assessment</div>
      </template>
      <v-card>
        <v-card-text class="pl-4">
          <!-- Content to be added -->
        </v-card-text>
      </v-card>
    </v-expansion-panel-content>
    <v-expansion-panel-content>
      <template v-slot:header>
        <div class="panel-header">Contact Information</div>
      </template>
      <v-card>
        <v-card-text class="pl-4">
          <v-flex sm12><h3>Client Lead</h3></v-flex>
          <v-flex sm12><h4>Name</h4></v-flex>
          <v-flex sm12><span v-if="$props.intakeValues.contacts">{{ $props.intakeValues.contacts.fullName }}</span></v-flex>
          <v-flex sm12><h4>Email</h4></v-flex>
          <v-flex sm12><span v-if="$props.intakeValues.contacts">{{ $props.intakeValues.contacts.email }}</span></v-flex>
          <v-flex sm12><h4>Organization</h4></v-flex>
          <v-flex sm12><span v-if="$props.intakeValues.contacts">{{ $props.intakeValues.contacts.orgName }}</span></v-flex>
          <v-flex sm12><h4>Position Title</h4></v-flex>
          <v-flex sm12><span v-if="$props.intakeValues.contacts">{{ $props.intakeValues.contacts.orgPosition }}</span></v-flex>
          <v-flex sm12><h4>Phone Number</h4></v-flex>
          <v-flex sm12><span v-if="$props.intakeValues.contacts">{{ $props.intakeValues.contacts.phoneNumber }}</span></v-flex>
        </v-card-text>
      </v-card>
    </v-expansion-panel-content>
  </v-expansion-panel>
  </div>
</template>
<script>
import './intakeRisk.styl';
import './intakeReviewSubmit.styl';

export default {
  components: {},
  props: {
    intakeValues: {},
  },
  computed: {},

  mounted() {

  },
  data() {
    const form = Object.assign({}, this.$props.intakeValues);
    return {
      form: { ...form },
    };
  },
  watch: {},

  methods: {},
};
</script>
