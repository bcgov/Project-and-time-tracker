<template>
  <div class="review-submit">
    <v-layout row wrap py-2 class="custom-project-base-layout">
      <v-flex md12 class="intake-base-info-header">
        <span class="spanheader">Review Submit</span>
      </v-flex>
      <v-expansion-panel v-model="panelState" expand>
        <v-expansion-panel-content class="expansionpanel">
          <template v-slot:header>
            <div class="panel-header">Project Information</div>
          </template>
          <v-card>
            <v-card-text class="pl-4">
              <v-flex>
                <v-btn color="primary" @click="editItem(1)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <h4>Project Name</h4>
                </v-flex>
                <v-flex sm12>{{ $props.intakeValues.projectName }}</v-flex>
              </v-flex>
              <v-flex>
                <v-btn color="primary" @click="editItem(1)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <h4>Project Sector</h4>
                </v-flex>
                <v-flex sm12>{{ getProjectSector() }}</v-flex>
              </v-flex>
              <v-flex>
                <v-btn color="primary" @click="editItem(1)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <h4>Desired Date of Completion</h4>
                </v-flex>
                <v-flex sm12>{{ $props.intakeValues.estimatedCompletionDate }}</v-flex>
              </v-flex>
              <v-flex>
                <v-btn color="primary" @click="editItem(1)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <h4>Contract Amount</h4>
                </v-flex>
                <v-flex sm12>${{ $props.intakeValues.estimatedContractValue | withCommas }}</v-flex>
              </v-flex>
              <v-flex>
                <v-btn color="primary" @click="editItem(1)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <h4>Reprocurement?</h4>
                </v-flex>
                <v-flex sm12>{{ checkBoolenValues($props.intakeValues.isReprocurement) }}</v-flex>
              </v-flex>
              <v-flex v-if="$props.intakeValues.isReprocurement">
                <v-btn color="primary" @click="editItem(1)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <h4>Date original contract ends</h4>
                </v-flex>
                <v-flex sm12>{{ $props.intakeValues.dateOfReprocurement }}</v-flex>
              </v-flex>
              <v-flex v-if="$props.intakeValues.isReprocurement">
                <v-btn color="primary" @click="editItem(1)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <h4>What is the background from the previous contract?</h4>
                </v-flex>
                <v-flex sm12 class="parastyling">{{
                  $props.intakeValues.previousContractBackground
                }}</v-flex>
              </v-flex>
              <v-flex>
                <v-btn color="primary" @click="editItem(1)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <h4>What is the potential impact of this procurement project failing?</h4>
                </v-flex>
                <v-flex sm12 class="parastyling">{{
                  $props.intakeValues.projectFailImpact
                }}</v-flex>
              </v-flex>
              <v-flex>
                <v-btn color="primary" @click="editItem(1)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <h4>What does success look like for this procurement project?</h4>
                </v-flex>
                <v-flex sm12 class="parastyling">{{ $props.intakeValues.projectSuccess }}</v-flex>
              </v-flex>
            </v-card-text>
          </v-card>
        </v-expansion-panel-content>
        <v-expansion-panel-content class="expansionpanel">
          <template v-slot:header>
            <div class="panel-header">Ministry/Branch Information</div>
          </template>
          <v-card>
            <v-card-text class="pl-4" v-if="$props.intakeValues.client">
              <v-flex>
                <v-btn color="primary" @click="editItem(2)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <h4>Non-Ministry</h4>
                </v-flex>
                <v-flex sm12>
                  {{ checkBoolenValues($props.intakeValues.client.isNonMinistry) }}
                </v-flex>
              </v-flex>
              <v-flex>
                <v-btn color="primary" @click="editItem(2)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <h4>Ministry</h4>
                </v-flex>
                <v-flex sm12>{{ getMinistry() }}</v-flex>
              </v-flex>
              <v-flex>
                <v-btn color="primary" @click="editItem(2)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <h4>Branch</h4>
                </v-flex>
                <v-flex sm12>{{ $props.intakeValues.client.orgDivision }}</v-flex>
              </v-flex>
              <v-flex>
                <v-btn color="primary" @click="editItem(2)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <h4>Address Line 1</h4>
                </v-flex>
                <v-flex sm12>{{ $props.intakeValues.client.addressLine1 }}</v-flex>
              </v-flex>
              <v-flex>
                <v-btn color="primary" @click="editItem(2)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <h4>Address Line 2</h4>
                </v-flex>
                <v-flex sm12>{{ $props.intakeValues.client.addressLine2 }}</v-flex>
              </v-flex>
              <v-flex>
                <v-btn color="primary" @click="editItem(2)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <h4>City</h4>
                </v-flex>
                <v-flex sm12>{{ $props.intakeValues.client.city }}</v-flex>
              </v-flex>
              <v-flex>
                <v-btn color="primary" @click="editItem(2)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <h4>Postal</h4>
                </v-flex>
                <v-flex sm12>{{ $props.intakeValues.client.postalCode }}</v-flex>
              </v-flex>

              <v-flex>
                <v-btn color="primary" @click="editItem(2)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <h4>Client No.</h4>
                </v-flex>
                <v-flex sm12>{{ $props.intakeValues.client.clientNo }}</v-flex>
              </v-flex>

              <v-flex>
                <v-btn color="primary" @click="editItem(2)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <h4>Responsibility Center</h4>
                </v-flex>
                <v-flex sm12>{{ $props.intakeValues.client.responsibilityCenter }}</v-flex>
              </v-flex>

              <v-flex>
                <v-btn color="primary" @click="editItem(2)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <h4>Service Center</h4>
                </v-flex>
                <v-flex sm12>{{ $props.intakeValues.client.serviceCenter }}</v-flex>
              </v-flex>

              <v-flex>
                <v-btn color="primary" @click="editItem(2)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <h4>STOB</h4>
                </v-flex>
                <v-flex sm12>{{ $props.intakeValues.client.stob }}</v-flex>
              </v-flex>

              <v-flex>
                <v-btn color="primary" @click="editItem(2)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <h4>Project Code</h4>
                </v-flex>
                <v-flex sm12>{{ $props.intakeValues.client.projectCode }}</v-flex>
              </v-flex>
            </v-card-text>
          </v-card>
        </v-expansion-panel-content>
        <v-expansion-panel-content class="expansionpanel">
          <template v-slot:header>
            <div class="panel-header">Risk Assessment</div>
          </template>
          <v-card>
            <v-card-text class="pl-4" v-if="$props.intakeValues.risk">
              <v-flex v-for="item in $props.intakeValues.risk" :key="item.id">
                <v-btn color="primary" @click="editItem(3)" class="edit-link">edit</v-btn>
                <v-flex sm12>
                  <b>
                    <div v-html="item.question" class="question-text"></div>
                  </b>
                </v-flex>
                <v-flex sm12>{{ item.answer }}</v-flex>
              </v-flex>
            </v-card-text>
          </v-card>
        </v-expansion-panel-content>
        <v-expansion-panel-content class="expansionpanel">
          <template v-slot:header>
            <div class="panel-header">Contact Information</div>
          </template>
          <v-card>
            <v-card-text class="pl-4" v-if="$props.intakeValues.contacts">
              <v-flex
                v-for="(contactItem, index) in $props.intakeValues.contacts"
                :key="index"
                class="contacts"
              >
                <h3 v-if="contactItem.fullName">{{ getContactType(contactItem.contactType) }}</h3>
                <v-flex v-if="contactItem.fullName">
                  <v-btn color="primary" @click="editItem(4)" class="edit-link">edit</v-btn>
                  <v-flex sm12>
                    <h4>Name</h4>
                  </v-flex>
                  <v-flex sm12>{{ contactItem.fullName }}</v-flex>
                </v-flex>

                <v-flex v-if="contactItem.email">
                  <v-btn color="primary" @click="editItem(4)" class="edit-link">edit</v-btn>
                  <v-flex sm12>
                    <h4>Email Address</h4>
                  </v-flex>
                  <v-flex sm12>{{ contactItem.email }}</v-flex>
                </v-flex>

                <v-flex v-if="contactItem.orgName">
                  <v-btn color="primary" @click="editItem(4)" class="edit-link">edit</v-btn>
                  <v-flex sm12>
                    <h4>Organization</h4>
                  </v-flex>
                  <v-flex sm12>{{ contactItem.orgName }}</v-flex>
                </v-flex>

                <v-flex v-if="contactItem.orgPosition">
                  <v-btn color="primary" @click="editItem(4)" class="edit-link">edit</v-btn>
                  <v-flex sm12>
                    <h4>Position Title</h4>
                  </v-flex>
                  <v-flex sm12>{{ contactItem.orgPosition }}</v-flex>
                </v-flex>

                <v-flex v-if="contactItem.phoneNumber">
                  <v-btn color="primary" @click="editItem(4)" class="edit-link">edit</v-btn>
                  <v-flex sm12>
                    <h4>Phone Number</h4>
                  </v-flex>
                  <v-flex sm12>{{ maskPhone(contactItem.phoneNumber) }}</v-flex>
                </v-flex>
              </v-flex>
            </v-card-text>
          </v-card>
        </v-expansion-panel-content>
        <v-card class="printdiv">
          <v-btn flat icon @click="print()"> <v-icon>print</v-icon>PRINT THIS FORM </v-btn>
        </v-card>
      </v-expansion-panel>
    </v-layout>
  </div>
