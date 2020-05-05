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
        <v-menu
          ref="menu"
          v-model="menu"
          :close-on-content-click="false"
          :return-value.sync="date"
          transition="scale-transition"
          offset-y
        >
          <template v-slot:activator="{ on }">
            <v-text-field
              v-model="date"
              label="Choose Month"
              prepend-icon="event"
              readonly
              v-on="on"
              style="width:242px;"
            ></v-text-field>
          </template>
          <v-date-picker v-model="date" :show-current="true" type="month">
            <v-spacer></v-spacer>
            <v-btn text color="primary" @click="menu = false">Cancel</v-btn>
            <v-btn text color="primary" @click="datefilter(date)">OK</v-btn>
          </v-date-picker>
        </v-menu>
      </v-flex>
      <v-flex md-10>
        <div class="start-button-div">
          <v-btn
            color="primary"
            class="start-button-style"
            @click="exportToPDF"
            :disabled="this.selectedProjects && this.selectedProjects.length === 0"
            >Export Finances (PDF)</v-btn
          >
        </div>
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
          class="elevation-0 tm-v-datatable project-export-table"
          disable-initial-sort
        >
          <template slot="items" slot-scope="props">
            <td class="text-xs-left">
              <v-checkbox
                v-model="selectedProjects"
                :value="props.item.id"
                :input-value="props.selected"
              ></v-checkbox>
            </td>

            <td class="text-xs-left">{{ props.item.mou.name }}</td>
            <td class="text-xs-left">
              {{
                [
                  props.item.client.isNonMinistry
                    ? props.item.client.nonMinistryName
                    : props.item.client.ministry.ministryName,
                  props.item.orgDivision
                ].join(" ")
              }}
            </td>
            <td class="text-xs-left">{{ props.item.completionDate | formatDate }}</td>
            <td class="text-xs-left">{{ props.item.dateModified | formatDate }}</td>
          </template>
        </v-data-table>
      </template>
      <v-divider></v-divider>
    </v-card-text>
  </v-card>
</template>

<script>
// import moment from 'moment';
import jsPDF from 'jspdf';
import Confirm from '../common/Confirm.vue';
import Snackbar from '../common/Snackbar.vue';
import Spinner from '../common/Spinner.vue';
import 'jspdf-autotable';
// Vue.filter('formatDate', function(value) {
//       if (value) {
//         return moment(String(value)).format('MM/DD/YYYY hh:mm')
//       }
//     })

