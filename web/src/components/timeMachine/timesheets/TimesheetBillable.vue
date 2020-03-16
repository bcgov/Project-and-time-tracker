 <template>
  <v-layout row justify-center>
    <snackbar ref="snackbar"></snackbar>
    <v-dialog id="AddExpense" class="timesheet-billable" v-model="dialog" max-width="65%">
      <v-form ref="form" v-model="valid" lazy-validation>
        <spinner ref="spinner"></spinner>

        <v-container grid-list-xl>
          <v-layout row wrap>
            <v-flex md2>
              <v-card>
                <v-card-text>Day</v-card-text>
              </v-card>
            </v-flex>
            <v-flex md2>
              <v-card>
                <v-card-text>Hours</v-card-text>
              </v-card>
            </v-flex>
             
            <v-flex md6>
              <v-card>
                <v-card-text>Description</v-card-text>
              </v-card>
            </v-flex>
            <v-flex md2>
              <v-card>
                <v-card-text>Action</v-card-text>
              </v-card>
            </v-flex>
          </v-layout>

          <v-layout row wrap>
            <v-flex md2>
              <v-card>
                <v-card-text>Mon</v-card-text>
              </v-card>
            </v-flex>
            <v-flex md2>
              <v-card>
                <v-card-text>
                  <v-text-field v-model="weekData[0].hours"></v-text-field>
                </v-card-text>
              </v-card>
            </v-flex>
            
            <v-flex md6>
              <v-card>
                <v-card-text>
                  <v-text-field v-model="weekData[0].description"></v-text-field>
                </v-card-text>
              </v-card>
            </v-flex>
            <v-flex md2>
              <v-card>
                <v-card-text>
                  <i class="material-icons">file_copy</i>
                  <i class="material-icons">post_add</i>
                </v-card-text>
              </v-card>
            </v-flex>
          </v-layout>

          <v-layout row wrap>
            <v-flex md2>
              <v-card>
                <v-card-text>Tue</v-card-text>
              </v-card>
            </v-flex>
            <v-flex md2>
              <v-card>
                <v-card-text>
                   <v-text-field v-model="weekData[1].hours"></v-text-field>
                </v-card-text>
              </v-card>
            </v-flex>
            
            <v-flex md6>
              <v-card>
                <v-card-text>
                 <v-text-field v-model="weekData[1].description"></v-text-field>
                </v-card-text>
              </v-card>
            </v-flex>
            <v-flex md2>
              <v-card>
                <v-card-text>
                  <i class="material-icons">file_copy</i>
                  <i class="material-icons">post_add</i>
                </v-card-text>
              </v-card>
            </v-flex>
          </v-layout>

          <v-layout row wrap>
            <v-flex md2>
              <v-card>
                <v-card-text>Wed</v-card-text>
              </v-card>
            </v-flex>
            <v-flex md2>
              <v-card>
                <v-card-text>
                <v-text-field v-model="weekData[2].hours"></v-text-field>
                </v-card-text>
              </v-card>
            </v-flex>
           
            <v-flex md6>
              <v-card>
                <v-card-text>
                  <v-text-field v-model="weekData[2].description"></v-text-field>
                </v-card-text>
              </v-card>
            </v-flex>
            <v-flex md2>
              <v-card>
                <v-card-text>
                  <i class="material-icons">file_copy</i>
                  <i class="material-icons">post_add</i>
                </v-card-text>
              </v-card>
            </v-flex>
          </v-layout>

          <v-layout row wrap>
            <v-flex md2>
              <v-card>
                <v-card-text>Thu</v-card-text>
              </v-card>
            </v-flex>
            <v-flex md2>
              <v-card>
                <v-card-text>
                <v-text-field v-model="weekData[3].hours"></v-text-field>
                </v-card-text>
              </v-card>
            </v-flex>
            
            <v-flex md6>
              <v-card>
                <v-card-text>
                  <v-text-field v-model="weekData[3].description"></v-text-field>
                </v-card-text>
              </v-card>
            </v-flex>
            <v-flex md2>
              <v-card>
                <v-card-text>
                  <i class="material-icons">file_copy</i>
                  <i class="material-icons">post_add</i>
                </v-card-text>
              </v-card>
            </v-flex>
          </v-layout>

          <v-layout row wrap>
            <v-flex md2>
              <v-card>
                <v-card-text>Fri</v-card-text>
              </v-card>
            </v-flex>
            <v-flex md2>
              <v-card>
                <v-card-text>
                 <v-text-field v-model="weekData[4].hours"></v-text-field>
                </v-card-text>
              </v-card>
            </v-flex>
             
            <v-flex md6>
              <v-card>
                <v-card-text>
                  <v-text-field v-model="weekData[4].description"></v-text-field>
                </v-card-text>
              </v-card>
            </v-flex>
            <v-flex md2>
              <v-card>
                <v-card-text>
                  <i class="material-icons">file_copy</i>
                  <i class="material-icons">post_add</i>
                </v-card-text>
              </v-card>
            </v-flex>
          </v-layout>

          <v-layout row wrap>
            <v-flex md2>
              <v-card>
                <v-card-text>Sat</v-card-text>
              </v-card>
            </v-flex>
            <v-flex md2>
              <v-card>
                <v-card-text>
                 <v-text-field v-model="weekData[5].hours"></v-text-field>
                </v-card-text>
              </v-card>
            </v-flex>
            
            <v-flex md6>
              <v-card>
                <v-card-text>
                  <v-text-field v-model="weekData[5].description"></v-text-field>
                </v-card-text>
              </v-card>
            </v-flex>
            <v-flex md2>
              <v-card>
                <v-card-text>
                  <i class="material-icons">file_copy</i>
                  <i class="material-icons">post_add</i>
                </v-card-text>
              </v-card>
            </v-flex>
          </v-layout>

          <v-layout row wrap>
            <v-flex md2>
              <v-card>
                <v-card-text>Sun</v-card-text>
              </v-card>
            </v-flex>
            <v-flex md2>
              <v-card>
                <v-card-text>
               <v-text-field v-model="weekData[6].hours"></v-text-field>
                </v-card-text>
              </v-card>
            </v-flex>
          
            <v-flex md6>
              <v-card>
                <v-card-text>
                  <v-text-field v-model="weekData[6].description"></v-text-field>
                </v-card-text>
              </v-card>
            </v-flex>
            <v-flex md2>
              <v-card>
                <v-card-text>
                  <i class="material-icons">file_copy</i>
                  <i class="material-icons">post_add</i>
                </v-card-text>
              </v-card>
            </v-flex>
          </v-layout>
        </v-container>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            class="add-new-row"
            color="primary"
            @click="saveNewRow"
            :disabled="addRecordLoading"
            :loading="addRecordLoading"
          >Ok</v-btn>
          <v-btn @click="closeDialog">Cancel</v-btn>
        </v-card-actions>
      </v-form>
    </v-dialog>
  </v-layout>
