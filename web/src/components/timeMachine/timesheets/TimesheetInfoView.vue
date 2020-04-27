<template>
  <div>
    <v-form>
      <v-container>
        <v-layout>
          <v-flex md12 column>
            <template>
              <spinner ref="spinner"></spinner>
              <v-card>
                <v-card-text>
                  <label class="sub-header-large">Timesheet Basic Info</label>

                  <v-layout column py-2>
                    <v-layout>
                      <v-flex md6>
                        <div class="body-1">Project Name:</div>
                      </v-flex>
                      <v-flex md6 justify-center>
                        <div class="body-2">qqqqqqqqq</div>
                      </v-flex>
                    </v-layout>
                    <v-layout>
                      <v-flex md6>
                        <div class="body-1">MOU Amount:</div>
                      </v-flex>
                      <v-flex md6 justify-center>
                        <div class="body-2">$23423.32</div>
                      </v-flex>
                    </v-layout>

                    <v-layout>
                      <v-flex md6>
                        <div class="body-1">Currently Billed:</div>
                      </v-flex>
                      <v-flex md6 justify-center>
                        <div class="body-2">$36534.34</div>
                      </v-flex>
                    </v-layout>

                    <v-layout>
                      <v-flex md6>
                        <div class="body-1">MOU:</div>
                      </v-flex>
                      <v-flex md6 justify-center>
                        <div class="body-2">her is mou name</div>
                      </v-flex>
                    </v-layout>
                    <v-layout>
                      <v-flex md6>
                        <div class="body-1">Project RFX:</div>
                      </v-flex>
                      <v-flex md6 justify-center>
                        <div class="body-2">her is RFX name</div>
                      </v-flex>
                    </v-layout>
                    <!-- <v-layout>
      <v-flex md6>
        <div class="body-1">MOU Amount:</div>
      </v-flex>
      <v-flex md6 justify-center>
        <div class="body-2">{{ form.mouAmount }}</div>
      </v-flex>
                    </v-layout>-->

                    <v-layout>
                      <v-flex md6>
                        <div class="body-1">Date From:</div>
                      </v-flex>
                      <v-flex md6 justify-center>
                        <div class="body-2">to date value</div>
                      </v-flex>
                    </v-layout>

                    <v-layout>
                      <v-flex md6>
                        <div class="body-1">Date To:</div>
                      </v-flex>
                      <v-flex md6 justify-center>
                        <div class="body-2">to date value</div>
                      </v-flex>
                    </v-layout>
                  </v-layout>
                </v-card-text>
              </v-card>
              <v-card>
                <v-card-text>
                  <label class="sub-header-large">Billable Information</label>
                </v-card-text>
                <v-layout>
                 <v-flex d-flex justify-end>
                    <v-flex md3>
                      <div class="body-2">Day</div>
                    </v-flex>
                    <v-flex md3 justify-center>
                      <div class="body-2">Hours</div>
                    </v-flex>
                    <v-flex md6 justify-center>
                      <div class="body-2">Description</div>
                    </v-flex>
                  </v-flex>
                </v-layout>
              
                <v-layout
                  v-for="(item, index) in $store.state.timesheetById.timesheetEntries"
                  :key="item.id"
                >
                  <v-flex d-flex justify-end>
                    <v-flex md3>
                      <div class="body-1">{{dayValues[index]}}</div>
                    </v-flex>
                    <v-flex md6 justify-center>
                      <div class="body-1">{{item.hoursBillable}}</div>
                    </v-flex>
                    <v-flex md6 justify-center>
                      <div class="body-1">{{item.commentsBillable}}</div>
                    </v-flex>
                  </v-flex>
                </v-layout>
                <v-card-text>
                  <label class="sub-header-large">Expense Information</label>
                </v-card-text>
                  <v-layout>
                 <v-flex d-flex justify-end>
                    <v-flex md3>
                      <div class="body-2">Day</div>
                    </v-flex>
                    <v-flex md3 justify-center>
                      <div class="body-2">Amount</div>
                    </v-flex>
                    <v-flex md3 justify-center>
                      <div class="body-2">Category</div>
                    </v-flex>
                    <v-flex md3 justify-center>
                      <div class="body-2">Description</div>
                    </v-flex>
                  </v-flex>
                </v-layout>
                <v-layout
                  v-for="(item, index) in $store.state.timesheetById.timesheetEntries"
                  :key="item.id"
                >
                  <v-flex d-flex justify-end>
                    <v-flex md3>
                      <div class="body-1">{{dayValues[index]}}</div>
                    </v-flex>
                    <v-flex md3 justify-center>
                      <div class="body-1">{{item.expenseAmount}}</div>
                    </v-flex>
                    <v-flex md3 justify-center>
                      <div class="body-1">{{item.expenseCategory}}</div>
                    </v-flex>
                     <v-flex md3 justify-center>
                      <div class="body-1">{{item.expenseComment}}</div>
                    </v-flex>
                  </v-flex>
                </v-layout>
                <v-card-text>
                  <label class="sub-header-large">Revenue Information</label>
                </v-card-text>
                 <v-layout>
                 <v-flex d-flex justify-end>
                    <v-flex md3>
                      <div class="body-2">Day</div>
                    </v-flex>
                    <v-flex md3 justify-center>
                      <div class="body-2">Amount</div>
                    </v-flex>
                    <v-flex md6 justify-center>
                      <div class="body-2">Description</div>
                    </v-flex>
                  </v-flex>
                </v-layout>
               
                <v-layout
                  v-for="(item, index) in $store.state.timesheetById.timesheetEntries"
                  :key="item.id"
                >
                  <v-flex d-flex justify-end>
                    <v-flex md3>
                      <div class="body-1">{{dayValues[index]}}</div>
                    </v-flex>
                    <v-flex md6 justify-center>
                      <div class="body-1">{{item.revenueAmount}}</div>
                    </v-flex>
                    <v-flex md6 justify-center>
                      <div class="body-1">{{item.revenueComment}}</div>
                    </v-flex>
                  </v-flex>
                </v-layout>
                <v-card-text>
                  <label class="sub-header-large">UnBillable Information</label>
                </v-card-text>
                <v-layout>
                 <v-flex d-flex justify-end>
                    <v-flex md3>
                      <div class="body-2">Day</div>
                    </v-flex>
                    <v-flex md3 justify-center>
                      <div class="body-2">Hours</div>
                    </v-flex>
                    <v-flex md6 justify-center>
                      <div class="body-2">Description</div>
                    </v-flex>
                  </v-flex>
                </v-layout>
                <v-layout
                  v-for="(item, index) in $store.state.timesheetById.timesheetEntries"
                  :key="item.id"
                >
                  <v-flex d-flex justify-end>
                    <v-flex md3>
                      <div class="body-1">{{dayValues[index]}}</div>
                    </v-flex>
                    <v-flex md6 justify-center>
                      <div class="body-1">{{item.hoursUnBillable}}</div>
                    </v-flex>
                    <v-flex md6 justify-center>
                      <div class="body-1">{{item.commentsUnBillable}}</div>
                    </v-flex>
                  </v-flex>
                </v-layout>
              </v-card>
            </template>
          </v-flex>
        </v-layout>
      </v-container>
    </v-form>
  </div>