export default {
  props: {
    title: String,
    selectedItem: Number,
  },
  components: {
    Snackbar,
    Confirm,
    Spinner,
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
        { text: ' ', value: ' ', align: 'left', sortable: true },
        {
          text: 'MOU Name',
          value: 'mou.name',
          align: 'left',
          sortable: true,
        },
        {
          text: 'Client',
          value: 'client.ministry.ministryName',
          sortable: true,
        },
        { text: 'Project Deadline', value: 'completionDate', sortable: true },
        { text: 'Last Updated', value: 'dateModified', sortable: true },
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
    async getAllProjectList() {
      const vm = this;
      const postData = { selectedDate: this.date };
      if (vm.$refs.spinner) { vm.$refs.spinner.open(); }
      await this.$store.dispatch('fetchTimesheetProjects', postData).then(
        (res) => {
          vm.projectsList = vm.$store.state.allProjects.filter(el => res.some(f => f.id === el.id));
          if (vm.$refs.spinner) { vm.$refs.spinner.close(); }
        },
        (err) => {
          try {
            const { message } = err.response.data.error;
            vm.$refs.snackbar.displaySnackbar('error', message);
          } catch (ex) {
            // vm.$refs.snackbar.displaySnackbar('error', 'Failed to update');
          }
          if (vm.$refs.spinner) { vm.$refs.spinner.close(); }
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
      this.datefilter(this.date);
    },

    formatDate(dateStr) {
      const split = dateStr.split('T');
      if (split) {
        return split[0];
      }
      return dateStr;
    },

    async datefilter(date) {
      this.selectedProjects = [];
      if (this.$refs.menu) { this.$refs.menu.save(date); }
      this.selectedDate = date;
      if (this.$store.state.allProjects.length === 0) {
        await this.$store.dispatch('fetchAllProjects').then(
          () => {
            this.getAllProjectList();
          },
        );
      } else { this.getAllProjectList(); }
    },
    dataForPdfCreation() {
      return {};
    },
    exportToPDF() {
      let projects = this.getAllProjectIds();
      const vm = this;
      projects = projects.map(str => ({ projectId: str }));
      const pdfValues = [];
      if (projects.length) {
        vm.$refs.spinner.open();
        vm.$store
          .dispatch('financeExport', {
            selectedProjects: projects,
            selectedDate: this.date,
          })
          .then(() => {
            vm.$store.state.financeExport.forEach((entry) => {
              const exportData = JSON.parse(entry.exportData);
              pdfValues.push(exportData);
              vm.$refs.spinner.close();
            });
            if (pdfValues.length === 0) {
              return;
            }

            // ///////////// PDF FIRST PAGE START /////////////////////////////////////////////
            const doc = new jsPDF({
              putOnlyUsedFonts: true,
              orientation: 'portrait',
            });
            const tableHeaders = [
              'Client',
              'Responsibility',
              'Service Line',
              'STOB',
              'Project',
              'Amount',
            ];
            const tableRowsFormatted = pdfValues.map(proj => [
              proj.clientNo ? proj.clientNo : '',
              proj.responsibilityCenter ? proj.responsibilityCenter : '',
              proj.serviceCenter ? proj.serviceCenter : '',
              proj.stob ? proj.stob : '',
              proj.projectCode ? proj.projectCode : '',
              `$${proj.totalAmount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`,
            ]);
            const pdfSinglePageHeight = doc.internal.pageSize.height;
            const firstPageInitialCoordinate = 0;
            const secondPageInitialCoordinate = pdfSinglePageHeight + 100;
            const leftStartCoordinate = 20;
            const topStartCoordinate = 20;

            doc.setFontSize(11);
            doc.setFontStyle('bold');
            doc.text('Document # ', leftStartCoordinate, 20);
            doc.text(pdfValues[0].documentNo, leftStartCoordinate + 35, 20);
            doc.text('SAP', leftStartCoordinate + 150, 20);
            doc.text('Line Description: ', leftStartCoordinate, 30);
            doc.text(pdfValues[0].lineDesc, leftStartCoordinate + 35, 30);
            doc.setFontSize(18);
            doc.setFontStyle('normal');
            doc.autoTable(tableHeaders, tableRowsFormatted, {
              theme: 'plain',
              tableWidth: 'auto',
              margin: { top: 60 },
              styles: {
                overflow: 'linebreak',
                fontSize: 12,
                overflowColumns: 'linebreak',
              },
            });
            doc.setFontSize(11);
            doc.setFontStyle('bold');
            // doc.text('Amount Check', leftStartCoordinate + 110, 100);
            // doc.setFontSize(12);
            // doc.text('$0.00', leftStartCoordinate + 150, 100);

            // ///////////// PDF First PAGE END /////////////////////////////////////////////

            for (let i = 0; i < pdfValues.length; i++) {
              doc.addPage();
              doc.setFontStyle('normal');
              doc.setFontSize(11);

              // /// PDF SECOND PAGE HEADER //////
              doc.text("Ministry of Citizens' Services", leftStartCoordinate + 50, 15);
              doc.text(
                'Procurement and Supply, Procurement Services Branch(Stategic and Advisory Services)',
                30,
                21,
              );
              doc.text('PO Box 9476 Stn Prov Govt', leftStartCoordinate + 50, 27);
              doc.text('Victoria BC V8W 9W6', leftStartCoordinate + 55, 33);

              // /// PDF SECOND PAGE HEADER END//////

              doc.text("Ministry of Citizens' Services", 15, 55);
              doc.text('OCIO - Technology Soultions', 15, 61);

              doc.text(
                pdfValues[i].dateCreated.toString().slice(0, 10),
                leftStartCoordinate + 125,
                55,
              );
              doc.text(pdfValues[i].documentNo, leftStartCoordinate + 125, 61);
              doc.text(
                pdfValues[i].clientNo ? pdfValues[i].clientNo : '',
                leftStartCoordinate + 125,
                70,
              );
              doc.text(
                pdfValues[i].responsibilityCenter ? pdfValues[i].responsibilityCenter : '',
                leftStartCoordinate + 125,
                76,
              );
              doc.text(
                pdfValues[i].serviceCenter ? pdfValues[i].serviceCenter : '',
                leftStartCoordinate + 125,
                82,
              );
              doc.text(pdfValues[i].stob ? pdfValues[i].stob : '', leftStartCoordinate + 125, 88);
              doc.text(
                pdfValues[i].projectCode ? pdfValues[i].projectCode : '',
                leftStartCoordinate + 125,
                94,
              );

              doc.setFontSize(12);
              doc.setFontStyle('bold');
              doc.text('Notification of Charges', leftStartCoordinate + 50, 105);
              doc.setFontStyle('normal');
              doc.setFontSize(11);
              doc.text(pdfValues[i].projectName, 40, 115);
              doc.text(pdfValues[i].reference ? pdfValues[i].reference : '', 40, 122);
              doc.text(pdfValues[i].contact ? pdfValues[i].contact : '', 40, 129);

              doc.setFontStyle('bold');
              doc.text('Date', leftStartCoordinate + 110, 55);
              doc.text('Document #', leftStartCoordinate + 97, 61);
              doc.text('Client  ', leftStartCoordinate + 108, 70);
              doc.text('Responsibility', leftStartCoordinate + 93, 76);
              doc.text('ServiceLine', leftStartCoordinate + 97, 82);
              doc.text('STOB', leftStartCoordinate + 107, 88);
              doc.text('ProjectsCode', leftStartCoordinate + 93, 94);
              doc.text('Program', 15, 115);
              doc.text('Reference', 15, 122);
              doc.text('Contact', 15, 129);
              doc.text('Fees', leftStartCoordinate + 106, 160);
              doc.text('Expenses', leftStartCoordinate + 106, 169);
              doc.text('Total', leftStartCoordinate + 106, 178);
              doc.text('Contact', 15, 200);
              doc.text('Number of Pages', 15, 220);

              doc.setFontStyle('normal');
              doc.text(
                `$${pdfValues[i].fees.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`,
                leftStartCoordinate + 136,
                160,
              );
              doc.text(
                `$${pdfValues[i].expenses.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`,
                leftStartCoordinate + 136,
                169,
              );
              doc.text(
                `$${pdfValues[i].totalAmount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`,
                leftStartCoordinate + 136,
                178,
              );

              doc.text(
                pdfValues[i].contact ? pdfValues[i].contact : '',
                leftStartCoordinate + 38,
                200,
              );
              doc.text("Ministry of Citizens' Seevices", leftStartCoordinate + 38, 205);

              const res = this.date.split('-');
              const valdate = this.getDateInYYYYMMDD(
                new Date(parseInt(res[0], 10), parseInt(res[1], 10), 0),
              );
              doc.text(
                `Includes Time and Expenses up to ${new Date(valdate).toString().slice(4, 15)}`,
                leftStartCoordinate + 35,
                230,
              );
              doc.setFontStyle('italic');
              doc.text(
                'Processed by Inter-Ministry Electronic Chargeback System. Charges have already been made to ',
                15,
                260,
              );
              doc.text(
                'your account and, unless you disagree with the charges no further action required by you',
                15,
                265,
              );
              doc.addPage();
              doc.setFontStyle('normal');
              doc.setFontStyle('bold');
              doc.text('Billing Details', 15, 15);
              doc.setFontStyle('normal');
              const tableBillingDetailsHeaders = [
                'Date',
                'Description',
                'Type',
                'Resource',
                'Hours',
                'Rate',
                'Amount',
              ];
              const tableRowsBillingFormatted = pdfValues[i].details.map(proj => [
                proj.entryDate,
                proj.description ? proj.description : '',
                proj.type,
                proj.resource ? proj.resource : '',
                proj.hours ? proj.hours : '',
                proj.rate ? proj.rate : '',
                proj.amount
                  ? `$${proj.amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`
                  : '$0',
              ]);
              doc.autoTable(tableBillingDetailsHeaders, tableRowsBillingFormatted, {
                theme: 'plain',
                tableWidth: 'auto',
                margin: { top: 30 },
                styles: {
                  overflow: 'linebreak',
                  fontSize: 12,
                  overflowColumns: 'linebreak',
                },
              });

              // theme: 'striped'|'grid'|'plain'|'css'
            }

            doc.save(pdfValues[0].documentPath);
            this.getAllProjectList();
          });
      }
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
.project-export-table .v-input__slot {
  margin:0 !important;
}
.project-export-table .v-input__control {
  margin-top: 5px;
}
</style>
