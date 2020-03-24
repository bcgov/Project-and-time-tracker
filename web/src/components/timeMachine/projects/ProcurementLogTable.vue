<template>
  <v-card>
    <spinner ref="spinner"></spinner>
    <v-toolbar v-if="title" card dense color="transparent">
      <v-toolbar-title>
        <h4>{{ title }}</h4>
      </v-toolbar-title>
    </v-toolbar>
    <v-container fluid>
      <v-radio-group row>
        <v-radio label="Logs In Progress" value="radio-1"></v-radio>
        <v-radio label="Resolved Logs" value="radio-2"></v-radio>
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
             <td class="text-xs-left"><v-tooltip top>
                <template v-slot:activator="{ on }">
                  <v-btn flat icon color="grey" v-on="on" @click="viewRequest(props.item.id)">
                    <v-icon >visibility</v-icon>
                  </v-btn>
                </template>
                <span>View Procurement Log</span>
              </v-tooltip></td>
          </template>
        </v-data-table>
      </template>
      <v-divider></v-divider>
    </v-card-text>
  </v-card>
</template>

<script>
import Spinner from "../common/Spinner.vue";
export default {
  props: {
    title: String
  },
  components: {
    Spinner
  },
  data() {
    return {
      headers: [
        { text: "Log Type", value: "logType", align: "left", sortable: true },
        // { text: 'Risk Owner', value: 'riskOwner', sortable: false },
        {
          text: "Description of Issue",
          value: "issueDescription",
          sortable: false,
        },
        { text: "Date to Client", value: "dateToClient", sortable: false },
        {
          text: "Method of Notification",
          value: "notificationMethod",
          sortable: false,
        },
        { text: "Phase Impact", value: "phaseImpactName", sortable: false, },
        { text: "Client Decision", value: "clientDecision", sortable: false, },
        {
          text: "Resolution or Follow Up Date",
          value: "followUpDate",
          sortable: false,
        },
        {
          text: "Action"
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
     viewRequest(procId) {
       console.log(procId);
      // this.id = procId;
      // this.dialog = true;
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
      this.$refs.spinner.close();
      return procLogs[0];
    }
  }
};
</script>
<style scoped>
.v-input--radio-group--row .v-radio {
  display: flex;
}
</style>
