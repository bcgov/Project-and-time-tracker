<template>
  <v-layout row justify-center class="proc-layout">
    <snackbar ref="snackbar"></snackbar>
    <v-dialog id="newNote" class="proc-dialgue" max-width="40%" v-model="dialog">
      <v-form ref="newNotes" v-model="valid" lazy-validation>
        <spinner ref="spinner"></spinner>
        <v-card style="width:100%">
          <v-card-text class="card-contents">
            <v-layout row wrap>
            <v-flex md12>
            <div style="margin-left:25%;color:#57789a;font-weight:bold">PLEASE CHOOSE A DATE RANGE</div>
            </v-flex>
              <v-flex md12>
                <div class="v-form-container">
                  <v-menu
                    v-model="menu1"
                    :close-on-content-click="false"
                    :nudge-right="40"
                    lazy
                    transition="scale-transition"
                    offset-y
                    full-width
                    max-width="290px"
                    min-width="290px"
                  >
                    <template v-slot:activator="{ on }">
                      <v-text-field
                        class="required"
                        readonly
                        v-model="startDate"
                        label="Start Date"
                        persistent-hint
                        prepend-inner-icon="event"
                        @blur="date = parseDate(dateFormatted)"
                        v-on="on"
                      ></v-text-field>
                    </template>
                    <v-date-picker
                      v-model="startDate"
                      no-title
                      @input="menu1 = false"
                    ></v-date-picker>
                  </v-menu>
                </div>
              </v-flex>
               <v-flex md12>
                <div class="v-form-container">
                  <v-menu
                    v-model="menu2"
                    :close-on-content-click="false"
                    :nudge-right="40"
                    lazy
                    transition="scale-transition"
                    offset-y
                    full-width
                    max-width="290px"
                    min-width="290px"
                  >
                    <template v-slot:activator="{ on }">
                      <v-text-field
                        class="required"
                        readonly
                        v-model="endDate"
                        label="End Date"
                        persistent-hint
                        prepend-inner-icon="event"
                        @blur="date = parseDate(dateFormatted)"
                        v-on="on"
                      ></v-text-field>
                    </template>
                    <v-date-picker
                      v-model="endDate"
                      no-title
                      @input="menu2 = false"
                    ></v-date-picker>
                  </v-menu>
                </div>
              </v-flex>
              <v-flex md12>
                <v-flex d-flex justify-end>
                  <v-btn class="add-log-button" color="btnPrimary" dark @click="exportCSV()"
                    >EXPORT TIMESHEET</v-btn
                  >
                </v-flex>
              </v-flex>
            </v-layout>
          </v-card-text>
        </v-card>
      </v-form>
    </v-dialog>
  </v-layout>
</template>
<script>
// import moment from 'moment';
import Snackbar from '../common/Snackbar.vue';
import Spinner from '../common/Spinner.vue';

export default {
  computed: {
    projectRfx() {
      return this.$store.state.activeProjectRfxData;
    },
  },
  components: {
    Snackbar,
    Spinner,
  },
  data() {
    return this.initData();
  },
  watch: {},
  props: {
    timeEntry: Object,
  },
  methods: {
    parseDate(date) {
      if (!date) return null;
      const [month, day, year] = date.split('/');
      return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
    },
    open(value, name) {
      this.replyNoteName = name;
      this.flag = value;
      this.dialog = true;
      setTimeout(() => {
        document.getElementsByClassName('v-dialog v-dialog--active')[0].scrollTop = 0;
      }, 400);
    },
    exportCSV() {
      this.$emit('exportTimeSheets', this.startDate, this.endDate);
      this.dialog = false;
    },
    reset() {
      // this.$refs.form.resetValidation();
      // const data = this.initData();
    },
    initData() {
      const form = Object.assign({}, this.$props.timeEntry);
      form.userId = this.$store.state.activeUser.id;
      return {
        flag: undefined,
        valid: true,
        menu1: false,
        dateFormatted: undefined,
        menu2: false,
        requiredRule: [v => !!v || 'This field required'],
        requireRadioButtondRule: [v => ((v || !v) && v != null) || 'This field required'],
        dialog: false,
        startDate: undefined,
        endDate: undefined,
      };
    },
  },
};
</script>
<style scoped>
.replyheaderdiv {
  background-color: gainsboro;
}

.replytoheader {
  margin-left: 40px;
  font-size: medium;
  font-weight: 600;
}
.add-log-button {
  width: 150px;
  flex: 0 0 200px !important;
  margin-right: 3%;
}
.primary-heading {
  margin-top: 10px !important;
}
.v-dialog:not(.v-dialog--fullscreen) {
  max-width: 40%;
  max-height: 90%;
}
</style>
