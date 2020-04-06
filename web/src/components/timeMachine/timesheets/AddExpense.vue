<template>
  <v-layout row justify-center>
    <v-form ref="form" v-model="valid" lazy-validation class="add-expense">
      <v-container grid-list-xl>
        <v-layout row wrap class="list-header">
          <v-flex md1>Day</v-flex>
          <v-flex md2>Amount</v-flex>
          <v-flex md3>Category</v-flex>
          <v-flex md4>Description</v-flex>
          <v-flex md2></v-flex>
        </v-layout>
        <v-layout
          v-for="(item, index) in timesheet[projectIndex].entries"
          :key="item.entryDate"
          class="expense-records"
        >
          <v-flex md1>{{ days[index] }}</v-flex>
          <v-flex md2>
            <v-text-field
              :rules="amountRule"
              prepend-inner-icon="attach_money"
              oninput="validity.valid||(value='');"
              :value="item.expenseAmount | withCommas"
              @blur="v => (item.expenseAmount = parseFloat(v.target.value))"
            ></v-text-field>
          </v-flex>
          <v-flex md3>
            <v-select
              :items="categoryOptions"
              item-text="category"
              item-value="category"
              v-model="item.expenseCategory"
            ></v-select>
          </v-flex>
          <v-flex md4>
            <v-text-field v-model="item.expenseComment"></v-text-field>
          </v-flex>
          <v-flex md2>
            <v-tooltip top open-delay="500">
              <template v-slot:activator="{ on }">
                <v-btn
                  flat
                  icon
                  @click="copyfunc(item.expenseAmount, item.expenseComment, item.expenseCategory)"
                  v-on="on"
                >
                  <v-icon>file_copy</v-icon>
                </v-btn>
              </template>
              <span>Copy</span>
            </v-tooltip>

            <v-tooltip top open-delay="500">
              <template v-slot:activator="{ on }">
                <v-btn flat icon @click="pastefunc(index)" v-on="on">
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
import './AddExpense.styl';

export default {
  computed: {},
  components: {},
  data() {
    return {
      categoryOptions: [{ category: 'Fees' }, { category: 'Transporation' }, { category: 'Other' }],
      valid: true,
      dialog: false,
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
  watch: {
    project(val) {
      this.$store.dispatch('fetchProjectRfx', { id: val });
    },
  },
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
    copyfunc(expenseAmount, expenseComment, expenseCategory) {
      this.expenseAmount = expenseAmount;
      this.expenseComment = expenseComment;
      this.expenseCategory = expenseCategory;
    },
    pastefunc(index) {
      this.timesheet[this.projectIndex].entries[index].expenseAmount = this.expenseAmount;
      this.timesheet[this.projectIndex].entries[index].expenseComment = this.expenseComment;
      this.timesheet[this.projectIndex].entries[index].expenseCategory = this.expenseCategory;
    },
  },
};
</script>