</template>
<script>
import TimesheetEntryDto from "@/domain/models/TimesheetEntry.dto";
import RFxDto from "@/domain/models/RFx.dto";
import RFxPhaseDto from "@/domain/models/RFxPhase.dto";
import ProjectDto from "@/domain/models/Project.dto";

import merge from "object-merge";

import "./addnewtimerecord.styl";
import Snackbar from "../common/Snackbar.vue";
import Spinner from "../common/Spinner.vue";
import moment from "moment";

export default {
  computed: {
    computedDateFormatted() {
      return this.formatDate(this.date);
    },
    userList() {
      return this.$store.state.users;
    },
    rfxPhases() {
      return this.$store.state.rfxPhases;
    },
    rfxTypes() {
      return this.$store.state.activeProjectRfxData;
    },
    projects() {
      return this.$store.state.projects;
    }
  },
  components: {
    Snackbar,
    Spinner
  },
  data() {
    return this.initData();
  },
  watch: {
    date() {
      this.dateFormatted = this.formatDate(this.date);
    },
    project(val) {
      this.$store.dispatch("fetchProjectRfx", { id: val });
    }
  },
  props: {
    timeEntry: Object
  },
  methods: {
    open() {
      this.form.date = moment().format("YYYY-MM-DD");
      this.dialog = true;
      const referenceId = JSON.parse(localStorage.getItem("keycloak_user")).sub;
      const user = this.$store.state.users.find(
        value => value.referenceId === referenceId
      );
      if (user && user.id) {
        this.form.userId = user.id;
      }
      setTimeout(() => {
        document.getElementsByClassName(
          "v-dialog v-dialog--active"
        )[0].scrollTop = 0;
      }, 400);
    },
    closeDialog() {
      this.dialog = false;
    },
    reset() {
     // this.$refs.form.resetValidation();
      const data = this.initData();
      this.$data.valid = data.valid;
      this.$data.requiredRule = data.requiredRule;
      this.$data.requireRadioButtondRule = data.requireRadioButtondRule;
      this.$data.dialog = data.dialog;
      this.$data.menu1 = data.menu1;
      this.$data.form = data.form;
      this.$data.dateFormatted = data.dateFormatted;
      this.$data.existingTimeEntries = data.existingTimeEntries;
    },
    initData() {
      const form = Object.assign({}, this.$props.timeEntry);
      if (!form.date) {
        form.date = moment().format("YYYY-MM-DD");
      }
      const existingTimeEntries = [];
      return {
        valid: true,
        requiredRule: [v => !!v || "This field required"],
        requireRadioButtondRule: [
          v => ((v || !v) && v != null) || "This field required"
        ],
        dialog: false,
        menu1: false,
        form: { ...form },
        dateFormatted: undefined,
        existingTimeEntries,
        addRecordLoading: false,
        //  weekData: {MondayHours:''}
      weekData: [{ 'day':'Mon', 'description':'' , 'hours':'','date':'01-03-2020'},
                 { 'day':'Tue', 'description':'' , 'hours':'','date':'2-3-2020'},
                 { 'day':'Wed', 'description':'' , 'hours':'','date':'2-3-2020'},
                 { 'day':'Thu', 'description':'', 'hours':'','date':'2-3-2020'},
                 { 'day':'Fri', 'description':'', 'hours':'','date':'2-3-2020'},
                 { 'day':'Sat', 'description':'', 'hours':'','date':'2-3-2020'},
                 { 'day':'Sun', 'description':'', 'hours':'','date':'2-3-2020'}
]
      };
    },
    saveNewRow() {
      if (this.$refs.form.validate()) {
        const formData = this.form;
        formData.hour = parseFloat(formData.hour.toFixed(2));
        const payload = this.timesheetUpdatePayload(formData);
        // this.updateTimesheet(payload);
      } else {
        this.dialog = true;
      }
    },
    handleMultipleErrors(errorList) {
      this.$refs.snackbar.displayMultipleErrorSnackbar("error", errorList);
    }
  }
};
</script>
<style scoped>
.v-form-container {
  padding: none;
}
.v-dialog .v-dialog--active {
  max-width: 65% !important;
}
.container.grid-list-xl .layout .flex {
  padding: none !important;
}
.v-form .container .layout .flex .v-card {
  margin-bottom: 0px;
  padding-top: 0px;
}
.v-text-field {
  padding-top: 0px;
  margin-top: 0px;
}
</style>
