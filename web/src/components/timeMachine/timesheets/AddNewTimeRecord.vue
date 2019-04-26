 <template>
  <v-layout row justify-center>
    <snackbar ref="snackbar"></snackbar>
    <v-dialog
      id="AddNewTimeRecord"
      content-class="new-time-record"
      v-model="dialog"
      max-width="600"
    >
      <v-form ref="form" v-model="valid" lazy-validation>
        <spinner ref="spinner"></spinner>
        <v-card>
          <v-card-title>
            <span justify-center class="headline">Mobile Add Time Record</span>
          </v-card-title>
          <v-card-text>
            <v-container grid-list-md>
              <v-layout wrap>
                <v-flex xs12>
                  <v-select
                    :items="projects"
                    label="Select Project"
                    v-model="form.project"
                    class="required"
                    :rules="requiredRule"
                    item-value="id"
                    item-text="projectName"
                    @change="fetchProjectRfx(form.project)"
                  ></v-select>
                </v-flex>

                <v-flex xs12>
                  <v-select
                    :disabled="form.project == null"
                    :items="rfxTypes"
                    label="Select RFx Type"
                    item-value="id"
                    item-text="rfxType.rfxTypeName"
                    v-model="form.projectRfx"
                    class="required"
                    :rules="requiredRule"
                    @change="projectRfxChanged(form.projectRfx)"
                  ></v-select>
                </v-flex>

                <v-flex xs12>
                  <v-select
                    :items="rfxPhases"
                    label="Select Phase"
                    item-value="id"
                    item-text="rfxPhaseName"
                    v-model="form.rfxPhase"
                    class="required"
                    :rules="requiredRule"
                    @change="projectPhaseChanged(form.rfxPhase)"
                  ></v-select>
                </v-flex>

                <v-flex xs12>
                  <v-select
                    :items="userList"
                    label="Select User"
                    item-value="id"
                    item-text="contact.fullName"
                    v-model="form.userId"
                    class="required"
                    :rules="requiredRule"
                    @change="projectUserChanged(form.userId)"
                  ></v-select>
                </v-flex>
                <v-flex xs12 class="v-form-container pl-0">
                  <div>
                    <v-menu
                      v-model="menu1"
                      :close-on-content-click="false"
                      :nudge-right="40"
                      lazy
                      transition="scale-transition"
                      offset-y
                      full-width
                      max-width="290px"
                      min-width="290px"
                    >
                      <template v-slot:activator="{ on }">
                        <v-text-field
                          readonly
                          label="Date"
                          v-model="form.date"
                          persistent-hint
                          class="required"
                          :rules="requiredRule"
                          prepend-inner-icon="event"
                          @blur="date = parseDate(dateFormatted)"
                          ref="timefield"
                          v-on="on"
                          @Focus="()=>$refs.timefield.blur()"
                        ></v-text-field>
                      </template>
                      <v-date-picker
                        v-model="form.date"
                        no-title
                        @input="menu1 = false"
                        @change="projectDateChanged(form.date)"
                      ></v-date-picker>
                    </v-menu>
                  </div>
                </v-flex>

                <v-flex
                  xs12
                  v-if="(existingTimeEntries && existingTimeEntries.length && calculateExistingHours(existingTimeEntries))"
                  class="time-log-info"
                >
                  <v-expansion-panel>
                    <v-expansion-panel-content>
                      <template v-slot:header>
                        <div>
                          <v-icon class="pr-1" color="blue darken-2">info</v-icon>
                          <span>
                            This user already entered
                            <span
                              class="time-log-total"
                            >{{calculateExistingHours(existingTimeEntries)}}</span> hours for the selected RFx phase and date
                          </span>
                        </div>
                      </template>
                      <v-card class="py-0">
                        <v-card-text class="mt-0 pb-2">
                          <div
                            v-for="entry in existingTimeEntries"
                            :key="entry.id"
                            class="time-log-card-row"
                          >
                            <span class="time-log-card-hrs">{{entry.hoursBilled}} Hrs</span>
                            <span v-if="entry.comments">- {{entry.comments}}</span>
                          </div>
                        </v-card-text>
                      </v-card>
                    </v-expansion-panel-content>
                  </v-expansion-panel>
                </v-flex>

                <v-flex xs12 sm5>
                  <v-text-field
                    label="Hours"
                    type="number"
                    :rules="requiredRule"
                    :min="0"
                    step="any"
                    max="24"
                    oninput="validity.valid||(value=0);"
                    @keyup="timeSheetEntry(form.hour)"
                    v-model.number="form.hour"
                    class="required"
                  ></v-text-field>
                </v-flex>

                <v-flex xs12 sm7>
                  <v-radio-group v-model="form.isBillable" :rules="requireRadioButtondRule" row>
                    <v-radio color="primary" label="Billable" :value="true"></v-radio>
                    <v-radio color="primary" label="Non-Billable" :value="false"></v-radio>
                  </v-radio-group>
                </v-flex>

                <v-flex xs12>
                  <v-textarea label="Comment" no-resize v-model="form.comment" rows="3"></v-textarea>
                </v-flex>
              </v-layout>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-flex
              xs12
              v-if="(existingTimeEntries && existingTimeEntries.length && calculateExistingHours(existingTimeEntries) && form.hour)"
            >
              <div
                class="hours-err-msg"
              >* Adding hours might overwrite the existing hours for the day for the selected project RFx</div>
            </v-flex>
            <v-btn
              class="add-new-row"
              color="primary"
              @click="saveNewRow"
              :disabled="addRecordLoading"
              :loading="addRecordLoading"
            >Save
            </v-btn>
            <v-btn @click="closeDialog">Cancel</v-btn>
          </v-card-actions>
        </v-card>
      </v-form>
    </v-dialog>
  </v-layout>
