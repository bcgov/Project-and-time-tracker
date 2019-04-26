<template>
  <v-card flat>
    <div style="border-left: 1px solid lightgrey">
      <v-data-table
        :headers="rfxHeaders"
        :items="project.projectRfxData"
        :expand="true"
        no-data-text="No Project RFx available"
        hide-headers
        hide-actions
      >
        <template v-slot:items="props">
          <tr class="row-background" @click="props.expanded = !props.expanded">
            <td>{{ getRfxTypeName(props.item) }}</td>
          </tr>
        </template>
        <template v-slot:expand="props">
          <timesheet-expansion-row :selectedRfxData="props.item" :project="project"></timesheet-expansion-row>
        </template>
      </v-data-table>
    </div>
  </v-card>
</template>

<script>
import TimesheetExpansionRow from './TimesheetExpansionRow.vue';

export default {
  components: {
    TimesheetExpansionRow,
  },
  props: {
    title: String,
    project: Object,
  },
  data() {
    return {
      selected: [],
      dialog: false,
      expand: false,
      rfxExpand: false,
      rfxHeaders: [
        {
          text: 'RFx Type',
          value: 'rfxType',
        },
      ],
    };
  },
  computed: {
    projectRfx() {
      if (this.$store.state.projectsRfx) {
        return this.$store.state.projectsRfx.get(this.project.id);
      }
      return [];
    },
  },
  watch: {
    projectsRfx() {
      this.$forceUpdate();
    },
  },
  methods: {
    getProjectRfx(id) {
      return this.projectsRfx.get(id);
    },
    getRfxType(id) {
      const filtered = this.$store.state.rfxTypes.filter(
        type => type.id === id,
      );
      return filtered[0];
    },
    getRfxTypeName(rfxData) {
      return rfxData && rfxData.rfxType && rfxData.rfxType.rfxTypeName
        ? rfxData.rfxType.rfxTypeName
        : '';
    },
  },
};
</script>

<style>
.v-datatable td .grid-input.input-hours {
  width: 4.5rem;
}

.week-switcher-cal {
  margin: 0 !important;
  padding: 0;
}

hr {
  color: lightgrey;
}
</style>
