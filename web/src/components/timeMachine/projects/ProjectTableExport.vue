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
    <v-layout>
      <v-flex md-12>
        <ProjectCalendarMonth
          ref="TimeCalendarMonthly"
          @changedMonth="changedMonth"
        ></ProjectCalendarMonth>
      </v-flex>
    </v-layout>
    <v-divider></v-divider>
    <v-layout>
      <v-flex md-2>
         <h2 class="reports-header">Out of Month Reports</h2>
        <!-- <ProjectCalendarMonth
          ref="TimeCalendarMonthly"
          @changedMonth="changedMonth"
        ></ProjectCalendarMonth> -->
      </v-flex>
      <v-flex md-10>
        <div class="start-button-div">
          <v-btn
            color="primary"
            class="start-button-style"
            @click="exportToPDFOld"
            >Export Finances Old (PDF)</v-btn
          >
        </div>
      </v-flex>
    </v-layout>
    <v-card-text class="pa-0">
      <template>
        <v-data-table
          v-model="selectedOld"
          :headers="headersOld"
          :items="projectsOld"
          hide-actions
          :multiple-select="singleSelectOld"
          class="elevation-0 tm-v-datatable project-export-table"
          disable-initial-sort
        >
          <template slot="items" slot-scope="data">
            <td class="text-xs-left">
              <v-checkbox
                @change="updateSelectedProjectsOld($event, data.item.id)"
              ></v-checkbox>
            </td>

            <td class="text-xs-left">{{ data.item.mou }}</td>
            <td class="text-xs-left">
              {{
                data.item.client
              }}
            </td>
            <td class="text-xs-left">{{ data.item.p_completionDate | formatDate }}</td>
            <td class="text-xs-left">{{ data.item.p_dateModified | formatDate }}</td>
            <td class="text-xs-left">{{ data.item.startdate }}</td>
          </template>
        </v-data-table>
      </template>
      <v-divider></v-divider>
    </v-card-text>
<v-layout>
      <v-flex md-2>
         <h2 class="reports-header">New Finance Report</h2>
        <!-- <ProjectCalendarMonth
          ref="TimeCalendarMonthly"
          @changedMonth="changedMonth"
        ></ProjectCalendarMonth> -->
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
                v-if="props.item.checkBox"
                @change="updateSelectedProjects($event, props.item.key)"
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
import jsPDF from "jspdf";
import Confirm from "../common/Confirm.vue";
import Snackbar from "../common/Snackbar.vue";
import ProjectCalendarMonth from "./ProjectCalendarMonth.vue";
import Spinner from "../common/Spinner.vue";
import "jspdf-autotable";
// Vue.filter('formatDate', function(value) {
//       if (value) {
//         return moment(String(value)).format('MM/DD/YYYY hh:mm')
//       }
//     })

