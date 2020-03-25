<template>
  <div style="width: 100%;">
    <snackbar ref="snackbar"></snackbar>
    <confirm ref="confirm"></confirm>
    <comments-drawer ref="commentsDrawer"></comments-drawer>
    <v-data-table
      :key="tableRefreshKey"
      style="width: 100%;"
      :headers="timesheetHeaders"
      :items="timesheets"
      item-key="id"
      hide-actions
    >
      <template v-slot:headers="props">
        <tr class="row-background-lightgrey">
          <th
            v-for="header in props.headers"
            :style="
              `text-align: ${header.align || 'left'}; width: ${header.width}; font-weight: 900`
            "
            :key="header.text"
            :class="[
              'column sortable',
              pagination.descending ? 'desc' : 'asc',
              header.value === pagination.sortBy ? 'active' : ''
            ]"
            @click="changeSort(header.value)"
          >
            &nbsp;{{ header.text }}
            <small
              v-if="
                [
                  'hoursMonday',
                  'hoursTuesday',
                  'hoursWednesday',
                  'hoursThursday',
                  'hoursFriday',
                  'hoursSaturday',
                  'hoursSunday'
                ].indexOf(header.value) > -1
              "
              class="month-day"
              >{{ header.date }}</small
            >
            <v-icon v-if="header.sortable" small>arrow_upward</v-icon>
          </th>
        </tr>
      </template>
      <v-progress-linear v-slot:progress color="blue" indeterminate></v-progress-linear>
      <template slot="items" slot-scope="props">
        <tr @click="onSelectRow(props)" :class="getSelectedRowClass(props)">
          <td>
            <v-select
              hide-details
              :items="rfxPhases"
              :readOnly="props.item.id === selectedRowId"
              :outline="props.item.id === selectedRowId"
              item-value="id"
              item-text="rfxPhaseName"
              v-model="getTimesheetRow(props.item.id).rfxPhaseId"
            ></v-select>
          </td>
          <td class="text-xs-left">
            <v-select
              hide-details
              :items="users"
              height="34"
              :readOnly="props.item.id === selectedRowId"
              :outline="props.item.id === selectedRowId"
              item-value="id"
              item-text="fullName"
              v-model="getTimesheetRow(props.item.id).userId"
            ></v-select>
          </td>
          <td class="text-xs-left">
            <v-text-field
              hide-details
              type="number"
              ma-0
              pa-0
              :readOnly="!(props.item.id === selectedRowId)"
              :outline="props.item.id === selectedRowId"
              disabled
              class="grid-input input-total-hours"
              :value="calcTimesheetRowTotals(getTimesheetRowHours(props.item.id))"
            />
          </td>
          <td class="text-xs-left">
            <v-text-field
              hide-details
              type="number"
              step="any"
              max="24"
              min="0"
              oninput="validity.valid||(value=0);"
              ma-0
              pa-0
              :readOnly="!(props.item.id === selectedRowId)"
              :outline="props.item.id === selectedRowId"
              class="grid-input input-hours"
              @keyup="
                onTimeKeyup(
                  getTimesheetRowHours(props.item.id).hoursMonday,
                  'hoursMonday',
                  props.item.id
                )
              "
              @change="
                onTimeChange(
                  getTimesheetRowHours(props.item.id).hoursMonday,
                  'hoursMonday',
                  props.item.id
                )
              "
              v-model="getTimesheetRowHours(props.item.id).hoursMonday"
            />
          </td>
          <td class="text-xs-left">
            <v-text-field
              hide-details
              type="number"
              step="any"
              max="24"
              min="0"
              oninput="validity.valid||(value=0);"
              ma-0
              pa-0
              :readOnly="!(props.item.id === selectedRowId)"
              :outline="props.item.id === selectedRowId"
              class="grid-input input-hours"
              @keyup="
                onTimeKeyup(
                  getTimesheetRowHours(props.item.id).hoursTuesday,
                  'hoursTuesday',
                  props.item.id
                )
              "
              @change="
                onTimeChange(
                  getTimesheetRowHours(props.item.id).hoursTuesday,
                  'hoursTuesday',
                  props.item.id
                )
              "
              v-model="getTimesheetRowHours(props.item.id).hoursTuesday"
            />
          </td>
          <td class="text-xs-left">
            <v-text-field
              hide-details
              type="number"
              step="any"
              max="24"
              min="0"
              oninput="validity.valid||(value=0);"
              ma-0
              pa-0
              :outline="props.item.id === selectedRowId"
              class="grid-input input-hours"
              @keyup="
                onTimeKeyup(
                  getTimesheetRowHours(props.item.id).hoursWednesday,
                  'hoursWednesday',
                  props.item.id
                )
              "
              @change="
                onTimeChange(
                  getTimesheetRowHours(props.item.id).hoursWednesday,
                  'hoursWednesday',
                  props.item.id
                )
              "
              v-model="getTimesheetRowHours(props.item.id).hoursWednesday"
            />
          </td>
          <td class="text-xs-left">
            <v-text-field
              hide-details
              type="number"
              step="any"
              max="24"
              min="0"
              oninput="validity.valid||(value=0);"
              ma-0
              pa-0
              :readOnly="!(props.item.id === selectedRowId)"
              :outline="props.item.id === selectedRowId"
              class="grid-input input-hours"
              @keyup="
                onTimeKeyup(
                  getTimesheetRowHours(props.item.id).hoursThursday,
                  'hoursThursday',
                  props.item.id
                )
              "
              @change="
                onTimeChange(
                  getTimesheetRowHours(props.item.id).hoursThursday,
                  'hoursThursday',
                  props.item.id
                )
              "
              v-model="getTimesheetRowHours(props.item.id).hoursThursday"
            />
          </td>
          <td class="text-xs-left">
            <v-text-field
              hide-details
              type="number"
              step="any"
              max="24"
              min="0"
              oninput="validity.valid||(value=0);"
              ma-0
              pa-0
              :readOnly="!(props.item.id === selectedRowId)"
              :outline="props.item.id === selectedRowId"
              class="grid-input input-hours"
              @keyup="
                onTimeKeyup(
                  getTimesheetRowHours(props.item.id).hoursFriday,
                  'hoursFriday',
                  props.item.id
                )
              "
              @change="
                onTimeChange(
                  getTimesheetRowHours(props.item.id).hoursFriday,
                  'hoursFriday',
                  props.item.id
                )
              "
              v-model="getTimesheetRowHours(props.item.id).hoursFriday"
            />
          </td>
          <td class="text-xs-left">
            <v-text-field
              hide-details
              type="number"
              step="any"
              max="24"
              min="0"
              oninput="validity.valid||(value=0);"
              ma-0
              pa-0
              :readOnly="!(props.item.id === selectedRowId)"
              :outline="props.item.id === selectedRowId"
              class="grid-input input-hours"
              @keyup="
                onTimeKeyup(
                  getTimesheetRowHours(props.item.id).hoursSaturday,
                  'hoursSaturday',
                  props.item.id
                )
              "
              @change="
                onTimeChange(
                  getTimesheetRowHours(props.item.id).hoursSaturday,
                  'hoursSaturday',
                  props.item.id
                )
              "
              v-model="getTimesheetRowHours(props.item.id).hoursSaturday"
            />
          </td>
          <td class="text-xs-left">
            <v-text-field
              hide-details
              type="number"
              step="any"
              max="24"
              min="0"
              oninput="validity.valid||(value=0);"
              ma-0
              pa-0
              :readOnly="!(props.item.id === selectedRowId)"
              :outline="props.item.id === selectedRowId"
              class="grid-input input-hours"
              @keyup="
                onTimeKeyup(
                  getTimesheetRowHours(props.item.id).hoursSunday,
                  'hoursSunday',
                  props.item.id
                )
              "
              @change="
                onTimeChange(
                  getTimesheetRowHours(props.item.id).hoursSunday,
                  'hoursSunday',
                  props.item.id
                )
              "
              v-model="getTimesheetRowHours(props.item.id).hoursSunday"
            />
          </td>
          <td class="text-xs-right action-buttons-col">
            <template v-if="getTimesheetRow(props.item.id).userId">
              <v-btn flat icon color="grey" @click="showComments(props.item)">
                <v-icon>comment</v-icon>
              </v-btn>
              <v-btn
                v-if="props.item.id === selectedRowId"
                flat
                icon
                color="primary"
                @click="saveTimesheet(props.item)"
              >
                <v-icon>save</v-icon>
              </v-btn>
              <v-btn v-if="!(props.item.id === selectedRowId)" flat icon color="grey">
                <v-icon>edit</v-icon>
              </v-btn>
            </template>

            <v-btn flat icon color="grey" @click="deleteTimesheet(props.item)">
              <v-icon>delete</v-icon>
            </v-btn>
          </td>
        </tr>
      </template>
      <template v-slot:footer>
        <timesheet-entries-total-row
          :addBillableRecordLabel="addBillableRecordLabel"
          :addNonBillableRecordLabel="addNonBillableRecordLabel"
          :displayAddBillableRecordButton="displayAddBillableRecordButton"
          :displayAddNonBillableRecordButton="displayAddNonBillableRecordButton"
          :onAddNonBillableRecord="onAddNonBillableRecord"
          :onAddNonBillableRecordClicked="
            () => addNonBillableTimesheetClicked(project, projectRfx, timesheet)
          "
          :onAddBillableRecordClicked="
            () => addBillableTimesheetClicked(project, projectRfx, timesheet)
          "
          :totals="calcTimesheetTotals()"
        />
      </template>
    </v-data-table>
  </div>