</template>

<script>
import Spinner from "../common/Spinner.vue";
// import IntakeBaseInfoView from './IntakeBaseInfoView.vue';
// import MinistryBranchInfoView from '../common/MinistryBranchInfoView.vue';
// import './intakeformview.styl';
// import ProjectContactInfoView from '../projects/ProjectContactInfoView.vue';
// import ProjectAdditionalContactInfoView from '../projects/ProjectAdditionalContactInfoView.vue';

export default {
  components: {
    Spinner
    // IntakeBaseInfoView,
    // MinistryBranchInfoView,
    // ProjectContactInfoView,
    // ProjectAdditionalContactInfoView,
  },
  props: {
    id: String
  },
  data() {
    return {
      dayValues: [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sundat"
      ]
    };
  },
  computed: {},
  methods: {
    fetchUser() {
      const referenceId = this.$store.state.activeUser.refId;
      const user = this.$store.state.users.find(
        value => value.referenceId === referenceId
      );
      return user.id;
    },
    async fetchData() {
      const { params } = this.$router.currentRoute;
      const id = params.id || this.$props.id;
      // const userid = this.fetchUser();
    },
    isEnabled(infoType) {
      const contacts = this.$store.state.activeIntakeRequest.contacts || [];
      const clientInfo = contacts.find(
        contact => contact.contactType === infoType
      );
      if (clientInfo) return true;
      return false;
    },
    getClientInfo(infoType) {
      const contacts = this.$store.state.activeIntakeRequest.contacts || [];
      const clientInfo = contacts.find(
        contact => contact.contactType === infoType
      );
      // if (contacts.length > 2) this.enabled = true;
      // else this.enabled = false;
      return clientInfo;
    }
  },
  created() {
    // this.fetchData();
  }
};
</script>

<style>
legend {
  margin-left: 1em;
}
</style>
