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
        <v-date-picker v-model="date" type="month" no-title scrollable>
          <v-spacer></v-spacer>
          <v-btn text color="primary" @click="menu = false">Cancel</v-btn>
          <v-btn text color="primary" @click="$refs.menu.save(date)">OK</v-btn>
        </v-date-picker>
      </v-menu>
    </v-flex>
    <v-flex md-10 >
      <div class="start-button-div">
      <v-btn color="primary" class="start-button-style" @click="exportToPDF">Export Finance to PDF</v-btn></div>
    </v-flex></v-layout>
    <v-layout row wrap>
      <v-flex xs12>
        <projects-table></projects-table>
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
    dataForPdfCreation() {
      return {
        heading: 'REPORTS',
        projects: [
          {
            id: '1proj',
            projectName: 'Canada BC project',
            totalAmount: '$1230',
          },
          {
            id: '2proj',
            projectName: 'Canada AD project',
            totalAmount: '$3000',
          },
          {
            id: '3proj',
            projectName: 'Canada USA project',
            totalAmount: '$5043',
          },
        ],
      };
    },
    exportToPDF() {
      const vm = this;
      const doc = new jsPDF({ putOnlyUsedFonts: true, orientation: 'landscape' });
      const pdf = this.dataForPdfCreation();
      const tableHeaders = ['id', 'Project Name', 'Total Amount'];

      // Converting the json from array of objects to array of string.
      const tableRowsFormatted = pdf.projects.map(proj => [proj.id, proj.projectName, proj.totalAmount]);
      console.log(pdf.projects);
      console.log(tableRowsFormatted);

      const pdfSinglePageHeight = doc.internal.pageSize.height;
      const firstPageInitialCoordinate = 0;
      const secondPageInitialCoordinate = pdfSinglePageHeight + 100;
      const leftStartCoordinate = 40;
      const topStartCoordinate = 40;

      console.log(tableHeaders);
      doc.text(pdf.heading, leftStartCoordinate, topStartCoordinate);
      doc.text('With border', leftStartCoordinate, 50);
      doc.autoTable(tableHeaders, tableRowsFormatted, {
        margin: { top: 60 },
      });

      doc.text('With style', leftStartCoordinate, 100);
      doc.autoTable({
        body: [
          [{ content: 'col 1-4', colSpan: 4, styles: { halign: 'center' } },
            { content: 'col 1-2', colSpan: 2, styles: { halign: 'center' } }],
          [{ content: 'col 2-4', colSpan: 2, styles: { halign: 'center' } },
            { content: 'col 2-2', colSpan: 4, styles: { halign: 'center' } }],
          [{ content: 'col 3-3left', colSpan: 2, styles: { halign: 'left' } },
            { content: 'col 3-right', colSpan: 4, styles: { halign: 'right' } }],
        ],
        theme: 'striped',
        margin: { top: 100 },
      });

      // theme: 'striped'|'grid'|'plain'|'css'

      doc.addPage();
      // changes in 2nd page
      doc.text('page 2', leftStartCoordinate, topStartCoordinate);

      doc.save('sample.pdf');
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