</template>

<script>
import assign from 'object-assign';
import merge from 'object-merge';
import { mapState } from 'vuex';
import HashTable from '@/utils/HashTable';
import ObjectHelper from '@/helpers/Object';
import Snackbar from '@/components/timeMachine/common/Snackbar.vue';
import Confirm from '@/components/timeMachine/common/Confirm.vue';
import moment from 'moment';
import TimesheetEntryDto from '@/domain/models/TimesheetEntry.dto';
import TimesheetEntriesTotalRow from './TimesheetEntriesTotalRow.vue';
import CommentsDrawer from './CommentsDrawer.vue';

export default {
  components: {
    Snackbar,
    Confirm,
    TimesheetEntriesTotalRow,
    CommentsDrawer,
  },
  props: {
    title: String,
    addBillableRecordLabel: String,
    addNonBillableRecordLabel: String,
    onAddNonBillableRecord: Function,
    onAddNonBillableRecordClicked: Function,
    displayAddBillableRecordButton: Boolean,
    displayAddNonBillableRecordButton: Boolean,
    project: Object,
    projectRfx: Object,
    timesheet: Object,
    selectedRfxData: Object,
    filter: {
      type: Function,
      default: item => item.isBillable !== false,
    },
    displayNonBillableRecords: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    const timesheetRowsHash = this.initTimesheetRows();

    return {
      pagination: {
        sortBy: 'name',
      },
      // We use a HashTable to store form data by row using a timesheet ID
      tableRefreshKey: ObjectHelper.generateUUIDv4(),
      selectedRowId: null,
      timesheetRows: timesheetRowsHash,
      dialog: false,
      expand: false,
      rfxExpand: false,
      timesheetHeaders: this.getTimesheetHeaders(),
    };
  },
  watch: {
    // Watch for deep changes
    $data: {
      handler() {},
      deep: true,
    },
    timesheetsWeek: {
      handler() {
        this.fetchData(true); // Set flag to true to replace data, we changed weeks

        this.timesheetHeaders = this.getTimesheetHeaders();
      },
    },
  },
  computed: {
    ...mapState(['timesheetsWeek']),
    rfxPhases() {
      return this.$store.state.rfxPhases;
    },
    timesheets() {
      return this.getTimesheets();
    },
    users() {
      const { users } = this.$store.state;
      return users.map(user => ({
        id: user.id,
        fullName: user.contact.fullName,
      }));
    },
  },
  methods: {
    getTimesheetHeaders() {
      const startDate = sessionStorage.getItem('selectedStartDate');

      // Set start day to start of week, which in our case is Monday
      const day1 = moment(startDate).day(1);
      const day2 = moment(startDate).day(2);
      const day3 = moment(startDate).day(3);
      const day4 = moment(startDate).day(4);
      const day5 = moment(startDate).day(5);
      const day6 = moment(startDate).day(6);
      const day7 = moment(startDate).day(7);

      return [
        {
          text: 'Phase Name',
          value: 'phaseName',
          width: '280px',
        },
        {
          text: 'User',
          value: 'user',
          width: '280px',
        },
        {
          text: 'Hours',
          value: 'hours',
        },
        {
          text: 'Mo',
          value: 'hoursMonday',
          date: this.date2Digit(day1),
          sortable: false,
        },
        {
          text: 'Tu',
          value: 'hoursTuesday',
          date: this.date2Digit(day2),
          sortable: false,
        },
        {
          text: 'We',
          value: 'hoursWednesday',
          date: this.date2Digit(day3),
          sortable: false,
        },
        {
          text: 'Th',
          value: 'hoursThursday',
          date: this.date2Digit(day4),
          sortable: false,
        },
        {
          text: 'Fr',
          value: 'hoursFriday',
          date: this.date2Digit(day5),
          sortable: false,
        },
        {
          text: 'Sa',
          value: 'hoursSaturday',
          date: this.date2Digit(day6),
          sortable: false,
        },
        {
          text: 'Su',
          value: 'hoursSunday',
          date: this.date2Digit(day7),
          sortable: false,
        },
        {
          text: 'Actions',
          value: 'action',
          align: 'right',
          width: '180px',
          sortable: false,
        },
      ];
    },
    onSelectRow(props) {
      props.expanded = !props.expanded;
      this.selectedRowId = props.item.id;
    },
    getSelectedRowClass(props) {
      return props.item.id === this.selectedRowId ? 'table-row selected-row' : 'table-row';
    },
    addBillableTimesheetClicked(project, projectRfx, timesheet) {
      this.createTimesheet(project, projectRfx, timesheet, true);
    },
    addNonBillableTimesheetClicked(project, projectRfx, timesheet) {
      this.createTimesheet(project, projectRfx, timesheet, false);
    },
    onTimeKeyup(enteredHours, dayoftheweek, id) {
      let defValue = 0;
      if (enteredHours !== '') {
        enteredHours = parseFloat(enteredHours);
        if (enteredHours > 24) {
          defValue = 24;
          this.setDefaultTimeEntry(dayoftheweek, id, defValue);
        }
      }
    },
    onTimeChange(enteredHours, dayoftheweek, id) {
      const defValue = 0;
      if (enteredHours === '') {
        this.setDefaultTimeEntry(dayoftheweek, id, defValue);
      }
    },
    setDefaultTimeEntry(dayoftheweek, id, defValue) {
      switch (dayoftheweek) {
        case 'hoursMonday': {
          this.getTimesheetRowHours(id).hoursMonday = defValue;
          return;
        }
        case 'hoursTuesday': {
          this.getTimesheetRowHours(id).hoursTuesday = defValue;
          return;
        }
        case 'hoursWednesday': {
          this.getTimesheetRowHours(id).hoursWednesday = defValue;
          return;
        }
        case 'hoursThursday': {
          this.getTimesheetRowHours(id).hoursThursday = defValue;
          return;
        }
        case 'hoursFriday': {
          this.getTimesheetRowHours(id).hoursFriday = defValue;
          return;
        }
        case 'hoursSaturday': {
          this.getTimesheetRowHours(id).hoursSaturday = defValue;
          return;
        }
        case 'hoursSunday': {
          this.getTimesheetRowHours(id).hoursSunday = defValue;
          return;
        }
        default: {
          this.getTimesheetRowHours(id).hoursSunday = defValue;
        }
      }
    },
    /**
     * Fetch timesheets into Vuex store.
     */
    async fetchData(replace) {
      this.$store
        .dispatch('fetchTimesheets', {
          replace: replace || false,
          projectId: this.project.id,
          startDate: sessionStorage.getItem('selectedStartDate'),
          endDate: sessionStorage.getItem('selectedEndDate'),
        })
        .then(() => {
          const timesheetRowsHash = this.initTimesheetRows();
          this.timesheetRows = timesheetRowsHash;
        });
    },
    /**
     * Get timesheets from Vuex store.
     */
    getTimesheets() {
      let timesheets = this.$store.state.timesheets || [];

      const selectedRfxId = this.$props.selectedRfxData && this.$props.selectedRfxData.id
        ? this.$props.selectedRfxData.id
        : undefined;
      if (timesheets instanceof Array) {
        timesheets = timesheets.filter(
          timesheet => (timesheet.project && timesheet.project.id) === this.project.id
            && (timesheet.projectRfx && timesheet.projectRfx.id) === selectedRfxId,
        );
        timesheets = typeof this.filter === 'function' ? timesheets.filter(this.filter) : timesheets;
      }
      return timesheets;
    },
    /**
     * Used to initialize timesheet rows and hours from timesheets and entries in Vuex store.
     */
    initTimesheetRows() {
      const timesheets = this.getTimesheets();
      const timesheetRows = new HashTable();

      timesheets.forEach((timesheet) => {
        const timesheetRowValues = this.initTimesheetRowHours(timesheet.timesheetEntries);
        const timesheetRow = {
          hours: timesheetRowValues.rowHours,
          rowData: timesheetRowValues.rowData,
          userId: timesheet.userId ? timesheet.userId : timesheet.createdUserId,
          rfxPhaseId: timesheet.rfxPhase ? timesheet.rfxPhase.id : null,
        };

        timesheetRows.set(timesheet.id, timesheetRow);
      });

      return timesheetRows;
    },
    /**
     * Merges in a timesheet row entry against a base template.
     * @param timesheetEntries
     * @returns {{hoursMonday: number, hoursTuesday: number, hoursWednesday: number, hoursSaturday: number, hoursFriday: number, hoursThursday: number, hoursSunday: number}}
     */
    initTimesheetRowHours(timesheetEntries) {
      const hours = {
        hoursMonday: 0,
        hoursTuesday: 0,
        hoursWednesday: 0,
        hoursThursday: 0,
        hoursFriday: 0,
        hoursSaturday: 0,
        hoursSunday: 0,
      };

      // This is what we will be filling in...
      const dailyKeys = Object.keys(hours);
      const rowHours = assign({}, hours);
      const rowData = assign({}, hours);

      if (timesheetEntries instanceof Array) {
        timesheetEntries.forEach((entry) => {
          const entryDate = moment(entry.entryDate);

          // Set day index of week, which in our case the week starts at Monday
          let day = entryDate.get('day');
          day = day === 0 ? 6 : --day;
          rowHours[dailyKeys[day]] = entry.hoursBilled;
          rowData[dailyKeys[day]] = {
            comments: entry.comments,
            id: entry.id,
            projectId: entry.projectId,
            projectRfxId: entry.projectRfxId,
            rfxPhaseId: entry.rfxPhaseId,
          };
        });
      }

      return {
        rowHours,
        rowData,
      };
    },
    getTimesheetRowHours(id) {
      const hours = {
        hoursMonday: 0,
        hoursTuesday: 0,
        hoursWednesday: 0,
        hoursThursday: 0,
        hoursFriday: 0,
        hoursSaturday: 0,
        hoursSunday: 0,
      };

      if (this.timesheetRows instanceof HashTable) {
        const timesheetRow = this.timesheetRows.get(id) || undefined;
        if (timesheetRow && timesheetRow.hours) {
          return timesheetRow.hours;
        }
      }

      return hours;
    },
    getTimesheetRow(id) {
      let timesheetRow = {};
      if (this.timesheetRows instanceof HashTable) {
        timesheetRow = this.timesheetRows.get(id) || timesheetRow;
      }

      return timesheetRow;
    },
    /**
     * Calculate timesheet row totals eg. for the week.
     */
    calcTimesheetRowTotals(timesheetRow) {
      let totalHours = 0;

      if (
        timesheetRow !== undefined
        && timesheetRow !== null
        && Object.values(timesheetRow) instanceof Array
      ) {
        totalHours = Object.values(timesheetRow).reduce((acc, val) => {
          let newVal;
          if (val) {
            newVal = acc + parseFloat(val);
          } else {
            newVal = acc;
          }
          return newVal;
        }, 0);
      }

      return totalHours;
    },
    /**
     * Calculate timesheet totals for all loaded records belonging to a given project rfx.
     */
    calcTimesheetTotals() {
      const dailyHours = {
        hoursMonday: 0,
        hoursTuesday: 0,
        hoursWednesday: 0,
        hoursThursday: 0,
        hoursFriday: 0,
        hoursSaturday: 0,
        hoursSunday: 0,
      };

      let totalHours = 0;

      // Retrieve all existing timesheet entry hours from component data
      const { timesheetRows } = this;
      const dailyKeys = Object.keys(dailyHours);
      timesheetRows.each((timesheetKey) => {
        dailyKeys.forEach((key) => {
          const timesheetRowHours = timesheetRows.get(timesheetKey).hours;
          dailyHours[key] += parseFloat(parseFloat(timesheetRowHours[key] || 0).toFixed(2));
          totalHours += parseFloat(timesheetRowHours[key] || 0);
        });
      });
      totalHours = parseFloat(totalHours.toFixed(2));
      return {
        dailyHours,
        totalHours,
      };
    },
    /**
     * Create a timesheet.
     * @param project
     * @param projectRfx
     * @param timesheet
     * @param isBillable
     */
    createTimesheet(project, projectRfx, timesheet, isBillable) {
      const { rfxType, rfxPhase } = projectRfx;

      const startDate = sessionStorage.getItem('selectedStartDate');
      const endDate = sessionStorage.getItem('selectedEndDate');

      const payload = {
        project,
        projectRfx,
        rfxPhase,
        rfxType,
        startDate,
        endDate,
        isBillable,
      };

      this.$store.dispatch('addTimesheet', payload).then(
        () => {
          const timesheetRowsHash = this.initTimesheetRows();
          this.timesheetRows = timesheetRowsHash;
        },
        (err) => {
          if (err && err.data && err.data.entityValidationErrors) {
            if (err.data.entityValidationErrors.length > 1) {
              this.handleMultipleErrors(err.data.entityValidationErrors);
            } else {
              this.$refs.snackbar.displaySnackbar(
                'error',
                err.data.entityValidationErrors[0].message,
              );
            }
          } else {
            this.$refs.snackbar.displaySnackbar('error', 'Timesheet adding failed');
          }
        },
      );
    },
    handleMultipleErrors(errorList) {
      this.$refs.snackbar.displayMultipleErrorSnackbar('error', errorList);
    },
    /**
     * Save a timesheet and its entries.
     * @param timesheet
     */
    saveTimesheet(timesheet) {
      const payload = this.timesheetUpdatePayload(timesheet);

      this.updateTimesheet(payload);
    },
    /**
     * Delete a timesheet and all related entries.
     * @param timesheet
     */
    async deleteTimesheet(timesheet) {
      if (await this.$refs.confirm.open('danger', 'Are you sure you want to delete this entry?')) {
        this.$store.dispatch('deleteTimesheet', { id: timesheet.id }).then(
          () => {
            this.selectedRowId = null;
            const timesheetRowsHash = this.initTimesheetRows();
            this.timesheetRows = timesheetRowsHash;
            this.$refs.snackbar.displaySnackbar('success', 'Time log entry deleted');
          },
          (err) => {
            if (err && err.data && err.data.error && err.data.error.message) {
              this.$refs.snackbar.displaySnackbar('error', err.data.error.message);
            } else {
              this.$refs.snackbar.displaySnackbar('error', 'Timesheet deletion failed');
            }
          },
        );
      }
    },

    timesheetUpdatePayload(timesheet) {
      const payload = merge({}, timesheet, {
        userId: null,
        isBillable: null,
      });

      payload.entries = [];
      // Create timesheet entries

      const timesheetRowHours = this.timesheetRows.get(timesheet.id).hours;
      const timesheetRowUserId = this.timesheetRows.get(timesheet.id).userId;
      const { rowData } = this.timesheetRows.get(timesheet.id);

      const dailyKeys = Object.keys(timesheetRowHours);
      dailyKeys.forEach((key, idx) => {
        const startDate = moment(sessionStorage.getItem('selectedStartDate'));

        // Offset date by day index (Monday is start of week)
        const entryDate = startDate.day(idx + 1);

        const entryHoursBilled = timesheetRowHours[key] || 0;

        const timesheetEntryDto = TimesheetEntryDto.constructFromObject({
          id: rowData[key].id,
          userId: timesheetRowUserId,
          hoursBilled: parseFloat(entryHoursBilled),
          startTime: null,
          endTime: null,
          entryDate: entryDate.format('YYYY-MM-DD'),
          comments: rowData ? rowData[key].comments : '',
        });

        payload.entries.push(timesheetEntryDto);
      });
      payload.isBillable = timesheet.isBillable;
      payload.userId = timesheetRowUserId;
      payload.rfxPhase.id = this.getTimesheetRow(timesheet.id).rfxPhaseId;

      return payload;
    },

    updateTimesheet(payload) {
      if (payload && payload.userId) {
        delete payload.timesheetEntries;
        this.$store
          .dispatch('updateTimesheet', {
            id: payload.id,
            payload,
          })
          .then(
            () => {
              const timesheetRowsHash = this.initTimesheetRows();
              this.timesheetRows = timesheetRowsHash;
              this.$refs.snackbar.displaySnackbar('success', 'Time log entry saved successfully');
              this.selectedRowId = null;
            },
            (err) => {
              if (err && err.data && err.data.entityValidationErrors) {
                if (err.data.entityValidationErrors.length > 1) {
                  this.handleMultipleErrors(err.data.entityValidationErrors);
                } else {
                  this.$refs.snackbar.displaySnackbar(
                    'error',
                    err.data.entityValidationErrors[0].message,
                  );
                }
              } else {
                this.$refs.snackbar.displaySnackbar('error', 'Timesheet update failed');
              }
            },
          );
      } else {
        this.$refs.snackbar.displaySnackbar('warning', 'Please select the user!');
      }
    },

    /**
     * Show details for a timesheet or entry (TBD) in sidebar.
     */
    showComments(timesheet) {
      const selectedRowPayload = this.timesheetUpdatePayload(timesheet);

      this.$refs.commentsDrawer.openComments(selectedRowPayload, this.updateTimesheet);
    },
    /**
     * Close timesheet or entry details (TBD) sidebar.
     */
    closeTimesheetDetails() {
      this.dialog = false;
    },
    changeSort(column) {
      if (this.pagination.sortBy === column) {
        this.pagination.descending = !this.pagination.descending;
      } else {
        this.pagination.sortBy = column;
        this.pagination.descending = false;
      }
    },
    date2Digit(day) {
      return `0${day.get('date')}`.slice(-2);
    },
  },
  created() {
    this.fetchData();
  },
};
</script>

