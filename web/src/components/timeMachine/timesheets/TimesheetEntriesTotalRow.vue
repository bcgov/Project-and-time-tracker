<template>
  <tr class="row-background-lightgrey">
    <td>
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
    <td class="text-xs-right">
      <strong>
        <small>Total Hours:</small>
      </strong>
    </td>
    <td class="text-xs-center">
      <strong>{{ totals.totalHours }} Hrs</strong>
    </td>
    <td class="text-xs-center">
      <span>{{ totals.dailyHours.hoursMonday }} Hrs</span>
    </td>
    <td class="text-xs-center">
      <span>{{ totals.dailyHours.hoursTuesday }} Hrs</span>
    </td>
    <td class="text-xs-center">
      <span>{{ totals.dailyHours.hoursWednesday }} Hrs</span>
    </td>
    <td class="text-xs-center">
      <span>{{ totals.dailyHours.hoursThursday }} Hrs</span>
    </td>
    <td class="text-xs-center">
      <span>{{ totals.dailyHours.hoursFriday }} Hrs</span>
    </td>
    <td class="text-xs-center">
      <span>{{ totals.dailyHours.hoursSaturday }} Hrs</span>
    </td>
    <td class="text-xs-center">
      <span>{{ totals.dailyHours.hoursSunday }} Hrs</span>
    </td>
    <td></td>
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
