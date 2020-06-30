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
    <v-layout style="width:50%">
      <v-flex style="float:left" md-2>
         <ProjectCalendarMonth
                        ref="TimeCalendarMonthly"
                        @changedMonth="changedMonth"
                      ></ProjectCalendarMonth>
      </v-flex>
      <v-flex md-10>

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
            <td class="text-xs-left"> {{ props.item.t_selectedMous }}</td>
            <td class="text-xs-left">
              {{ props.item.t_documentPath }}
            </td>
            <td class="text-xs-left">{{ props.item.t_documentPath.toString().slice(0, 10) }}</td>
            <td class="text-xs-left">
              <v-tooltip top v-if="!props.item.is_archived">
                <template v-slot:activator="{ on }">
                  <v-btn
                    flat
                    icon
                    class='downloadButton'
                    color="grey"
                    v-on="on"
                    @click="exportToPDF(props.item.t_documentNo)"
                  >
                    <v-icon>save_alt</v-icon>
                  </v-btn>
                </template>
                <span>Download</span>
              </v-tooltip>
            </td>
            <td class="text-xs-left">
              <v-btn
                small
                color="btnPrimary"
                class="white--text intake-table-approve-btn ma-0"
                 @click="dischargePDF(props.item.t_documentNo)"
              >DISCHARGE</v-btn>
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

