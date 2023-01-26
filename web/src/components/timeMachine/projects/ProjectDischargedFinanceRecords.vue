<template>
  <v-card>
    <confirm ref="confirm"></confirm>
    <snackbar ref="snackbar"></snackbar>
    <spinner ref="spinner"></spinner>
    <v-toolbar v-if="title" card dense color="transparent">
      <v-toolbar-title>
        <h1 class="projects-header"></h1>
      </v-toolbar-title>
    </v-toolbar>
    <v-divider></v-divider>
    <v-layout>
      <v-flex md-2>
        <ProjectCalendarMonth
                        ref="TimeCalendarMonthly"
                        @changedMonth="changedMonth"
                      ></ProjectCalendarMonth>
      </v-flex>
      <v-flex md-10>
        <!-- <div class="start-button-div">
          <v-btn color="primary" class="start-button-style" @click="exportToPDF"
            >Export Finance to PDF</v-btn
          >
        </div>-->
      </v-flex>
    </v-layout>
    <v-card-text class="pa-0">
      <template>
        <v-data-table
          v-model="selected"
          :headers="headers"
          :items="projects"
          hide-actions
          :multiple-select="singleSelect"
          class="elevation-0 tm-v-datatable"
          disable-initial-sort
        >
          <template slot="items" slot-scope="props">
            <td class="text-xs-left">{{ props.item.t_selectedMous }}</td>
            <td class="text-xs-left">
              {{ props.item.t_documentPath }}
            </td>
            <td class="text-xs-left">{{ props.item.t_documentPath.toString().slice(0, 10) }}</td>

            <td class="text-xs-left">
              <v-btn
                small
                color="btnPrimary"
                class="white--text intake-table-approve-btn ma-0"
                @click="reinstatePDF(props.item.t_documentNo)"
              >REINSTATE</v-btn>
            </td>
            <!-- <td class="text-xs-left">{{ props.item.dateModified | formatDate }}</td> -->
          </template>
        </v-data-table>
      </template>
      <v-divider></v-divider>
    </v-card-text>
  </v-card>
</template>

<script>

import Confirm from '../common/Confirm.vue';
import Snackbar from '../common/Snackbar.vue';
import Spinner from '../common/Spinner.vue';
import ProjectCalendarMonth from './ProjectCalendarMonth.vue';
import 'jspdf-autotable';


export default {
  props: {
    title: String,
    selectedItem: Number,
  },
  components: {
    Snackbar,
    Confirm,
    Spinner,
    ProjectCalendarMonth,
  },
  data() {
    return {
      singleSelect: false,
      selected: [],
      selectedProjects: [],
      date: new Date().toISOString().substr(0, 7),
      menu: false,
      modal: false,
      selectedDate: '',
      headers: [
        {
          text: 'MOU(s)',
          value: 'selectedMous',
          align: 'left',
          sortable: true,
        },
        { text: 'PDF Name', value: 'recordName', sortable: true },
        { text: 'Export Month', value: 'pdfdate', sortable: true },
        { text: 'Reinstate File', value: 'reinstate' },
      ],
      projectsList: [],
    };
  },
  computed: {
    projects() {
      // if (this.projectsList.length === 0) {
      //   this.fetchData();
      // }
      return this.projectsList;
    },
    userList() {
      return this.$store.state.users;
    },
  },
  methods: {
    changedMonth(newDate) {
      this.date = newDate;
      this.getAllProjectList();
    },
    async reinstatePDF(docNo) {
      if (
        await this.$refs.confirm.open(
          'info',
          'Are you sure to reinstate this pdf?',
        )
      ) {
        const vm = this;
        if (docNo.length) {
          vm.$refs.spinner.open();
          vm.$store.dispatch('reinstateFinanceRecords', { documentNo: docNo }).then(() => {
            this.fetchData();
          });
        }
      }
    },
    getvalue(num) {
      const value = Math.floor(num) / 1000 < 1
        ? `${parseFloat(Math.floor(num) / 1000, 1)}k`
        // eslint-disable-next-line radix
        : `${parseInt(Math.floor(num) / 1000)}k`;
      return value.toString();
    },
    async getAllProjectList() {
      const vm = this;
      const postData = {
        selectedDate: this.date,
      };
      if (vm.$refs.spinner) {
        vm.$refs.spinner.open();
      }
      await this.$store.dispatch('retrieveDischargedPdfs', postData).then(
        (res) => {
          if (vm.$refs.spinner) {
            vm.$refs.spinner.close();
          }
          vm.projectsList = res;
        },
        (err) => {
          try {
            const { message } = err.response.data.error;
            vm.$refs.snackbar.displaySnackbar('error', message);
          } catch (ex) {
            // vm.$refs.snackbar.displaySnackbar('error', 'Failed to update');
          }
          if (vm.$refs.spinner) {
            vm.$refs.spinner.close();
          }
        },
      );
    },

    getAllProjectIds() {
      return this.selectedProjects;
    },

    getDateInYYYYMMDD(date) {
      // year
      const yyyy = `${date.getFullYear()}`;
      // month
      let mm = `0${date.getMonth() + 1}`; // prepend 0 // +1 is because Jan is 0
      mm = mm.substr(mm.length - 2); // take last 2 chars
      // day
      let dd = `0${date.getDate()}`; // prepend 0
      dd = dd.substr(dd.length - 2); // take last 2 chars
      return `${yyyy}-${mm}-${dd}`;
    },

    async fetchData() {
      await this.$store.dispatch('fetchAllProjects');
      this.getAllProjectList();
    },

    formatDate(dateStr) {
      const split = dateStr.split('T');
      if (split) {
        return split[0];
      }
      return dateStr;
    },

    datefilter(date) {
      this.$refs.menu.save(date);
      this.selectedDate = date;
      this.getAllProjectList();
    },
    dataForPdfCreation() {
      return {};
    },
  },
  created() {
    this.fetchData();
  },
};
</script>
<style>
.start-button-style {
  margin-right: 6%;
  float: right;
}
.calender-box {
  width:242px;
  margin-left: 15px;
}
/* .v-picker {
  width: 100%;
} */
</style>