<style>
.v-datatable td .grid-input.input-hours {
  width: 4.5rem;
}

.v-datatable td .grid-input.input-total-hours {
  width: 6rem;
}
.v-datatable td .grid-input.input-total-hours .v-input__slot {
  border-style: none;
}
.week-switcher-cal {
  margin: 0 !important;
  padding: 0;
}

hr {
  color: lightgrey;
}

.v-input__slot {
  padding: 0 12px;
  margin-bottom: 8px;
}

tbody tr.table-row td {
  padding-bottom: 8px !important;
}

tbody tr.table-row.selected-row td {
  padding-bottom: 0px !important;
}

tbody tr.table-row:last-child td {
  padding-bottom: 2rem !important;
}

tbody tr.table-row.selected-row {
  border-top: none !important;
  border-bottom: none !important;
}

tbody tr.table-row:not(.selected-row) {
  border-bottom: none !important;
}

tfoot td {
  padding-left: 18px !important;
  font-weight: bold !important;
}

.month-day {
  margin-left: 0.5rem;
  color: var(--v-background-base) !important;
  background-color: white;
  padding: 6px;
  border: 1px solid rgba(0, 0, 0, 0.12) !important;
  border-radius: 12px;
}
table.v-table tbody td .action-buttons-col {
  padding: 0px;
}

.selected-row .action-buttons-col td button.v-btn {
  margin-top: 0 !important;
}
</style>