import jsPDF from 'jspdf';
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
        { text: 'Download File', value: 'download', sortable: true },
        { text: 'Discharge File', value: 'discharge' },
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
    async dischargePDF(docNo) {
      if (
        await this.$refs.confirm.open(
          'info',
          'Are you sure to discharge this pdf?',
        )
      ) {
        const vm = this;
        if (docNo.length) {
          vm.$refs.spinner.open();
          vm.$store.dispatch('dischargeFinanceRecords', { documentNo: docNo }).then((res) => {
            if (res.length === 0) { vm.$refs.snackbar.displaySnackbar('error', 'Unable to discharge this record'); vm.$refs.spinner.close(); } else { this.fetchData(); }
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
      await this.$store.dispatch('fetchExportedPdfs', postData).then(
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
    exportToPDF(docNo) {
      let totalPage = 0;
      const vm = this;
      const pdfValues = [];
      if (docNo.length) {
        vm.$refs.spinner.open();
        vm.$store.dispatch('downloadFinancePdf', { documentNo: docNo }).then(() => {
          vm.$store.state.downloadFinancePdf.forEach((entry) => {
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

          // doc.text('Amount Check', leftStartCoordinate + 110, 100);
          // doc.setFontSize(12);
          // doc.text('$0.00', leftStartCoordinate + 150, 100);

          // ///////////// PDF First PAGE END /////////////////////////////////////////////

          for (let i = 0; i < pdfValues.length; i++) {
            // eslint-disable-next-line eqeqeq
            if (i != 0) doc.addPage();
            let tableRowsFormatted;
            if (!(pdfValues[i].userFinanceCodes) && i === 0) {
              tableRowsFormatted = pdfValues.map(proj => [
                proj.clientNo ? proj.clientNo : '',
                proj.responsibilityCenter ? proj.responsibilityCenter : '',
                proj.serviceCenter ? proj.serviceCenter : '',
                proj.stob ? proj.stob : '',
                proj.projectCode ? proj.projectCode : '',
                `$${proj.totalAmount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`,
              ]);
            } else {
            // eslint-disable-next-line eqeqeq
              tableRowsFormatted = pdfValues[i].userFinanceCodes.map(proj => [
                proj.clientNo ? proj.clientNo : '',
                proj.responsibilityCenter ? proj.responsibilityCenter : '',
                proj.serviceCenter ? proj.serviceCenter : '',
                proj.stob ? proj.stob : '',
                proj.projectCode ? proj.projectCode : '',
                proj.type !== 'Project' ? `-$${proj.amount.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}` : `$${proj.amount.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`,
              ]);
            }
            const pdfSinglePageHeight = doc.internal.pageSize.height;
            // eslint-disable-next-line no-unused-vars
            const firstPageInitialCoordinate = 0;
            // eslint-disable-next-line no-unused-vars
            const secondPageInitialCoordinate = pdfSinglePageHeight + 100;
            const leftStartCoordinate = 20;
            // eslint-disable-next-line no-unused-vars
            const topStartCoordinate = 20;

            doc.setFontSize(11);
            doc.setFontStyle('bold');
            // doc.text('Document # ', leftStartCoordinate, 20);
            doc.text('MOU: ', leftStartCoordinate, 20);
            let mouWithBillCount;
            if (pdfValues[i].billingCount) {
              mouWithBillCount = (pdfValues[i].billingCount ? (`${pdfValues[i].mouName}-${pdfValues[i].billingCount}`) : (pdfValues[i].mouName));
            } else {
              mouWithBillCount = pdfValues[i].mouName ? pdfValues[i].mouName : '';
            }
            doc.text(mouWithBillCount, leftStartCoordinate + 35, 20);
            doc.text('SAP', leftStartCoordinate + 150, 20);
            doc.setFontSize(18);
            doc.setFontStyle('normal');
            const prevAutoTable = doc.autoTable(tableHeaders, tableRowsFormatted, {
              theme: 'plain',
              tableWidth: 'auto',
              margin: { top: 60 },
              styles: {
                overflow: 'linebreak',
                fontSize: 12,
                overflowColumns: 'linebreak',
              },
              columnStyles: { 5: { halign: 'right' } },
              didParseCell(table) {
                if (table.section === 'head' && table.cell.raw === 'Amount') {
                  table.cell.styles.halign = 'right';
                }
              },
            });
            doc.setFontSize(11);
            doc.setFontStyle('bold');

            const { previous } = prevAutoTable.autoTable;
            doc.text('Amount Check', leftStartCoordinate + 117, previous.finalY + 10);
            doc.setFontSize(12);
            doc.text('$0.00', leftStartCoordinate + 163, previous.finalY + 10);

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
            doc.text('OCIO - Technology Solutions', 15, 61);

            doc.text(
              pdfValues[i].dateCreated.toString().slice(0, 10),
              leftStartCoordinate + 125,
              55,
            );
            doc.text(mouWithBillCount, leftStartCoordinate + 125, 61);
            doc.text(
              // eslint-disable-next-line no-nested-ternary
              pdfValues[i].userFinanceCodes ? (pdfValues[i].userFinanceCodes[0].clientNo ? pdfValues[i].userFinanceCodes[0].clientNo : '') : (pdfValues[i].clientNo ? pdfValues[i].clientNo : ''),
              leftStartCoordinate + 125,
              70,
            );
            doc.text(
              // eslint-disable-next-line no-nested-ternary
              pdfValues[i].userFinanceCodes ? (pdfValues[i].userFinanceCodes[0].responsibilityCenter ? pdfValues[i].userFinanceCodes[0].responsibilityCenter : '')
                : (pdfValues[i].responsibilityCenter ? pdfValues[i].responsibilityCenter : ''),
              leftStartCoordinate + 125,
              76,
            );
            doc.text(
              // eslint-disable-next-line max-len
              // eslint-disable-next-line no-nested-ternary
              pdfValues[i].userFinanceCodes ? pdfValues[i].userFinanceCodes[0].serviceCenter ? pdfValues[i].userFinanceCodes[0].serviceCenter : ''
                : pdfValues[i].serviceCenter ? pdfValues[i].serviceCenter : '',
              leftStartCoordinate + 125,
              82,
            );
            doc.text(
              // eslint-disable-next-line no-nested-ternary
              pdfValues[i].userFinanceCodes ? pdfValues[i].userFinanceCodes[0].stob ? pdfValues[i].userFinanceCodes[0].stob : ''
                : pdfValues[i].stob ? pdfValues[i].stob : '',
              leftStartCoordinate + 125, 88,
            );
            doc.text(
              // eslint-disable-next-line no-nested-ternary
              pdfValues[i].userFinanceCodes ? pdfValues[i].userFinanceCodes[0].projectCode ? pdfValues[i].userFinanceCodes[0].projectCode : ''
                : pdfValues[i].projectCode ? pdfValues[i].projectCode : '',
              leftStartCoordinate + 125,
              94,
            );

            doc.setFontSize(12);
            doc.setFontStyle('bold');
            doc.text('Notification of Charges', leftStartCoordinate + 50, 105);
            doc.setFontStyle('normal');
            doc.setFontSize(11);
            // this if-else condition to support old pdf version
            if (pdfValues[i].leadUser) {
              doc.text(pdfValues[i].financeName ? pdfValues[i].financeName : '', 40, 115);
              doc.text(pdfValues[i].mouName ? pdfValues[i].mouName : '', 40, 122);
              doc.text(pdfValues[i].leadUser ? pdfValues[i].leadUser : '', 40, 129);
            } else {
              doc.text(pdfValues[i].projectName, 40, 115);
              doc.text(pdfValues[i].reference ? pdfValues[i].reference : '', 40, 122);
              doc.text(pdfValues[i].contact ? pdfValues[i].contact : '', 40, 129);
            }

            doc.setFontStyle('bold');
            doc.text('Date', leftStartCoordinate + 110, 55);
            doc.text('MOU', leftStartCoordinate + 110, 61);
            doc.text('Client  ', leftStartCoordinate + 108, 70);
            doc.text('Responsibility', leftStartCoordinate + 93, 76);
            doc.text('ServiceLine', leftStartCoordinate + 97, 82);
            doc.text('STOB', leftStartCoordinate + 107, 88);
            doc.text('ProjectsCode', leftStartCoordinate + 93, 94);
            doc.text('Program', 15, 115);
            doc.text('Reference', 15, 122);
            doc.text('Contact', 15, 129);
            // doc.text('Fees', leftStartCoordinate + 106, 160);
            // doc.text('Expenses', leftStartCoordinate + 106, 169);
            // doc.text('Total', leftStartCoordinate + 106, 178);
            doc.text('Contact', 15, 200);
            doc.text('Number of Pages', 15, 220);
            doc.setFontStyle('normal');
            // doc.text(
            //   `$${pdfValues[i].fees.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`,
            //   leftStartCoordinate + 136,
            //   160,
            // );
            // doc.text(
            //   `$${pdfValues[i].expenses.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`,
            //   leftStartCoordinate + 136,
            //   169,
            // );
            // doc.text(
            //   `$${pdfValues[i].totalAmount.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`,
            //   leftStartCoordinate + 136,
            //   178,
            // );


            doc.autoTable({
              margin: { top: 150, left: 120, right: 40 },
              theme: 'plain',
              colSpan: 2,
              tableWidth: 'auto',
              cellWidth: 'wrap',
              columnStyles: {
                0: { cellWidth: 'auto', halign: 'right' }, 1: { cellWidth: 'auto', halign: 'right' } },
              styles: {
                fontSize: 11, fontStyle: 'bold',
              },
              body: [
                ['Fees:', `$${pdfValues[i].fees.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`],
                ['Expenses:', `$${pdfValues[i].expenses.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`],
                ['Total:', `$${pdfValues[i].totalAmount.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`],
              ],
            });

            doc.text(
              pdfValues[i].contact ? pdfValues[i].contact : '',
              leftStartCoordinate + 38,
              200,
            );
            doc.text("Ministry of Citizens' Services", leftStartCoordinate + 38, 205);
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
              proj.type === 'Expense' ? (proj.rate ? proj.rate : '') : (proj.rate ? proj.rate : '0'),
              proj.amount
                ? `$${proj.amount.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`
                : '$0',
            ]);
            const billTable = doc.autoTable(tableBillingDetailsHeaders, tableRowsBillingFormatted, {
              theme: 'plain',
              tableWidth: 'auto',
              margin: { top: 30 },
              styles: {
                overflow: 'linebreak',
                fontSize: 12,
                overflowColumns: 'linebreak',
              },
              columnStyles: { 6: { halign: 'right' } },
              didParseCell(table) {
                if (table.section === 'head' && table.cell.raw === 'Amount') {
                  table.cell.styles.halign = 'right';
                }
              },
            });
            // doc.setFontStyle('bold');
            const billTotalPosition = billTable.autoTable.previous;
            doc.setFontStyle('bold');
            // this if-else condition to support old pdf version
            if (pdfValues[i].mouEstimate !== undefined) {
              const finalTable = doc.autoTable({
                margin: { top: 10, left: 96 },
                theme: 'plain',
                colSpan: 2,
                tableWidth: 'auto',
                cellWidth: 'wrap',
                columnStyles: {
                  0: { cellWidth: 'auto' }, 1: { cellWidth: 'auto', halign: 'right' } },
                styles: {
                  fontSize: 11, fontStyle: 'bold',
                },
                body: [
                  ['Total Current Fees:', `$${pdfValues[i].fees ? pdfValues[i].fees.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') : '0'}`],
                  ['Total Current Expenses:', `$${pdfValues[i].expenses ? pdfValues[i].expenses.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') : '0'}`],
                  ['Total Current Billing:', `$${pdfValues[i].totalAmount ? pdfValues[i].totalAmount.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') : '0'}`],
                  ['Total Previous Billings:', `$${pdfValues[i].prevBillAmount ? pdfValues[i].prevBillAmount.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') : '0'}`],
                  ['Total Billings to Date:', `$${pdfValues[i].totalBillingToDate ? pdfValues[i].totalBillingToDate.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') : '0'}`],
                  ['MOU Estimate:', `$${pdfValues[i].mouEstimate ? pdfValues[i].mouEstimate.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') : '0'}`],
                  ['Balance Remaining on MOU:', `$${pdfValues[i].balanceMou ? pdfValues[i].balanceMou.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') : '0'}`],
                ],
              });
              const finalTablePosition = finalTable.autoTable.previous;
              doc.setPage(billTotalPosition.startPageNumber - 1);
              doc.setFontStyle('normal');
              const totalPages = totalPage === 0 ? parseInt(finalTablePosition.startPageNumber.toString()) + parseInt(finalTablePosition.pageCount.toString()) - 1 : (parseInt(finalTablePosition.startPageNumber.toString()) + parseInt(finalTablePosition.pageCount.toString()) - 1) - totalPage;
              totalPage = parseInt(totalPage.toString()) + parseInt(totalPages.toString());
              doc.text(totalPages.toString(), 58, 220);
            } else {
              doc.text('Total Amount', leftStartCoordinate + 117, billTotalPosition.finalY + 10);
              doc.setFontSize(12);
              doc.text(`$${pdfValues[i].totalAmount.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`, leftStartCoordinate + 155, billTotalPosition.finalY + 10);
            // theme: 'striped'|'grid'|'plain'|'css'
            }
            // if (!(pdfValues[i].userFinanceCodes)) { break; }
          }
          doc.save(pdfValues[0].documentPath);
        });
      }
    },
    getMonthAndYear(date) {
      if (date.length > 0) {
        const Month = new Date(`${date.toString()}-01`).toString().slice(4, 7);
        const Year = new Date(`${date.toString()}-01`).toString().slice(11, 15);
        const newDate = `${Month} ${Year}`;
        return newDate;
      }
      const newDate = new Date().toISOString().slice(0, 7);
      return newDate;
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
.downloadButton{
  margin-left: 18% !important;
  margin-bottom:3px !important;
}
/* .v-picker {
  width: 100%;
} */
</style>