export default {
  props: {
    title: String,
    selectedItem: Number,
    selectedItemOld:Number
  },
  components: {
    Snackbar,
    Confirm,
    Spinner,
    ProjectCalendarMonth
  },
  data() {
    return {
      singleSelect: false,
      singleSelectOld: false,
      selected: [],
      selectedOld: [],
      selectedProjects: [],
      selectedProjectsOld: [],
      date: new Date().toISOString().substr(0, 7),
      menu: false,
      modal: false,
      selectedDate: "",
      headers: [
        { text: " ", value: " ", align: "left", sortable: true },
        {
          text: "MOU Name",
          value: "mou.name",
          align: "left",
          sortable: true
        },
        {
          text: "Client",
          value: "client.ministry.ministryName",
          sortable: true
        },
        { text: "Project Deadline", value: "completionDate", sortable: true },
        { text: "Last Updated", value: "dateModified", sortable: true }
      ],
      headersOld: [
        { text: " ", value: " ", align: "left", sortable: true },
        {
          text: "MOU Name",
          value: "mou",
          align: "left",
          sortable: true
        },
        {
          text: "Client",
          value: "client",
          sortable: true
        },
        { text: "Project Deadline", value: "p_completionDate", sortable: true },
        { text: "Last Updated", value: "p_dateModified", sortable: true },
        { text: "Month", value: "startdate", align: "left", sortable: true }
      ],
      projectsList: [],
      projectsListOld: []
    };
  },
  computed: {
    projects() {
      return this.projectsList;
    },
    projectsOld() {
      return this.projectsListOld;
    },
    userList() {
      return this.$store.state.users;
    }
  },
  methods: {
    changedMonth(newDate) {
      this.date = newDate;
      this.getAllProjectList();
    },
    updateSelectedProjects(event, key) {
      if (event) {
        const selectedItems = this.projectsList.filter(f => f.key === key);
        selectedItems.forEach(item => {
          this.selectedProjects.push(item);
        });
      } else {
        this.selectedProjects = this.selectedProjects.filter(f => f.key !== key);
      }
    },
    updateSelectedProjectsOld(event, key) {
      if (event) {
        const selectedItems = this.projectsListOld.filter(f => f.id === key);
        selectedItems.forEach(item => {
          this.selectedProjectsOld.push(item);
        });
      } else {
        this.selectedProjectsOld = this.selectedProjectsOld.filter(f => f.id !== key);
      }
    },
    groupBy(list, keyGetter) {
      const map = new Map();
      list.forEach(item => {
        const key = keyGetter(item);
        const collection = map.get(key);
        if (!collection) {
          map.set(key, [item]);
        } else {
          collection.push(item);
        }
      });

      const projectList = [];
      for (const [k, v] of map) {
        const value = v;
        const key = k;
        for (let j = 0; j < value.length; j++) {
          const projectItem = value[j];
          projectItem.key = key;
          if (j === 0) projectItem.checkBox = true;
          else {
            projectItem.checkBox = false;
          }
          projectList.push(projectItem);
        }
      }

      return projectList;
    },
    async getAllProjectList() {
      const vm = this;
      const postData = { selectedDate: this.date };
      if (vm.$refs.spinner) {
        vm.$refs.spinner.open();
      }
      await this.$store.dispatch("fetchTimesheetProjects", postData).then(
        res => {
          const timeSheetProjects = vm.$store.state.allProjects.filter(el =>
            res.some(f => f.id === el.id)
          );
          vm.projectsList = this.groupBy(
            timeSheetProjects,
            timesheetProject => timesheetProject.mou.id
          );
          if (vm.$refs.spinner) {
            vm.$refs.spinner.close();
          }
        },
        err => {
          try {
            const { message } = err.response.data.error;
            vm.$refs.snackbar.displaySnackbar("error", message);
          } catch (ex) {
            // vm.$refs.snackbar.displaySnackbar('error', 'Failed to update');
          }
          if (vm.$refs.spinner) {
            vm.$refs.spinner.close();
          }
        }
      );

      await this.$store.dispatch("fetchTimesheetProjectsOld", postData).then(
        res => {
          //const timeSheetProjects = vm.$store.state.allProjects.filter(el => res.some(f => f.id === el.id));
          //vm.projectsListOld = this.groupBy(timeSheetProjects, timesheetProject => timesheetProject.mou.id);
          const jsonObject = res.map(JSON.stringify);
          const uniqueSet = new Set(jsonObject);
          const uniqueArray = Array.from(uniqueSet).map(JSON.parse);
          // console.log("after", uniqueArray);
          vm.projectsListOld = uniqueArray;
          if (vm.$refs.spinner) {
            vm.$refs.spinner.close();
          }
        },
        err => {
          try {
            const { message } = err.response.data.error;
            vm.$refs.snackbar.displaySnackbar("error", message);
          } catch (ex) {
            // vm.$refs.snackbar.displaySnackbar('error', 'Failed to update');
          }
          if (vm.$refs.spinner) {
            vm.$refs.spinner.close();
          }
        }
      );
    },
    arrUnique(arr) {
      const data = arr.filter((obj, pos, arr) => {
        return arr.map(mapObj => mapObj.name).indexOf(obj.name) == pos;
      });
      return data;
    },
    getAllProjectIds() {
      return this.selectedProjects;
    },
    getAllProjectIdsOld() {
      return this.selectedProjectsOld;
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
      const split = dateStr.split("T");
      if (split) {
        return split[0];
      }
      return dateStr;
    },

    async datefilter(date) {
      this.selectedProjects = [];
      if (this.$refs.menu) {
        this.$refs.menu.save(date);
      }
      this.selectedDate = date;
      if (this.$store.state.allProjects.length === 0) {
        await this.$store.dispatch("fetchAllProjects").then(() => {
          this.getAllProjectList();
        });
      } else {
        this.getAllProjectList();
      }
    },
    dataForPdfCreation() {
      return {};
    },

    exportToPDF() {
      let totalPage = 0;
      let projects = this.getAllProjectIds();
      const vm = this;
      projects = projects.map(str => ({ projectId: str.id }));
      const pdfValues = [];
      if (projects.length) {
        vm.$refs.spinner.open();
        vm.$store
          .dispatch("financeExport", {
            selectedProjects: projects,
            selectedDate: this.date
          })
          .then(() => {
            this.selectedProjects = [];

            if (vm.$store.state.financeExport.length === 0) {
              vm.$refs.spinner.close();
            }

            vm.$store.state.financeExport.forEach(entry => {
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
              orientation: "portrait"
            });
            const tableHeaders = [
              "Client",
              "Responsibility",
              "Service Line",
              "STOB",
              "Project",
              "Amount"
            ];
            // const finalRow = { amount: '$0.00', clientNo: '', projectCode: 'Amount Check', responsibilityCenter: '', serviceCenter: '', stob: '' };
            // doc.text('Amount Check', leftStartCoordinate + 110, 100);
            // doc.setFontSize(12);
            // doc.text('$0.00', leftStartCoordinate + 150, 100);

            // ///////////// PDF First PAGE END /////////////////////////////////////////////

            // pdfValues[i].userFinanceCodes.push(finalRow);
            for (let i = 0; i < pdfValues.length; i++) {
              // eslint-disable-next-line eqeqeq
              if (i != 0) doc.addPage();
              const tableRowsFormatted = pdfValues[i].userFinanceCodes.map(proj => [
                proj.clientNo ? proj.clientNo : "",
                proj.responsibilityCenter ? proj.responsibilityCenter : "",
                proj.serviceCenter ? proj.serviceCenter : "",
                proj.stob ? proj.stob : "",
                proj.projectCode ? proj.projectCode : "",
                // eslint-disable-next-line max-len
                proj.type !== "Project"
                  ? `-$${proj.amount
                      .toFixed(2)
                      .toString()
                      .replace(/\B(?=(\d{3})+(?!\d))/g, ",")}`
                  : `$${proj.amount
                      .toFixed(2)
                      .toString()
                      .replace(/\B(?=(\d{3})+(?!\d))/g, ",")}`
              ]);

              const pdfSinglePageHeight = doc.internal.pageSize.height;
              // eslint-disable-next-line no-unused-vars
              const firstPageInitialCoordinate = 0;
              // eslint-disable-next-line no-unused-vars
              const secondPageInitialCoordinate = pdfSinglePageHeight + 100;
              const leftStartCoordinate = 20;
              // eslint-disable-next-line no-unused-vars
              const topStartCoordinate = 20;

              doc.setFontSize(11);
              doc.setFontStyle("bold");
              doc.text("MOU ", leftStartCoordinate, 20);
              doc.text(
                `${pdfValues[i].mouName}-${pdfValues[i].billingCount}`,
                leftStartCoordinate + 35,
                20
              );
              doc.text("SAP", leftStartCoordinate + 150, 20);
              doc.setFontSize(18);
              doc.setFontStyle("normal");
              const prevAutoTable = doc.autoTable(tableHeaders, tableRowsFormatted, {
                theme: "plain",
                tableWidth: "auto",
                margin: { top: 60 },
                styles: {
                  overflow: "linebreak",
                  fontSize: 12,
                  overflowColumns: "linebreak"
                },
                columnStyles: { 5: { halign: "right" } },
                didParseCell(table) {
                  if (table.section === "head" && table.cell.raw === "Amount") {
                    table.cell.styles.halign = "right";
                  }
                }
              });
              doc.setFontSize(11);
              doc.setFontStyle("bold");
              const { previous } = prevAutoTable.autoTable;
              doc.text("Amount Check", leftStartCoordinate + 117, previous.finalY + 10);
              doc.setFontSize(12);
              doc.text("$0.00", leftStartCoordinate + 163, previous.finalY + 10);

              doc.addPage();
              doc.setFontStyle("normal");
              doc.setFontSize(11);

              // /// PDF SECOND PAGE HEADER //////
              doc.text("Ministry of Citizens' Services", leftStartCoordinate + 50, 15);
              doc.text(
                "Procurement and Supply, Procurement Services Branch(Stategic and Advisory Services)",
                30,
                21
              );
              doc.text("PO Box 9476 Stn Prov Govt", leftStartCoordinate + 50, 27);
              doc.text("Victoria BC V8W 9W6", leftStartCoordinate + 55, 33);

              // /// PDF SECOND PAGE HEADER END//////

              doc.text("Ministry of Citizens' Services", 15, 55);
              doc.text("OCIO - Technology Solutions", 15, 61);

              doc.text(
                pdfValues[i].dateCreated.toString().slice(0, 10),
                leftStartCoordinate + 125,
                55
              );
              doc.text(
                `${pdfValues[i].mouName}-${pdfValues[i].billingCount}`,
                leftStartCoordinate + 125,
                61
              );
              doc.text(
                pdfValues[i].userFinanceCodes[0].clientNo
                  ? pdfValues[i].userFinanceCodes[0].clientNo
                  : "",
                leftStartCoordinate + 125,
                70
              );
              doc.text(
                pdfValues[i].userFinanceCodes[0].responsibilityCenter
                  ? pdfValues[i].userFinanceCodes[0].responsibilityCenter
                  : "",
                leftStartCoordinate + 125,
                76
              );
              doc.text(
                pdfValues[i].userFinanceCodes[0].serviceCenter
                  ? pdfValues[i].userFinanceCodes[0].serviceCenter
                  : "",
                leftStartCoordinate + 125,
                82
              );
              doc.text(
                pdfValues[i].userFinanceCodes[0].stob ? pdfValues[i].userFinanceCodes[0].stob : "",
                leftStartCoordinate + 125,
                88
              );
              doc.text(
                pdfValues[i].userFinanceCodes[0].projectCode
                  ? pdfValues[i].userFinanceCodes[0].projectCode
                  : "",
                leftStartCoordinate + 125,
                94
              );

              doc.setFontSize(12);
              doc.setFontStyle("bold");
              doc.text("Notification of Charges", leftStartCoordinate + 50, 105);
              doc.setFontStyle("normal");
              doc.setFontSize(11);
              doc.text(pdfValues[i].financeName ? pdfValues[i].financeName : "", 40, 115);
              doc.text(pdfValues[i].mouName ? pdfValues[i].mouName : "", 40, 122);
              doc.text(pdfValues[i].leadUser ? pdfValues[i].leadUser : "", 40, 129);

              doc.setFontStyle("bold");
              doc.text("Date", leftStartCoordinate + 110, 55);
              doc.text("MOU", leftStartCoordinate + 110, 61);
              doc.text("Client  ", leftStartCoordinate + 108, 70);
              doc.text("Responsibility", leftStartCoordinate + 93, 76);
              doc.text("ServiceLine", leftStartCoordinate + 97, 82);
              doc.text("STOB", leftStartCoordinate + 107, 88);
              doc.text("ProjectsCode", leftStartCoordinate + 93, 94);
              doc.text("Program", 15, 115);
              doc.text("Reference", 15, 122);
              doc.text("Contact", 15, 129);
              // doc.text('Fees', leftStartCoordinate + 106, 160);
              // doc.text('Expenses', leftStartCoordinate + 106, 169);
              // doc.text('Total', leftStartCoordinate + 106, 178);
              doc.text("Contact", 15, 200);
              doc.text("Number of Pages", 15, 220);

              doc.setFontStyle("normal");
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
                theme: "plain",
                colSpan: 2,
                tableWidth: "auto",
                cellWidth: "wrap",
                columnStyles: {
                  0: { cellWidth: "auto", halign: "right" },
                  1: { cellWidth: "auto", halign: "right" }
                },
                styles: {
                  fontSize: 11,
                  fontStyle: "bold"
                },
                body: [
                  [
                    "Fees:",
                    `$${pdfValues[i].fees
                      .toFixed(2)
                      .toString()
                      .replace(/\B(?=(\d{3})+(?!\d))/g, ",")}`
                  ],
                  [
                    "Expenses:",
                    `$${pdfValues[i].expenses
                      .toFixed(2)
                      .toString()
                      .replace(/\B(?=(\d{3})+(?!\d))/g, ",")}`
                  ],
                  [
                    "Total:",
                    `$${pdfValues[i].totalAmount
                      .toFixed(2)
                      .toString()
                      .replace(/\B(?=(\d{3})+(?!\d))/g, ",")}`
                  ]
                ]
              });
              doc.text(
                pdfValues[i].contact ? pdfValues[i].contact : "",
                leftStartCoordinate + 38,
                200
              );
              doc.text("Ministry of Citizens' Services", leftStartCoordinate + 38, 205);

              const res = this.date.split("-");
              const valdate = this.getDateInYYYYMMDD(
                new Date(parseInt(res[0], 10), parseInt(res[1], 10), 0)
              );
              doc.text(
                `Includes Time and Expenses up to ${new Date(valdate).toString().slice(4, 15)}`,
                leftStartCoordinate + 35,
                230
              );
              doc.setFontStyle("italic");
              doc.text(
                "Processed by Inter-Ministry Electronic Chargeback System. Charges have already been made to ",
                15,
                260
              );
              doc.text(
                "your account and, unless you disagree with the charges no further action required by you",
                15,
                265
              );
              doc.addPage();
              doc.setFontStyle("normal");
              doc.setFontStyle("bold");
              doc.text("Billing Details", 15, 15);
              doc.setFontStyle("normal");
              const tableBillingDetailsHeaders = [
                "Date",
                "Description",
                "Type",
                "Resource",
                "Hours",
                "Rate",
                "Amount"
              ];
              const tableRowsBillingFormatted = pdfValues[i].details.map(proj => [
                proj.entryDate,
                proj.description ? proj.description : "",
                proj.type,
                proj.resource ? proj.resource : "",
                proj.hours ? proj.hours : "",
                proj.type === "Expense"
                  ? proj.rate
                    ? proj.rate
                    : ""
                  : proj.rate
                  ? proj.rate
                  : "0",
                proj.amount
                  ? `$${proj.amount
                      .toFixed(2)
                      .toString()
                      .replace(/\B(?=(\d{3})+(?!\d))/g, ",")}`
                  : "$0"
              ]);
              const billTable = doc.autoTable(
                tableBillingDetailsHeaders,
                tableRowsBillingFormatted,
                {
                  theme: "plain",
                  tableWidth: "auto",
                  margin: { top: 30 },
                  styles: {
                    overflow: "linebreak",
                    fontSize: 12,
                    overflowColumns: "linebreak"
                  },
                  columnStyles: { 6: { halign: "right" } },
                  didParseCell(table) {
                    if (table.section === "head" && table.cell.raw === "Amount") {
                      table.cell.styles.halign = "right";
                    }
                  }
                }
              );
              doc.setFontStyle("normal");
              // eslint-disable-next-line no-unused-vars
              const billTotalPosition = billTable.autoTable.previous;
              // eslint-disable-next-line no-console
              console.log("pos:", billTotalPosition);

              doc.setFontStyle("bold");
              const finalTable = doc.autoTable({
                margin: { top: 10, left: 96 },
                theme: "plain",
                colSpan: 2,
                tableWidth: "auto",
                cellWidth: "wrap",
                columnStyles: {
                  0: { cellWidth: "auto" },
                  1: { cellWidth: "auto", halign: "right" }
                },
                styles: {
                  fontSize: 11,
                  fontStyle: "bold"
                },
                body: [
                  [
                    "Total Current Fees:",
                    `$${
                      pdfValues[i].fees
                        ? pdfValues[i].fees
                            .toFixed(2)
                            .toString()
                            .replace(/\B(?=(\d{3})+(?!\d))/g, ",")
                        : "0"
                    }`
                  ],
                  [
                    "Total Current Expenses:",
                    `$${
                      pdfValues[i].expenses
                        ? pdfValues[i].expenses
                            .toFixed(2)
                            .toString()
                            .replace(/\B(?=(\d{3})+(?!\d))/g, ",")
                        : "0"
                    }`
                  ],
                  [
                    "Total Current Billing:",
                    `$${
                      pdfValues[i].totalAmount
                        ? pdfValues[i].totalAmount
                            .toFixed(2)
                            .toString()
                            .replace(/\B(?=(\d{3})+(?!\d))/g, ",")
                        : "0"
                    }`
                  ],
                  [
                    "Total Previous Billings:",
                    `$${
                      pdfValues[i].prevBillAmount
                        ? pdfValues[i].prevBillAmount
                            .toFixed(2)
                            .toString()
                            .replace(/\B(?=(\d{3})+(?!\d))/g, ",")
                        : "0"
                    }`
                  ],
                  [
                    "Total Billings to Date:",
                    `$${
                      pdfValues[i].totalBillingToDate
                        ? pdfValues[i].totalBillingToDate
                            .toFixed(2)
                            .toString()
                            .replace(/\B(?=(\d{3})+(?!\d))/g, ",")
                        : "0"
                    }`
                  ],
                  [
                    "MOU Estimate:",
                    `$${
                      pdfValues[i].mouEstimate
                        ? pdfValues[i].mouEstimate
                            .toFixed(2)
                            .toString()
                            .replace(/\B(?=(\d{3})+(?!\d))/g, ",")
                        : "0"
                    }`
                  ],
                  [
                    "Balance Remaining on MOU:",
                    `$${
                      pdfValues[i].balanceMou
                        ? pdfValues[i].balanceMou
                            .toFixed(2)
                            .toString()
                            .replace(/\B(?=(\d{3})+(?!\d))/g, ",")
                        : "0"
                    }`
                  ]
                ]
              });
              // eslint-disable-next-line radix
              const finalTablePosition = finalTable.autoTable.previous;
              doc.setPage(billTotalPosition.startPageNumber - 1);
              doc.setFontStyle("normal");
              const totalPages =
                totalPage === 0
                  ? parseInt(finalTablePosition.startPageNumber.toString()) +
                    parseInt(finalTablePosition.pageCount.toString()) -
                    1
                  : parseInt(finalTablePosition.startPageNumber.toString()) +
                    parseInt(finalTablePosition.pageCount.toString()) -
                    1 -
                    totalPage;
              totalPage = parseInt(totalPage.toString()) + parseInt(totalPages.toString());
              doc.text(totalPages.toString(), 58, 220);
            }

            // doc.text('Total Pages', 117, billTotalPosition.finalY + 10);
            doc.save(pdfValues[0].documentPath);
            this.getAllProjectList();
          });
      }
    },
    exportToPDFOld() {
      let totalPage = 0;
      let projects = this.getAllProjectIdsOld();
      const vm = this;
      console.log('before',projects);
      projects = projects.map(str => ({ projectId: str.key,month:str.startdate }));
      console.log('selected projects:',projects);

      // const pdfValues = [];
      // if (projects.length) {
      //   vm.$refs.spinner.open();
      //   vm.$store
      //     .dispatch("financeExport", {
      //       selectedProjects: projects,
      //       selectedDate: this.date
      //     })
      //     .then(() => {
      //       this.selectedProjects = [];

      //       if (vm.$store.state.financeExport.length === 0) {
      //         vm.$refs.spinner.close();
      //       }

      //       vm.$store.state.financeExport.forEach(entry => {
      //         const exportData = JSON.parse(entry.exportData);
      //         pdfValues.push(exportData);
      //         vm.$refs.spinner.close();
      //       });
      //       if (pdfValues.length === 0) {
      //         return;
      //       }

      //       // ///////////// PDF FIRST PAGE START /////////////////////////////////////////////
      //       const doc = new jsPDF({
      //         putOnlyUsedFonts: true,
      //         orientation: "portrait"
      //       });
      //       const tableHeaders = [
      //         "Client",
      //         "Responsibility",
      //         "Service Line",
      //         "STOB",
      //         "Project",
      //         "Amount"
      //       ];
      //       // const finalRow = { amount: '$0.00', clientNo: '', projectCode: 'Amount Check', responsibilityCenter: '', serviceCenter: '', stob: '' };
      //       // doc.text('Amount Check', leftStartCoordinate + 110, 100);
      //       // doc.setFontSize(12);
      //       // doc.text('$0.00', leftStartCoordinate + 150, 100);

      //       // ///////////// PDF First PAGE END /////////////////////////////////////////////

      //       // pdfValues[i].userFinanceCodes.push(finalRow);
      //       for (let i = 0; i < pdfValues.length; i++) {
      //         // eslint-disable-next-line eqeqeq
      //         if (i != 0) doc.addPage();
      //         const tableRowsFormatted = pdfValues[i].userFinanceCodes.map(proj => [
      //           proj.clientNo ? proj.clientNo : "",
      //           proj.responsibilityCenter ? proj.responsibilityCenter : "",
      //           proj.serviceCenter ? proj.serviceCenter : "",
      //           proj.stob ? proj.stob : "",
      //           proj.projectCode ? proj.projectCode : "",
      //           // eslint-disable-next-line max-len
      //           proj.type !== "Project"
      //             ? `-$${proj.amount
      //                 .toFixed(2)
      //                 .toString()
      //                 .replace(/\B(?=(\d{3})+(?!\d))/g, ",")}`
      //             : `$${proj.amount
      //                 .toFixed(2)
      //                 .toString()
      //                 .replace(/\B(?=(\d{3})+(?!\d))/g, ",")}`
      //         ]);

      //         const pdfSinglePageHeight = doc.internal.pageSize.height;
      //         // eslint-disable-next-line no-unused-vars
      //         const firstPageInitialCoordinate = 0;
      //         // eslint-disable-next-line no-unused-vars
      //         const secondPageInitialCoordinate = pdfSinglePageHeight + 100;
      //         const leftStartCoordinate = 20;
      //         // eslint-disable-next-line no-unused-vars
      //         const topStartCoordinate = 20;

      //         doc.setFontSize(11);
      //         doc.setFontStyle("bold");
      //         doc.text("MOU ", leftStartCoordinate, 20);
      //         doc.text(
      //           `${pdfValues[i].mouName}-${pdfValues[i].billingCount}`,
      //           leftStartCoordinate + 35,
      //           20
      //         );
      //         doc.text("SAP", leftStartCoordinate + 150, 20);
      //         doc.setFontSize(18);
      //         doc.setFontStyle("normal");
      //         const prevAutoTable = doc.autoTable(tableHeaders, tableRowsFormatted, {
      //           theme: "plain",
      //           tableWidth: "auto",
      //           margin: { top: 60 },
      //           styles: {
      //             overflow: "linebreak",
      //             fontSize: 12,
      //             overflowColumns: "linebreak"
      //           },
      //           columnStyles: { 5: { halign: "right" } },
      //           didParseCell(table) {
      //             if (table.section === "head" && table.cell.raw === "Amount") {
      //               table.cell.styles.halign = "right";
      //             }
      //           }
      //         });
      //         doc.setFontSize(11);
      //         doc.setFontStyle("bold");
      //         const { previous } = prevAutoTable.autoTable;
      //         doc.text("Amount Check", leftStartCoordinate + 117, previous.finalY + 10);
      //         doc.setFontSize(12);
      //         doc.text("$0.00", leftStartCoordinate + 163, previous.finalY + 10);

      //         doc.addPage();
      //         doc.setFontStyle("normal");
      //         doc.setFontSize(11);

      //         // /// PDF SECOND PAGE HEADER //////
      //         doc.text("Ministry of Citizens' Services", leftStartCoordinate + 50, 15);
      //         doc.text(
      //           "Procurement and Supply, Procurement Services Branch(Stategic and Advisory Services)",
      //           30,
      //           21
      //         );
      //         doc.text("PO Box 9476 Stn Prov Govt", leftStartCoordinate + 50, 27);
      //         doc.text("Victoria BC V8W 9W6", leftStartCoordinate + 55, 33);

      //         // /// PDF SECOND PAGE HEADER END//////

      //         doc.text("Ministry of Citizens' Services", 15, 55);
      //         doc.text("OCIO - Technology Solutions", 15, 61);

      //         doc.text(
      //           pdfValues[i].dateCreated.toString().slice(0, 10),
      //           leftStartCoordinate + 125,
      //           55
      //         );
      //         doc.text(
      //           `${pdfValues[i].mouName}-${pdfValues[i].billingCount}`,
      //           leftStartCoordinate + 125,
      //           61
      //         );
      //         doc.text(
      //           pdfValues[i].userFinanceCodes[0].clientNo
      //             ? pdfValues[i].userFinanceCodes[0].clientNo
      //             : "",
      //           leftStartCoordinate + 125,
      //           70
      //         );
      //         doc.text(
      //           pdfValues[i].userFinanceCodes[0].responsibilityCenter
      //             ? pdfValues[i].userFinanceCodes[0].responsibilityCenter
      //             : "",
      //           leftStartCoordinate + 125,
      //           76
      //         );
      //         doc.text(
      //           pdfValues[i].userFinanceCodes[0].serviceCenter
      //             ? pdfValues[i].userFinanceCodes[0].serviceCenter
      //             : "",
      //           leftStartCoordinate + 125,
      //           82
      //         );
      //         doc.text(
      //           pdfValues[i].userFinanceCodes[0].stob ? pdfValues[i].userFinanceCodes[0].stob : "",
      //           leftStartCoordinate + 125,
      //           88
      //         );
      //         doc.text(
      //           pdfValues[i].userFinanceCodes[0].projectCode
      //             ? pdfValues[i].userFinanceCodes[0].projectCode
      //             : "",
      //           leftStartCoordinate + 125,
      //           94
      //         );

      //         doc.setFontSize(12);
      //         doc.setFontStyle("bold");
      //         doc.text("Notification of Charges", leftStartCoordinate + 50, 105);
      //         doc.setFontStyle("normal");
      //         doc.setFontSize(11);
      //         doc.text(pdfValues[i].financeName ? pdfValues[i].financeName : "", 40, 115);
      //         doc.text(pdfValues[i].mouName ? pdfValues[i].mouName : "", 40, 122);
      //         doc.text(pdfValues[i].leadUser ? pdfValues[i].leadUser : "", 40, 129);

      //         doc.setFontStyle("bold");
      //         doc.text("Date", leftStartCoordinate + 110, 55);
      //         doc.text("MOU", leftStartCoordinate + 110, 61);
      //         doc.text("Client  ", leftStartCoordinate + 108, 70);
      //         doc.text("Responsibility", leftStartCoordinate + 93, 76);
      //         doc.text("ServiceLine", leftStartCoordinate + 97, 82);
      //         doc.text("STOB", leftStartCoordinate + 107, 88);
      //         doc.text("ProjectsCode", leftStartCoordinate + 93, 94);
      //         doc.text("Program", 15, 115);
      //         doc.text("Reference", 15, 122);
      //         doc.text("Contact", 15, 129);
      //         // doc.text('Fees', leftStartCoordinate + 106, 160);
      //         // doc.text('Expenses', leftStartCoordinate + 106, 169);
      //         // doc.text('Total', leftStartCoordinate + 106, 178);
      //         doc.text("Contact", 15, 200);
      //         doc.text("Number of Pages", 15, 220);

      //         doc.setFontStyle("normal");
      //         // doc.text(
      //         //   `$${pdfValues[i].fees.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`,
      //         //   leftStartCoordinate + 136,
      //         //   160,
      //         // );
      //         // doc.text(
      //         //   `$${pdfValues[i].expenses.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`,
      //         //   leftStartCoordinate + 136,
      //         //   169,
      //         // );
      //         // doc.text(
      //         //   `$${pdfValues[i].totalAmount.toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`,
      //         //   leftStartCoordinate + 136,
      //         //   178,
      //         // );
      //         doc.autoTable({
      //           margin: { top: 150, left: 120, right: 40 },
      //           theme: "plain",
      //           colSpan: 2,
      //           tableWidth: "auto",
      //           cellWidth: "wrap",
      //           columnStyles: {
      //             0: { cellWidth: "auto", halign: "right" },
      //             1: { cellWidth: "auto", halign: "right" }
      //           },
      //           styles: {
      //             fontSize: 11,
      //             fontStyle: "bold"
      //           },
      //           body: [
      //             [
      //               "Fees:",
      //               `$${pdfValues[i].fees
      //                 .toFixed(2)
      //                 .toString()
      //                 .replace(/\B(?=(\d{3})+(?!\d))/g, ",")}`
      //             ],
      //             [
      //               "Expenses:",
      //               `$${pdfValues[i].expenses
      //                 .toFixed(2)
      //                 .toString()
      //                 .replace(/\B(?=(\d{3})+(?!\d))/g, ",")}`
      //             ],
      //             [
      //               "Total:",
      //               `$${pdfValues[i].totalAmount
      //                 .toFixed(2)
      //                 .toString()
      //                 .replace(/\B(?=(\d{3})+(?!\d))/g, ",")}`
      //             ]
      //           ]
      //         });
      //         doc.text(
      //           pdfValues[i].contact ? pdfValues[i].contact : "",
      //           leftStartCoordinate + 38,
      //           200
      //         );
      //         doc.text("Ministry of Citizens' Services", leftStartCoordinate + 38, 205);

      //         const res = this.date.split("-");
      //         const valdate = this.getDateInYYYYMMDD(
      //           new Date(parseInt(res[0], 10), parseInt(res[1], 10), 0)
      //         );
      //         doc.text(
      //           `Includes Time and Expenses up to ${new Date(valdate).toString().slice(4, 15)}`,
      //           leftStartCoordinate + 35,
      //           230
      //         );
      //         doc.setFontStyle("italic");
      //         doc.text(
      //           "Processed by Inter-Ministry Electronic Chargeback System. Charges have already been made to ",
      //           15,
      //           260
      //         );
      //         doc.text(
      //           "your account and, unless you disagree with the charges no further action required by you",
      //           15,
      //           265
      //         );
      //         doc.addPage();
      //         doc.setFontStyle("normal");
      //         doc.setFontStyle("bold");
      //         doc.text("Billing Details", 15, 15);
      //         doc.setFontStyle("normal");
      //         const tableBillingDetailsHeaders = [
      //           "Date",
      //           "Description",
      //           "Type",
      //           "Resource",
      //           "Hours",
      //           "Rate",
      //           "Amount"
      //         ];
      //         const tableRowsBillingFormatted = pdfValues[i].details.map(proj => [
      //           proj.entryDate,
      //           proj.description ? proj.description : "",
      //           proj.type,
      //           proj.resource ? proj.resource : "",
      //           proj.hours ? proj.hours : "",
      //           proj.type === "Expense"
      //             ? proj.rate
      //               ? proj.rate
      //               : ""
      //             : proj.rate
      //             ? proj.rate
      //             : "0",
      //           proj.amount
      //             ? `$${proj.amount
      //                 .toFixed(2)
      //                 .toString()
      //                 .replace(/\B(?=(\d{3})+(?!\d))/g, ",")}`
      //             : "$0"
      //         ]);
      //         const billTable = doc.autoTable(
      //           tableBillingDetailsHeaders,
      //           tableRowsBillingFormatted,
      //           {
      //             theme: "plain",
      //             tableWidth: "auto",
      //             margin: { top: 30 },
      //             styles: {
      //               overflow: "linebreak",
      //               fontSize: 12,
      //               overflowColumns: "linebreak"
      //             },
      //             columnStyles: { 6: { halign: "right" } },
      //             didParseCell(table) {
      //               if (table.section === "head" && table.cell.raw === "Amount") {
      //                 table.cell.styles.halign = "right";
      //               }
      //             }
      //           }
      //         );
      //         doc.setFontStyle("normal");
      //         // eslint-disable-next-line no-unused-vars
      //         const billTotalPosition = billTable.autoTable.previous;
      //         // eslint-disable-next-line no-console
      //         console.log("pos:", billTotalPosition);

      //         doc.setFontStyle("bold");
      //         const finalTable = doc.autoTable({
      //           margin: { top: 10, left: 96 },
      //           theme: "plain",
      //           colSpan: 2,
      //           tableWidth: "auto",
      //           cellWidth: "wrap",
      //           columnStyles: {
      //             0: { cellWidth: "auto" },
      //             1: { cellWidth: "auto", halign: "right" }
      //           },
      //           styles: {
      //             fontSize: 11,
      //             fontStyle: "bold"
      //           },
      //           body: [
      //             [
      //               "Total Current Fees:",
      //               `$${
      //                 pdfValues[i].fees
      //                   ? pdfValues[i].fees
      //                       .toFixed(2)
      //                       .toString()
      //                       .replace(/\B(?=(\d{3})+(?!\d))/g, ",")
      //                   : "0"
      //               }`
      //             ],
      //             [
      //               "Total Current Expenses:",
      //               `$${
      //                 pdfValues[i].expenses
      //                   ? pdfValues[i].expenses
      //                       .toFixed(2)
      //                       .toString()
      //                       .replace(/\B(?=(\d{3})+(?!\d))/g, ",")
      //                   : "0"
      //               }`
      //             ],
      //             [
      //               "Total Current Billing:",
      //               `$${
      //                 pdfValues[i].totalAmount
      //                   ? pdfValues[i].totalAmount
      //                       .toFixed(2)
      //                       .toString()
      //                       .replace(/\B(?=(\d{3})+(?!\d))/g, ",")
      //                   : "0"
      //               }`
      //             ],
      //             [
      //               "Total Previous Billings:",
      //               `$${
      //                 pdfValues[i].prevBillAmount
      //                   ? pdfValues[i].prevBillAmount
      //                       .toFixed(2)
      //                       .toString()
      //                       .replace(/\B(?=(\d{3})+(?!\d))/g, ",")
      //                   : "0"
      //               }`
      //             ],
      //             [
      //               "Total Billings to Date:",
      //               `$${
      //                 pdfValues[i].totalBillingToDate
      //                   ? pdfValues[i].totalBillingToDate
      //                       .toFixed(2)
      //                       .toString()
      //                       .replace(/\B(?=(\d{3})+(?!\d))/g, ",")
      //                   : "0"
      //               }`
      //             ],
      //             [
      //               "MOU Estimate:",
      //               `$${
      //                 pdfValues[i].mouEstimate
      //                   ? pdfValues[i].mouEstimate
      //                       .toFixed(2)
      //                       .toString()
      //                       .replace(/\B(?=(\d{3})+(?!\d))/g, ",")
      //                   : "0"
      //               }`
      //             ],
      //             [
      //               "Balance Remaining on MOU:",
      //               `$${
      //                 pdfValues[i].balanceMou
      //                   ? pdfValues[i].balanceMou
      //                       .toFixed(2)
      //                       .toString()
      //                       .replace(/\B(?=(\d{3})+(?!\d))/g, ",")
      //                   : "0"
      //               }`
      //             ]
      //           ]
      //         });
      //         // eslint-disable-next-line radix
      //         const finalTablePosition = finalTable.autoTable.previous;
      //         doc.setPage(billTotalPosition.startPageNumber - 1);
      //         doc.setFontStyle("normal");
      //         const totalPages =
      //           totalPage === 0
      //             ? parseInt(finalTablePosition.startPageNumber.toString()) +
      //               parseInt(finalTablePosition.pageCount.toString()) -
      //               1
      //             : parseInt(finalTablePosition.startPageNumber.toString()) +
      //               parseInt(finalTablePosition.pageCount.toString()) -
      //               1 -
      //               totalPage;
      //         totalPage = parseInt(totalPage.toString()) + parseInt(totalPages.toString());
      //         doc.text(totalPages.toString(), 58, 220);
      //       }

      //       // doc.text('Total Pages', 117, billTotalPosition.finalY + 10);
      //       doc.save(pdfValues[0].documentPath);
      //       this.getAllProjectList();
      //     });
      // }
    }
  },
  created() {
    this.fetchData();
  }
};
</script>
<style>
.start-button-style {
  margin-right: 6%;
  float: right;
}
.project-export-table .v-input__slot {
  margin: 0 !important;
}
.project-export-table .v-input__control {
  margin-top: 5px;
}
.calender-box {
  width: 242px;
  margin-left: 15px;
}
.reports-header {
      font-size: 20px;
      margin-left: 1.5em;
}
</style>
