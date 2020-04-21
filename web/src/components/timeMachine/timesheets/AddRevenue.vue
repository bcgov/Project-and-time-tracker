<template>
  <v-layout row justify-center>
    <v-form ref="form" v-model="valid" lazy-validation class="add-revenue">
      <v-container grid-list-xl>
        <v-layout row wrap class="list-header">
          <v-flex md1>Day</v-flex>
          <v-flex md2>Amount</v-flex>
          <v-flex md7>Description</v-flex>
          <v-flex md2></v-flex>
        </v-layout>
        <v-layout
          v-for="(item, index) in timesheet[projectIndex].entries"
          :key="item.entryDate"
          class="revenue-records"
        >
          <v-flex md1>{{ days[index] }}</v-flex>
          <v-flex md2>
            <v-text-field
            :disabled="timesheet[projectIndex].is_locked"
              :rules="amountRule"
              prepend-inner-icon="attach_money"
              oninput="validity.valid||(value='');"
              :value="item.revenueAmount | withCommas"
              @blur="v => (item.revenueAmount = parseFloat(v.target.value))"
            ></v-text-field>
          </v-flex>
          <v-flex md7>
            <v-text-field v-model="item.revenueComment" :disabled="timesheet[projectIndex].is_locked"></v-text-field>
          </v-flex>
          <v-flex md2>
            <v-tooltip top open-delay="500">
              <template v-slot:activator="{ on }">
                <v-btn
                  flat
                  icon
                  @click="copyfunc(item.revenueAmount, item.revenueComment)"
                  v-on="on"
                  :disabled="timesheet[projectIndex].is_locked"
                >
                  <v-icon>file_copy</v-icon>
                </v-btn>
              </template>
              <span>Copy</span>
            </v-tooltip>

            <v-tooltip top open-delay="500">
              <template v-slot:activator="{ on }">
                <v-btn flat icon @click="pastefunc(index)" v-on="on" :disabled="timesheet[projectIndex].is_locked">
                  <v-icon>post_add</v-icon>
                </v-btn>
              </template>
              <span>Paste</span>
            </v-tooltip>
          </v-flex>
        </v-layout>
      </v-container>
    </v-form>
  </v-layout>
</template>
<script>
import './AddRevenue.styl';

export default {
  computed: {},
  components: {},
  data() {
    return {
      valid: true,
      amountRule: [
        (v) => {
          // if (!v) return 'This field is required';
          if (!v) {
            return true;
          }
          const anyNonNumbers = v.toString().match(/[^\d,]+/g, '');
          if (anyNonNumbers) {
            return 'Field must just be a number.';
          }
          return true;
        },
      ],
    };
  },
  watch: {},
  props: {
    singleRow: Boolean,
    timesheet: Array,
    days: Array,
    projectIndex: Number,
  },
  methods: {
    validate() {
      return this.$refs.form.validate();
    },
    copyfunc(revenueAmount, revenueComment) {
      this.revenueAmount = revenueAmount;
      this.revenueComment = revenueComment;
    },
    pastefunc(index) {
      this.timesheet[this.projectIndex].entries[index].revenueAmount = this.revenueAmount;
      this.timesheet[this.projectIndex].entries[index].revenueComment = this.revenueComment;
    },
  },
};
</script>