</template>
<script>
import './intakeReviewSubmit.styl';

export default {
  components: {},
  props: {
    intakeValues: {},
  },
  computed: {},

  mounted() {},
  data() {
    const form = Object.assign({}, this.$props.intakeValues);
    return {
      form: { ...form },
      panelState: [true],
    };
  },
  watch: {},

  methods: {
    maskPhone(e) {
      let x = e.replace(/\D/g, '').match(/(\d{3})(\d{3})(\d{4})/);
      return (x = `(${  x[1]  }) ${  x[2]  }-${  x[3]}`);
    },
    editItem(itemIndex) {
      this.$emit('switch', itemIndex);
    },
    checkBoolenValues(value) {
      if (value) {
        return 'Yes';
      }
      return 'No';
    },
    getContactType(contactType) {
      if (contactType === 'clientfinance') {
        return 'Client Finance';
      }
      if (contactType === 'clientlead') {
        return 'Client Lead';
      }
      if (contactType === 'clientsponsor') {
        return 'Client Sponsor';
      }
      if (contactType === 'clientcontact') {
        return 'Client Contact';
      }
      return '';
    },
    getProjectSector() {
      const projectSector = Object.assign({}, this.$props.intakeValues.projectSector);
      if (projectSector.id) {
        const sector = this.$store.state.projectSectors.filter(
          item => item.id === projectSector.id,
        );
        if (sector[0]) {
          return sector[0].projectSectorName;
        }
      } else if (this.$props.intakeValues.otherProjectSectorName) {
        return this.$props.intakeValues.otherProjectSectorName;
      }
      return '';
    },
    getMinistry() {
      if (this.$props.intakeValues.client.isNonMinistry) {
        return this.$props.intakeValues.client.nonMinistryName
          ? this.$props.intakeValues.client.nonMinistryName
          : '';
      }
      const ministry = Object.assign({}, this.$props.intakeValues.client.ministry);
      if (ministry.id) {
        const selectedMinistry = this.$store.state.ministries.filter(
          item => item.id === ministry.id,
        );
        if (selectedMinistry[0]) {
          return selectedMinistry[0].ministryName;
        }
      }
      return '';
    },
    print() {
      this.expandAll();
      setTimeout(window.print, 500);
    },
    expandAll() {
      this.panelState = [true, true, true, true, true];
    },
  },
};
</script>
<style scoped>
.review-submit .v-expansion-panel {
  display: block !important;
}
@media print {
  .application--wrap > aside {
    display: none;
  }
}
.parastyling {
  white-space: pre-line;
}
.expansionpanel {
  margin-left: 30px;
  width: 95%;
}
.printdiv {
  margin-left: 7%;
}
.spanheader {
  text-align: center;
  display: block;
}
</style>
