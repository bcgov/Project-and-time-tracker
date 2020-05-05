<template>
  <v-layout column justify-center>
    <snackbar ref="snackbar"></snackbar>
    <confirm ref="confirm"></confirm>
    <add-batch-comment
      ref="addComment"
      :comment="itemComment"
      @savecomment="savecomment"
    ></add-batch-comment>
    <v-flex class="batch-entry-container">
      <v-data-table
        :headers="headers"
        :items="timesheet"
        hide-actions
        class="elevation-0 tm-v-datatable batch-entry"
      >
        <template slot="headerCell" scope="props">
          <v-tooltip bottom v-if="props.header.text != 'Project' && props.header.text != 'Project Rfx'">
            <span slot="activator">
              {{ props.header.text }}
              <v-icon size="20">info</v-icon>
            </span>
            <span>
              Hours (15min = 0.25)
            </span>
          </v-tooltip>
          <span v-else>{{ props.header.text }}</span>
        </template>
        <template v-slot:items="props">
          <template v-if="!props.item.deleted">
            <td>
              <v-select
                :items="userProjects"
                v-model="props.item.project"
                item-value="id"
                item-text="projectName"
                :disabled="editMode || props.item.is_locked"
                label="Project Name"
              ></v-select>

              <!-- TODO - Truncate name if Proj name too long -->
              <!-- <template v-slot:selection='{item}'>
                        {{ item.projectName }}
              </template>-->
            </td>
             <td>
              <v-select
                :items="getRfxList(props.item.project)"
                @click.native="getRfx(props.item.projectRfx,props.item.project)"
                @change="onChangeProjectRfxBatchEntry(props.index, props.item, props.item.project,props.item.projectRfx)"
                v-model="props.item.projectRfx"
                item-value="id"
                item-text="rfxName"
                :rules="requiredRule"
                :disabled="editMode || props.item.is_locked"
                label="Project Rfx"
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
                  :disabled="props.item.is_locked"
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
                      :disabled="props.item.is_locked"
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
                      :disabled="props.item.is_locked"
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
                  :disabled="props.item.is_locked"
                  min="0"
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
                      :disabled="props.item.is_locked"
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
                      :disabled="props.item.is_locked"
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
      valid: true,
      editMode: false,
      itemComment: '',
      requiredRule: [v => !!v || 'This field required'],
      headers: [
        { text: 'Project' },
        { text: 'Project Rfx', sortable: false },
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
    getRfxList(project) {
      const selProject = this.projectList.find(item => item.id === project);
      if (selProject) { return selProject.rfxList; }
      return [];
    },
    getRfx(rfx, project) {
      debugger;
      this.previousSelection = undefined;
      if (project !== undefined) {
        const selProject = this.projectList.find(item => item.id === project);
        if (selProject) {
          const selRfx = selProject.rfxList.find(item => item.id === rfx);
          if (selRfx) {
            this.previousSelection = selRfx;
          }
        }
      }
    },
    async onChangeProjectRfxBatchEntry(index, selectedItem, project, projectRfx) {
      debugger;
      if (this.previousSelection !== undefined) {
        if (!(await this.$refs.confirm.open('info', 'Are you sure to change Rfx?'))) {
          selectedItem.projectRfx = this.previousSelection.id;
          this.previousSelection = undefined;
          return;
        }
      }
      const selectedProjects = this.timesheet.filter(
        item => item.project
          && (item.project === project.id || item.project.id === project.id) && (item.projectRfx === projectRfx.id || item.projectRfx.id === projectRfx.id)
          && !item.deleted,
      );
      if (selectedProjects.length > 1) {
        this.$refs.snackbar.displaySnackbar('info', 'This Rfx is already added');

        if (this.previousSelection && this.previousSelection.id) {
          selectedItem.projectRfx = this.previousSelection.id;
        } else {
          selectedItem.projectRfx = this.previousSelection;
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
      const selProject = this.projectList.find(item => item.id === project);
      if (selProject) {
        selectedItem.projectRfx = undefined;
        const selRfx = selProject.rfxList.find(item => item.id === projectRfx);
        if (selRfx) {
          selectedItem.projectRfx = selRfx.id;
        }

        selectedItem.project = selProject.id;
        selectedItem.mou = selProject.mou.id;
      }
      this.previousSelection = undefined;
    },
    addRow() {
      this.$emit('add-row');
    },
  },
};
</script>
