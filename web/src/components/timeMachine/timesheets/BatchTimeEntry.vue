<template>
  <v-layout column justify-center>
    <snackbar ref="snackbar"></snackbar>
    <v-flex>
      <v-data-table
        :headers="headers"
        :items="timesheet"
        hide-actions
        class="elevation-0 tm-v-datatable batch-entry"
      >
        <template v-slot:items="props">
        <template v-if="!props.item.is_PSB">

          <td>
            <v-select
              auto-focus="true"
              :items="userProjects"
              item-text="projectName"
              item-value="id"
              v-model="props.item.project"
              :key="props.item.project"
              @focus="handleClick(props.item.project)"
              @change="onChangeProjectBatchEntry(props.index, props.item)"
              label="Project Name"
              :disabled="editMode"
            >
              <!-- TODO - Truncate name if Proj name too long -->
              <!-- <template v-slot:selection='{item}'>
                        {{ item.projectName }}
              </template>-->
            </v-select>
          </td>
          <td v-for="index in 5" :key="index">
            <v-flex v-if="selectedItem == 1">
              <v-text-field
                type="number"
                max="24"
                step="0.01"
                min="0"
                oninput="validity.valid||(value=0);"
                v-model="props.item.entries[index - 1].hoursBillable"
              ></v-text-field>
            </v-flex>
            <v-flex v-else>
              <v-text-field
                type="number"
                max="24"
                step="0.01"
                min="0"
                oninput="validity.valid||(value=0);"
                v-model="props.item.entries[index - 1].hoursUnBillable"
              ></v-text-field>
            </v-flex>
          </td>
           </template>
        </template>
      </v-data-table>
    </v-flex>
    <v-flex v-if="!editMode">
      <v-btn class="btn-normal" @click="addRow">ADD ANOTHER ENTRY</v-btn>
    </v-flex>
  </v-layout>
</template>
<script>
import Snackbar from '../common/Snackbar.vue';

export default {
  components: { Snackbar },
  computed: {
    userProjects() {
      return this.projectList;
    },
  },
  data() {
    return {
      previousSelection: '',
      hoursRule: [v => v % 0.25 === 0 || 'Please enter in quarter hours (0.25 = 15min)'],
      valid: true,
      editMode: false,
      headers: [
        { text: 'Project' },
        {
          text: 'Mon',
          sortable: false,
          value:
            this.$props.selectedItem === 1
              ? 'item.entries[0].hoursBillable'
              : 'item.entries[0].hoursUnBillable',
        },
        {
          text: 'Tue',
          sortable: false,
          value:
            this.$props.selectedItem === 1
              ? 'item.entries[1].hoursBillable'
              : 'item.entries[1].hoursUnBillable',
        },
        {
          text: 'Wed',
          sortable: false,
          value:
            this.$props.selectedItem === 1
              ? 'item.entries[2].hoursBillable'
              : 'item.entries[2].hoursUnBillable',
        },
        {
          text: 'Thu',
          sortable: false,
          value:
            this.$props.selectedItem === 1
              ? 'item.entries[3].hoursBillable'
              : 'item.entries[3].hoursUnBillable',
        },
        {
          text: 'Fri',
          sortable: false,
          value:
            this.$props.selectedItem === 1
              ? 'item.entries[4].hoursBillable'
              : 'item.entries[4].hoursUnBillable',
        },
      ],
    };
  },
  props: {
    selectedItem: Number,
    timesheet: Array,
    projectList: Array,
  },
  watch: {},
  methods: {
    handleClick(projectId) {
      if (projectId === undefined) { this.previousSelection = ''; } else {
        this.previousSelection = projectId;
      }
    },
    onChangeProjectBatchEntry(index, selectedItem) {
      const selectedProjects = this.timesheet.filter(
        item => item.project && item.project === selectedItem.project,
      );
      if (selectedProjects.length > 1) {
        this.$refs.snackbar.displaySnackbar('info', 'This project is already added');
        if (index === this.timesheet.length - 1 && this.previousSelection === '') {
          this.timesheet.pop();
        } else {
          debugger;
          //  selectedItem.project = this.previousSelection;
          //  this.timesheet[index].project = this.previousSelection;
          selectedItem.project = undefined;
          this.timesheet[index].project = undefined;
        }
      } else {
        const selProject = this.projectList.find(item => item.id === selectedItem.project);
        if (selProject) {
          selectedItem.mou = selProject.mou.id;
          selectedItem.project = selProject.id;
          selectedItem.projectRfx = undefined;
        }
      }
      this.previousSelection = '';
    },
    addRow() {
      this.$emit('add-row');
    },
  },
};
</script>
