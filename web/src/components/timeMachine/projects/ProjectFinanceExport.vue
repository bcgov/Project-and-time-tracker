<template>
  <v-container grid-list-xl fluid class="custom-manage-projects-container">
    <h1 class="projects-header">Finance Report</h1>
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
              style="width:50%"
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
          <v-btn color="primary" class="start-button-style" @click="exportToPDF"
            >Export Finance to PDF</v-btn
          >
        </div>
      </v-flex>
    </v-layout>
    <v-layout row wrap>
      <v-flex xs12>
        <projects-table ref="projectFinanceExport"></projects-table>
      </v-flex>
    </v-layout>
    <v-flex md12></v-flex>
  </v-container>
</template>

<script>
import Material from 'vuetify/es5/util/colors';
import jsPDF from 'jspdf';
import ProjectsTable from './ProjectTableExport.vue';
import 'jspdf-autotable';
import './projects.styl';

export default {
  components: {
    ProjectsTable,
  },
  data: () => ({
    color: Material,
    selected: 'My Projects',
    date: new Date().toISOString().substr(0, 7),
    menu: false,
    modal: false,
  }),
  computed: {},
  methods: {
    datefilter(date) {
      this.$refs.menu.save(date);
      this.$refs.projectFinanceExport.getAllProjectList(date);
    },
    dataForPdfCreation() {
      return {};
    },
    exportToPDF() {
      let projects = this.$refs.projectFinanceExport.getAllProjectIds();
      const vm = this;
      projects = projects.map(str => ({ projectId: str }));
      const pdfValues = [];
      vm.$store.dispatch('financeExport', projects).then(() => {
        debugger;
        vm.$store.state.financeExport.forEach((entry) => {
          const exportData = JSON.parse(entry.exportData);
          pdfValues.push(exportData);
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
        console.log(tableRowsFormatted);
        const pdfSinglePageHeight = doc.internal.pageSize.height;
        const firstPageInitialCoordinate = 0;
        const secondPageInitialCoordinate = pdfSinglePageHeight + 100;
        const leftStartCoordinate = 20;
        const topStartCoordinate = 20;

        console.log(tableHeaders);
        doc.setFontSize(12);
        doc.text(`Document # ${pdfValues[0].documentNo}`, leftStartCoordinate, 20);
        doc.text('SAP', leftStartCoordinate + 150, 20);
        doc.text('Line Description:', leftStartCoordinate, 30);
        doc.setFontSize(18);
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
        doc.text('Amount Check', leftStartCoordinate + 110, 100);
        doc.setFontSize(12);
        doc.text('$0.00', leftStartCoordinate + 150, 100);

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

          doc.text(pdfValues[i].dateCreated.toString().slice(0, 10), leftStartCoordinate + 125, 55);
          doc.text(pdfValues[i].documentNo, leftStartCoordinate + 125, 61);
          doc.text(pdfValues[i].clientNo ? pdfValues[i].clientNo : '', leftStartCoordinate + 125, 70);
          doc.text(pdfValues[i].responsibilityCenter ? pdfValues[i].responsibilityCenter : '', leftStartCoordinate + 125, 76);
          doc.text(pdfValues[i].serviceCenter ? pdfValues[i].serviceCenter : '', leftStartCoordinate + 125, 82);
          doc.text(pdfValues[i].stob ? pdfValues[i].stob : '', leftStartCoordinate + 125, 88);
          doc.text(pdfValues[i].projectCode ? pdfValues[i].projectCode : '', leftStartCoordinate + 125, 94);

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

          doc.text(pdfValues[i].contact ? pdfValues[i].contact : '', leftStartCoordinate + 38, 200);
          doc.text("Ministry of Citizens' Seevices", leftStartCoordinate + 38, 205);

          doc.text(
            `Includes Time and Expenses up to ${
              new Date(pdfValues[i].totalAmount).toString().slice(0, 15)}`,
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
            proj.amount ? `$${proj.amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}` : '$0',
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
        doc.save('sample.pdf');
      });
    },
  },
};
</script>
<style>
.start-button-style {
  margin-right: 6%;
  float: right;
}
</style>
