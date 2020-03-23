<template>
  <v-card>
    <spinner ref="spinner"></spinner>
    <v-toolbar v-if="title" card dense color="transparent">
      <v-toolbar-title>
        <h4>{{ title }}</h4>
      </v-toolbar-title>
    </v-toolbar>
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
            <td class="text-xs-left">{{ props.item.riskOwner }}</td>
            <td class="text-xs-left">{{ props.item.descriptionOfIssue }}</td>
            <td class="text-xs-left">{{ props.item.dateToClient | formatDate }}</td>
            <td class="text-xs-center">
              <a href>Download</a>
            </td>
            <td class="text-xs-left">{{ props.item.phaseImpactName }}</td>
            <td class="text-xs-left">{{ props.item.clientDecision }}</td>
            <td class="text-xs-center">
              <a href>Download</a>
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
export default {
  props: {
    title: String,
  },
  components: {
     Spinner
  },
  data() {
    return {
      headers: [
        { text: 'Log Type', value: 'logType', align: 'left', sortable: true },
        { text: 'Risk Owner', value: 'riskOwner', sortable: false },
        {
          text: 'Description of Issue',
          value: 'issueDescription',
          sortable: false,
        },
        { text: 'Date to Client', value: 'dateToClient', sortable: false },
        {
          text: 'Method of Notification',
          value: 'notificationMethod',
          sortable: false,
        },
        { text: 'Phase Impact', value: 'phaseImpactName', sortable: false },
        { text: 'Client Decision', value: 'clientDecision', sortable: false },
        { text: 'Resolution', value: 'resolution', sortable: false },
      ],
      logList: this.fetchData(),
      selectedLeadUser: '',
      selectedProjectBackup: '',
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
    async fetchData() {
      if (this.$refs.spinner) {
        this.$refs.spinner.open();
      }
      let procLogs = await this.$store.dispatch("fetchAllProcurementLog");
     console.log('proclogs', procLogs);
     this.$refs.spinner.close();
     return procLogs[0];
    },
  },
};
</script>
