<template>
  <tr class="row-background-lightgrey">
    <td colspan="12">
      <v-btn
        v-if="displayAddBillableRecordButton"
        color="btnPrimary"
        dark
        class="mt-3 mb-3"
        @click="this.onAddBillableRecordClicked"
      >{{ addBillableRecordLabel }}</v-btn>
      <v-btn
        v-if="displayAddNonBillableRecordButton"
        dark
        class="mt-3 mb-3"
        @click="this.onAddNonBillableRecordClicked"
      >{{ addNonBillableRecordLabel }}</v-btn>
    </td>
  </tr>
</template>

<script>
export default {
  props: {
    onAddBillableRecordClicked: Function,
    onAddNonBillableRecordClicked: Function,
    displayAddBillableRecordButton: {
      type: Boolean,
      value: true,
    },
    displayAddNonBillableRecordButton: {
      type: Boolean,
      value: false,
    },
    addBillableRecordLabel: String,
    addNonBillableRecordLabel: String,
    totals: Object,
  },
};
</script>
