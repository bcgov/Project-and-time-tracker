<template>
  <v-layout column justify-center>
    <snackbar ref="snackbar"></snackbar>
    <confirm ref="confirm"></confirm>
    <add-batch-comment
      ref="addComment"
      :comment="itemComment"
      @savecomment="savecomment"
    ></add-batch-comment>
    <v-flex>
      <v-data-table
        :headers="headers"
        :items="timesheet"
        hide-actions
        class="elevation-0 tm-v-datatable batch-entry"
      >
        <template v-slot:items="props">
          <template v-if="!props.item.deleted">
            <td>
              <v-select
                :items="userProjects"
                @click.native="getProject(props.item.project)"
                @change="onChangeProjectBatchEntry(props.index, props.item, props.item.project)"
                v-model="props.item.project"
                item-value="id"
                item-text="projectName"
                :disabled="editMode"
                label="Project Name"
                return-object
              ></v-select>

              <!-- TODO - Truncate name if Proj name too long -->
              <!-- <template v-slot:selection='{item}'>
                        {{ item.projectName }}
              </template>-->
            </td>
            <td v-for="index in 5" :key="index">
              <v-flex style="float:left" v-if="selectedItem == 1">
                <v-text-field
                  style="float:left;width:70px"
                  type="number"
                  max="24"
                  step="0.01"
                  min="0"
                  :rules="hoursRule"
                  oninput="validity.valid||(value=0);"
                  v-model="props.item.entries[index - 1].hoursBillable"
                ></v-text-field>

                <v-tooltip
                  v-if="!props.item.entries[index - 1].commentsBillable"
                  top
                  open-delay="500"
                >
                  <template v-slot:activator="{ on }">
                    <v-btn
                      style="width:0px;margin-top: 13px;"
                      @click="
                        addcomment(
                          props.item.entries[index - 1].commentsBillable,
                          index - 1,
                          props.index,
                          'billable'
                        )
                      "
                      flat
                      icon
                      v-on="on"
                    >
                      <v-icon>note_add</v-icon>
                    </v-btn>
                  </template>
                  <span>add comment</span>
                </v-tooltip>
                <v-tooltip
                  v-if="props.item.entries[index - 1].commentsBillable"
                  top
                  open-delay="500"
                >
                  <template v-slot:activator="{ on }">
                    <v-btn
                      style="width:0px;margin-top: 13px;"
                      @click="
                        addcomment(
                          props.item.entries[index - 1].commentsBillable,
                          index - 1,
                          props.index,
                          'billable'
                        )
                      "
                      flat
                      icon
                      v-on="on"
                    >
                      <v-icon>create</v-icon>
                    </v-btn>
                  </template>
                  <span>edit comment</span>
                </v-tooltip>
              </v-flex>
              <v-flex style="float:left" v-else>
                <v-text-field
                  style="float:left;width:70px"
                  type="number"
                  max="24"
                  step="0.01"
                  min="0"
                  :rules="hoursRule"
                  oninput="validity.valid||(value=0);"
                  v-model="props.item.entries[index - 1].hoursUnBillable"
                ></v-text-field>
                <v-tooltip
                  v-if="!props.item.entries[index - 1].commentsUnBillable"
                  top
                  open-delay="500"
                >
                  <template v-slot:activator="{ on }">
                    <v-btn
                      style="width:0px;margin-top: 13px;"
                      @click="
                        addcomment(
                          props.item.entries[index - 1].commentsUnBillable,
                          index - 1,
                          props.index,
                          'unbillable'
                        )
                      "
                      flat
                      icon
                      v-on="on"
                    >
                      <v-icon>note_add</v-icon>
                    </v-btn>
                  </template>
                  <span>add comment</span>
                </v-tooltip>
                <v-tooltip
                  v-if="props.item.entries[index - 1].commentsUnBillable"
                  top
                  open-delay="500"
                >
                  <template v-slot:activator="{ on }">
                    <v-btn
                      style="width:0px;margin-top: 13px;"
                      @click="
                        addcomment(
                          props.item.entries[index - 1].commentsUnBillable,
                          index - 1,
                          props.index,
                          'unbillable'
                        )
                      "
                      flat
                      icon
                      v-on="on"
                    >
                      <v-icon>create</v-icon>
                    </v-btn>
                  </template>
                  <span>edit comment</span>
                </v-tooltip>
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
import Confirm from '../common/Confirm.vue';
import AddBatchComment from './AddBatchComment.vue';

export default {
  components: { Snackbar, Confirm, AddBatchComment },
  computed: {
    userProjects() {
      return this.projectList;
    },
  },
  data() {
    return {
      previousSelection: undefined,
      hoursRule: [v => v % 0.25 === 0 || 'Please enter in quarter hours (0.25 = 15min)'],
      valid: true,
      editMode: false,
      itemComment: '',
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
    addcomment(value, index, sheetIndex, type) {
      this.itemComment = value;
      const selProject = this.projectList.find(
        item => item.id === this.$props.timesheet[sheetIndex].project,
      );
      const date = this.$props.timesheet[sheetIndex].entries[index].entryDate;
      let dateVaue = '';
      let projectValue = '';
      if (selProject) {
        dateVaue = `Date: ${date}`;
        projectValue = `Project: ${selProject.projectName}`;
      } else {
        dateVaue = `Date: ${date}`;
      }
      this.$refs.addComment.open(value, index, sheetIndex, type, dateVaue, projectValue);
    },
    savecomment(commentValue, index, sheetIndex, type) {
      if (type === 'billable') {
        this.$props.timesheet[sheetIndex].entries[index].commentsBillable = commentValue;
      } else {
        this.$props.timesheet[sheetIndex].entries[index].commentsUnBillable = commentValue;
      }
    },
    getProject(project) {
      this.previousSelection = undefined;
      if (project !== undefined) {
        const selProject = this.projectList.find(item => item.id === project);
        if (selProject) {
          this.previousSelection = selProject;
        }
      }
    },
    async onChangeProjectBatchEntry(index, selectedItem, project) {
      if (this.previousSelection !== undefined) {
        if (!(await this.$refs.confirm.open('info', 'Are you sure to change project?'))) {
          selectedItem.project = this.previousSelection.id;
          this.previousSelection = undefined;
          return;
        }
      }
      const selectedProjects = this.timesheet.filter(
        item => item.project
          && (item.project === project.id || item.project.id === project.id)
          && !item.deleted,
      );
      if (selectedProjects.length > 1) {
        this.$refs.snackbar.displaySnackbar('info', 'This project is already added');

        if (this.previousSelection && this.previousSelection.id) {
          selectedItem.project = this.previousSelection.id;
        } else {
          selectedItem.project = this.previousSelection;
        }

        const projectsNotDeleted = this.timesheet.filter(item => !item.deleted);

        if (
          projectsNotDeleted.length > 1
          && this.timesheet.length - 1 === index
          && this.previousSelection === undefined
        ) {
          selectedItem.deleted = true;
        }
        this.previousSelection = undefined;
        return;
      }
      const selProject = this.projectList.find(item => item.id === project.id);
      if (selProject) {
        selectedItem.project = selProject.id;
        selectedItem.mou = selProject.mou.id;
        selectedItem.projectRfx = undefined;
      }
      this.previousSelection = undefined;
    },
    addRow() {
      this.$emit('add-row');
    },
  },
};
</script>