</template>
<script>
import TimesheetEntryDto from '@/domain/models/TimesheetEntry.dto';
import RFxDto from '@/domain/models/RFx.dto';
import RFxPhaseDto from '@/domain/models/RFxPhase.dto';
import ProjectDto from '@/domain/models/Project.dto';

import merge from 'object-merge';

import './addnewtimerecord.styl';
import Snackbar from '../common/Snackbar.vue';
import Spinner from '../common/Spinner.vue';
import moment from 'moment';

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
    return this.initData();
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
    timeEntry: Object,
  },
  methods: {
    open() {
      this.form.date = moment().format('YYYY-MM-DD');
      this.dialog = true;
      const referenceId = JSON.parse(localStorage.getItem('keycloak_user')).sub;
      const user = this.$store.state.users.find(value => value.referenceId === referenceId);
      if (user && user.id) {
        this.form.userId = user.id;
      }
      setTimeout(() => {
        document.getElementsByClassName(
          'v-dialog v-dialog--active',
        )[0].scrollTop = 0;
      }, 400);
    },
    closeDialog() {
      this.dialog = false;
    },
    timeSheetEntry(enteredHours) {
      if (enteredHours > 24) {
        this.form.hour = 24;
      }
    },
    reset() {
      this.$refs.form.resetValidation();
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
    initData() {
      const form = Object.assign({}, this.$props.timeEntry);
      if (!form.date) {
        form.date = moment().format('YYYY-MM-DD');
      }
      const existingTimeEntries = [];
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
        existingTimeEntries,
        addRecordLoading: false,
      };
    },
    projectRfxChanged(id) {
      const selectedRfx = this.$store.state.activeProjectRfxData.find(
        value => value.id === id,
      );
      this.form.rfxPhase = selectedRfx.rfxPhase.id;
      this.getTimeLogSelectedDate();
    },
    projectPhaseChanged() {
      this.getTimeLogSelectedDate();
    },
    projectUserChanged() {
      this.getTimeLogSelectedDate();
    },
    projectDateChanged() {
      this.getTimeLogSelectedDate();
    },
    async fetchProjectRfx(projectId) {
      this.$refs.spinner.open();
      this.$store.dispatch('fetchProjectRfx', { id: projectId }).then((ret) => {
        this.$refs.spinner.close();
        this.getTimeLogSelectedDate();
        this.$store.state.activeProjectRfxData = ret;
        return ret;
      });
    },
    saveNewRow() {
      if (this.$refs.form.validate()) {
        const formData = this.form;
        formData.hour = parseFloat(formData.hour.toFixed(2));
        const payload = this.timesheetUpdatePayload(formData);
        this.updateTimesheet(payload);
      } else {
        this.dialog = true;
      }
    },
    updateTimesheet(payload) {
      this.addRecordLoading = true;
      this.$store.dispatch('addLightTimesheet', payload).then(
        () => {
          this.addRecordLoading = false;
          this.$refs.snackbar.displaySnackbar('success', 'Time record added');
          this.dialog = false;
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
            this.$refs.snackbar.displaySnackbar(
              'error',
              'Timesheet adding failed',
            );
          }
          this.dialog = true;
          this.addRecordLoading = false;
        },
      );
    },
    handleMultipleErrors(errorList) {
      this.$refs.snackbar.displayMultipleErrorSnackbar('error', errorList);
    },
    getTimeLogSelectedDate() {
      // excecute this only when the below mentioned fields are set
      if (
        this.form
        && this.form.project
        && this.form.projectRfx
        && this.form.rfxPhase
        && this.form.userId
        && this.form.date
      ) {
        const formData = Object.assign({}, this.form);
        formData.entryDate = formData.date;

        delete formData.date;

        this.$store.dispatch('getLightTimesheet', formData).then(
          (result) => {
            if (typeof result === 'object') {
              this.existingTimeEntries = result;
            } else {
              this.existingTimeEntries = [];
            }
          },
          () => {
            this.existingTimeEntries = [];
          },
        );
      }
    },
    timesheetUpdatePayload(timesheet) {
      const payload = merge({}, timesheet, {
        userId: null,
      });

      payload.entries = [];
      // Create timesheet entries

      const timesheetRowHours = timesheet.hour;
      const timesheetRowUserId = timesheet.userId;
      const timesheetRowRfxPhaseId = timesheet.rfxPhase;
      const timesheetRowRfxTypeId = timesheet.projectRfx;
      const timesheetRowProjectId = timesheet.project;
      const timesheetcomments = timesheet.comment;
      let timesheetRowRfxPhase = null;
      let timeProjectRowRfx = null;

      const timesheetRowRfxPhaseMatches = this.$store.state.rfxPhases.filter(
        phase => phase.id === timesheetRowRfxPhaseId,
      );

      if (timesheetRowRfxPhaseMatches.length > 0) {
        [timesheetRowRfxPhase] = timesheetRowRfxPhaseMatches;
      }
      const timesheetRowProjectMatches = this.$store.state.projects.filter(
        Type => Type.id === timesheetRowProjectId,
      );

      if (timesheetRowProjectMatches.length > 0) {
        [timeProjectRowRfx] = timesheetRowProjectMatches;
      }

      const entryHoursBilled = timesheetRowHours;

      // Set start day to start of week, which in our case is Monday
      const startDate = moment(timesheet.date).day(1);
      const endDate = moment(timesheet.date).day(7);

      const timesheetEntryDto = TimesheetEntryDto.constructFromObject({
        id: null,
        userId: timesheetRowUserId,
        hoursBilled: entryHoursBilled,
        startTime: null,
        endTime: null,
        entryDate: timesheet.date,
        comments: timesheetcomments,
      });

      const rfxDto = RFxDto.constructFromObject({
        id: timesheetRowRfxTypeId,
        rfxType: null,
        rfxPhase: null,
        rfxOverview: null,
        clientResponsibilities: null,
        psdResponsibilities: null,
      });

      const rfxphaseDto = RFxPhaseDto.constructFromObject({
        id: timesheetRowRfxPhase.id,
      });

      const projectDto = ProjectDto.constructFromObject({
        id: timeProjectRowRfx.id,
        projectName: timeProjectRowRfx.projectName,
      });

      payload.entries.push(timesheetEntryDto);

      payload.isBillable = timesheet.isBillable;
      payload.userId = timesheetRowUserId;
      payload.projectRfx = rfxDto;
      payload.rfxPhase = rfxphaseDto;
      payload.project = projectDto;
      payload.startDate = startDate.format('YYYY-MM-DD');
      payload.endDate = endDate.format('YYYY-MM-DD');

      delete payload.hour;
      delete payload.comment;
      delete payload.date;

      return payload;
    },
    formatDate(date) {
      if (!date) return null;
      const [year, month, day] = date.split('-');
      return `${month}/${day}/${year}`;
    },
    parseDate(date) {
      if (!date) return null;

      const [month, day, year] = date.split('/');
      return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
    },
    calculateExistingHours(existingTimeEntries) {
      let totalHours = existingTimeEntries
        && existingTimeEntries[0]
        && existingTimeEntries[0].hoursBilled
        ? existingTimeEntries[0].hoursBilled
        : 0;
      if (existingTimeEntries.length > 1) {
        totalHours = existingTimeEntries.reduce((acc, curr) => acc.hoursBilled + curr.hoursBilled);
      }
      return totalHours;
    },
  },
};
</script>
