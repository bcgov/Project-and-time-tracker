<template>
  <v-card>
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
          :items="logList"
          hide-actions
          class="elevation-0 tm-v-datatable"
          disable-initial-sort
        >
          <template slot="items" slot-scope="props">
            <td class="text-xs-left">{{ props.item.logType }}</td>
            <td class="text-xs-left">{{ props.item.riskOwner }}</td>
            <td class="text-xs-left">{{ props.item.issueDescription }}</td>
            <td class="text-xs-left">{{ props.item.clientDate }}</td>
            <td class="text-xs-center">
              <a href>Download</a>
            </td>
            <td class="text-xs-left">{{ props.item.phaseImpact }}</td>
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
export default {
  props: {
    title: String,
  },
  components: {},
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
        { text: 'Date to Client', value: 'clientDate', sortable: false },
        {
          text: 'Method of Notification',
          value: 'notificationMethod',
          sortable: false,
        },
        { text: 'Phase Impact', value: 'phaseImpact', sortable: false },
        { text: 'Client Decision', value: 'clientDecision', sortable: false },
        { text: 'Resolution', value: 'resolution', sortable: false },
      ],
      logList: [
        {
          id: 1,
          logType: 'Contact Update',
          riskOwner: 'Jan 20,2020',
          issueDescription: '',
          clientDate: '',
          notificationMethod: '',
          phaseImpact: '',
          clientDecision: '',
          resolution: '',
        },
        {
          id: 2,
          logType: 'RFx update',
          riskOwner: 'Jan 20,2020',
          issueDescription: '',
          clientDate: '',
          notificationMethod: '',
          phaseImpact: '',
          clientDecision: '',
          resolution: '',
        },
        {
          id: 3,
          logType: 'Project lead',
          riskOwner: 'Jan 20,2020',
          issueDescription: '',
          clientDate: '',
          notificationMethod: '',
          phaseImpact: '',
          clientDecision: '',
          resolution: '',
        },
        {
          id: 4,
          logType: 'Risk Assessment',
          riskOwner: 'Jan 20,2020',
          issueDescription: '',
          clientDate: '',
          notificationMethod: '',
          phaseImpact: '',
          clientDecision: '',
          resolution: '',
        },
      ],
      selectedLeadUser: '',
      selectedProjectBackup: '',
    };
  },
  computed: {},
  methods: {},
};
</script>
