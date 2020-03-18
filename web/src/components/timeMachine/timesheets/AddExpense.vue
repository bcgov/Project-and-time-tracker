 <template>
  <v-layout row justify-center>
    <snackbar ref="snackbar"></snackbar>

      <v-form ref="form" v-model="valid" lazy-validation   id="add-expense" class="add-expense"
     >
        <spinner ref="spinner"></spinner>

        <v-container grid-list-xl>
          <v-layout row wrap>
            <v-flex md1>
             Day
            </v-flex>
            <v-flex md2>
             Hours
            </v-flex>

  <v-flex md3>
            Category
            </v-flex>

            <v-flex md5>
            Description
            </v-flex>
            <v-flex md1>

            </v-flex>
          </v-layout>

           <v-layout v-for="item in weekData" :key="item.day" class="time-records">
            <v-flex md1>
             {{item.day}}
            </v-flex>
            <v-flex md2>
               <v-text-field v-model="item.hours"></v-text-field>
            </v-flex>


            <v-flex md3>
              <v-text-field v-model="item.category"></v-text-field>
            </v-flex>
            <v-flex md5>
              <v-text-field v-model="item.description"></v-text-field>
            </v-flex>
            <v-flex md1>
               <i class="material-icons">file_copy</i>
               <i class="material-icons">post_add</i>
            </v-flex>
          </v-layout>


        </v-container>
      </v-form>

  </v-layout>
</template>
<script>


import './AddExpense.styl';
import moment from 'moment';
import Snackbar from '../common/Snackbar.vue';
import Spinner from '../common/Spinner.vue';

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
    },
  },
  components: {
    Snackbar,
    Spinner,

  },
  data() {
    const form = Object.assign({}, this.$props.expenseEntry);
    if (!form.date) {
      form.date = moment().format('YYYY-MM-DD');
    }
    return {
      valid: true,
      requiredRule: [v => !!v || 'This field required'],
      requireRadioButtondRule: [
        v => ((v || !v) && v != null) || 'This field required',
      ],
      dialog: false,
      menu1: false,
      form: { ...form },
      dateFormatted: undefined,
      existingTimeEntries: [],
      addRecordLoading: false,
      //  weekData: {MondayHours:''}
      weekData: this.singleRow ? [{ day: 'Day', description: '', hours: '', category: '', date: '01-03-2020' }] : [{ day: 'Mon', description: '', hours: '', category: '', date: '01-03-2020' },
        { day: 'Tue', description: '', hours: '', category: '', date: '2-3-2020' },
        { day: 'Wed', description: '', hours: '', category: '', date: '2-3-2020' },
        { day: 'Thu', description: '', hours: '', category: '', date: '2-3-2020' },
        { day: 'Fri', description: '', hours: '', category: '', date: '2-3-2020' },
        { day: 'Sat', description: '', hours: '', category: '', date: '2-3-2020' },
        { day: 'Sun', description: '', hours: '', category: '', date: '2-3-2020' },
      ],
    };
  },
  watch: {
    date() {
      this.dateFormatted = this.formatDate(this.date);
    },
    project(val) {
      this.$store.dispatch('fetchProjectRfx', { id: val });
    },
  },
  props: {
    expenseEntry: Object,
    singleRow: Boolean,
    AddExpense: {
      type: Function,
      default: () => {},
    },
    ExpenseEntry: {
      type: Function,
      default: () => {},
    },
  },
  created() {
    this.form.date = moment().format('YYYY-MM-DD');

    const referenceId = JSON.parse(localStorage.getItem('keycloak_user')).sub;
    const user = this.$store.state.users.find(
      value => value.referenceId === referenceId,
    );
    if (user && user.id) {
      this.form.userId = user.id;
    }
    // setTimeout(() => {
    //   document.getElementsByClassName(
    //     'v-dialog v-dialog--active',
    //   )[0].scrollTop = 0;
    // }, 400);
  },
  methods: {

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
      this.$refs.snackbar.displayMultipleErrorSnackbar('error', errorList);
    },
  },
};
</script>
