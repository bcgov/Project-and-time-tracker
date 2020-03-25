<template>
  <v-card>
    <spinner ref="spinner"></spinner>
    <snackbar ref="snackbar"></snackbar>
       <confirm ref="confirm"></confirm>
    <v-toolbar v-if="title" card dense color="transparent">
      <v-toolbar-title>
        <h4>{{ title }}</h4>
      </v-toolbar-title>
    </v-toolbar>
    <v-container fluid>
      <v-radio-group v-model="isResolved" row>
        <v-radio label="Logs In Progress" :value="false" isResolved></v-radio>
        <v-radio label="Resolved Logs" :value="true" isResolved></v-radio>
      </v-radio-group>
    </v-container>
    <v-divider></v-divider>

    <v-card-text class="pa-0">
      <template>
        <v-data-table
          :headers="headers"
          :items="allProcLogs"
          hide-actions
          class="elevation-0 tm-v-datatable"
          disable-initial-sort
          aria-multiline="true"
        >
          <template slot="items" slot-scope="props">
            <td class="text-xs-left">{{ props.item.logType }}</td>
            <!-- <td class="text-xs-left">{{ props.item.riskOwner }}</td> -->
            <td class="text-xs-left">{{ props.item.descriptionOfIssue }}</td>
            <td class="text-xs-left">{{ props.item.dateToClient | formatDate }}</td>
            <td class="text-xs-left">{{ props.item.notificationMethod }}</td>
            <td class="text-xs-left">{{ props.item.phaseImpactName }}</td>
            <td class="text-xs-left">{{ props.item.clientDecision }}</td>
            <td class="text-xs-left">{{ props.item.followUpDate | formatDate }}</td>
            <td width="10%" class="text-xs-left">
              <v-tooltip top>
                <template v-slot:activator="{ on }">
                  <procurement-log ref="ProcurementLog"></procurement-log>
                  <v-btn flat icon color="grey" v-on="on" @click="viewRequest(props.item.id)">
                    <v-icon>visibility</v-icon>
                  </v-btn>
                </template>
                <span>View Procurement Log</span>
              </v-tooltip>
                <v-btn
                small
                color="btnPrimary"
                class="white--text intake-table-approve-btn ma-0"
                @click="resolveLog(props.item.id)"
              >RESOLVE</v-btn>
            </td>
          </template>
        </v-data-table>
      </template>
      <v-divider></v-divider>
    </v-card-text>
  </v-card>
</template>

<script>
import Spinner from "../common/Spinner.vue";
import ProcurementLog from "./Procurementlog.vue";
import Confirm from '../common/Confirm.vue';
import Snackbar from "../common/Snackbar.vue";
export default {
  props: {
    title: String
  },
  components: {
     Snackbar,
    Spinner,
     Confirm,
    ProcurementLog
  },
  data() {
    return {
      isResolved: true,
      headers: [
        { text: "Log Type", value: "logType", align: "left", sortable: true,  width:"5%"},
        // { text: 'Risk Owner', value: 'riskOwner', sortable: false },
        {
          text: "Description of Issue",
          value: "issueDescription",
          sortable: false, width:"15%"
        },
        { text: "Date To Client", value: "dateToClient", sortable: false, width:"10%"},
        {
          text: "Method of Notification",
          value: "notificationMethod",
           sortable: false, width:"10%"
        },
        { text: "Phase Impact", value: "phaseImpactName", sortable: false, width:"10%" },
        { text: "Client Decision", value: "clientDecision", sortable: false, width:"10%"},
        {
          text: "Resolution or Follow Up Date",
          value: "followUpDate",
          sortable: false,width:"12%"
        },
        {
          text: "Action",width:"15%"
        }
      ],
      logList: this.fetchData(),
      selectedLeadUser: "",
      selectedProjectBackup: ""
    };
  },
  computed: {
    allProcLogs() {
      if (this.search) {
        return this.$store.state.allProcurementLog.filter(item => {
          return item.project.projectName
            .toLowerCase()
            .includes(this.search.toLowerCase());
        });
      }
      return this.$store.state.allProcurementLog;
    }
  },
  created() {
    this.fetchData();
  },
  methods: {
    async resolveLog(id) {
      if (
        await this.$refs.confirm.open(
          'info',
          'Are you sure you want to resolve this log?',
        )
      ) {
       const found = this.$store.state.allProcurementLog.find(
        element => element.id == id
      );
      console.log("result:", found);
      found.isResolved = true;
      console.log("new result",found);
       await this.$store
            .dispatch("updateProctLog", {
              procurementlog: found
            })
            .then(
              () => {
                this.$refs.snackbar.displaySnackbar("success", "Resolved");
              },
              err => {
                try {
                  const { message } = err.response.data.error;
                  this.$refs.snackbar.displaySnackbar("error", message);
                } catch (ex) {
                  this.$refs.snackbar.displaySnackbar(
                    "error",
                    "Failed to Resolve"
                  );
                }
              }
            );
            
      }
    },
    viewRequest(procId) {
      console.log(procId);
      console.log("complete list:", this.$store.state.allProcurementLog);
      const found = this.$store.state.allProcurementLog.find(
        element => element.id == procId
      );
      console.log("result:", found);
      this.$refs.ProcurementLog.reset();
      this.$refs.ProcurementLog.openWithValues(found);
    },
    async fetchData() {
      if (this.$refs.spinner) {
        this.$refs.spinner.open();
      }
      let procLogs = await this.$store.dispatch("fetchAllProcurementLog");
      let projRfxData = await this.$store.dispatch("fetchProjectRFxData", {
        id: this.$store.state.activeProject.id
      });
      console.log("proclogs", procLogs);
     // this.$refs.spinner.close();
      return procLogs[0];
    }
  }
};
</script>
<style scoped>
.v-input--radio-group--row .v-radio {
  display: flex;
}
.v-data-table {
  word-break: initial;
}

.pa-0 >>> .tm-v-datatable thead th:nth-child(7),
 .pa-0 >>> .tm-v-datatable thead th:nth-child(2),
   .pa-0 >>> .tm-v-datatable thead th:nth-child(6),
     .pa-0 >>> .tm-v-datatable thead th:nth-child(5),
        .pa-0 >>> .tm-v-datatable thead th:nth-child(4),
        .pa-0 >>> .tm-v-datatable thead th:nth-child(3) {
    font-size: 14px !important;
    font-weight: 700 !important;
    word-break: break-word;
    white-space: inherit !important;
}
</style>
