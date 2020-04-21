<template>
  <v-card>
    <confirm ref="confirm"></confirm>
    <snackbar ref="snackbar"></snackbar>
    <v-toolbar v-if="title" card dense color="transparent">
      <v-toolbar-title>
        <h4>{{ title }}</h4>
      </v-toolbar-title>
    </v-toolbar>
    <v-divider></v-divider>
    {{selectedProjects}}
    <v-card-text class="pa-0">
      <template>
        <v-data-table
          v-model="selected"
          :headers="headers"
          :items="projectsList"
          hide-actions
          :multiple-select="singleSelect"
          class="elevation-0 tm-v-datatable"
          disable-initial-sort
        >
          <template slot="items" slot-scope="props">
            <td class="text-xs-left">
              <v-checkbox
                v-model="selectedProjects"
                :value="props.item.project.id"
                :input-value="props.selected"
              ></v-checkbox>
            </td>
          
            <td class="text-xs-left">{{ props.item.startDate ? props.item.startDate : '' }}</td>
             <td class="text-xs-left">{{ props.item.endDate ? props.item.endDate : '' }}</td>
            <td class="text-xs-left">{{ props.item.project.completionDate | formatDate }}</td>
            <td class="text-xs-left">{{ props.item.dateModified | formatDate }}</td>
            <td class="text-xs-left">{{ props.item.project.projectName ? props.item.project.projectName : '' }}</td>
          </template>
        </v-data-table>
      </template>
      <v-divider></v-divider>
    </v-card-text>
  </v-card>
</template>

<script>
// import moment from 'moment';
import Confirm from "../common/Confirm.vue";
import Snackbar from "../common/Snackbar.vue";

// Vue.filter('formatDate', function(value) {
//       if (value) {
//         return moment(String(value)).format('MM/DD/YYYY hh:mm')
//       }
//     })

export default {
  props: {
    title: String,
    selectedItem: Number
  },
  components: {
    Snackbar,
    Confirm
  },
  data() {
    return {
      singleSelect: false,
      selected: [],
      selectedProjects: [],
      headers: [
        { text: " ", value: " ", align: "left", sortable: true },
      
        // {
        //   text: "Project Name",
        //   value: "project.projectName",
        //   align: "left",
        //   sortable: true
        // },
        { text: "startDate", value: "startDate", align: "left", sortable: true },
        { text: "endDate", value: "endDate", sortable: false },
        { text: "Project Deadline", value: "completionDate", sortable: true },
        { text: "Last Updated", value: "dateModified", sortable: true },
         { text: "Project Name", value: "projectName", sortable: true },
      ],
      projectsList: this.getAllProjectList("")
    };
  },
  computed: {
    // projects() {
    //   // if (this.selectedItem === 1) {
    //   //   return this.$store.state.allProjects;
    //   // }
    //   return this.$store.state.projects;
    // },
    userList() {
      return this.$store.state.users;
    }
  },
  methods: {
    getAllProjectList(date = "") {
      if (date == "") {
        var currentDate = new Date().toISOString().split("T")[0];
        this.projectsList = this.$store.state.projects.filter(
          el => el.completionDate.substring(0, 7) == currentDate.substring(0,7)
        );
        return this.projectsList;
      } else {
        this.projectsList = this.$store.state.projects.filter(
          el => el.completionDate.substring(0, 7) == date
        );
        return this.projectsList;
      }
    },

    getAllProjectIds() {
      return this.selectedProjects;
    },
   async fetchData() {
     // this.$store.dispatch("fetchProjects");
     const value = await this.$store.dispatch("fetchTimesheetProjects");
     await this.$store
            .dispatch('fetchTimesheetProjects'
            // , {id: this.project.client.id,financeCodes: projectFinanceForm,}
            )
            .then(
              (res) => {
                console.log(res);
               this.projectsList =res;
              },
              (err) => {
                try {
                  const { message } = err.response.data.error;
                  this.$refs.snackbar.displaySnackbar('error', message);
                } catch (ex) {
                  this.$refs.snackbar.displaySnackbar('error', 'Failed to update');
                }
              },
            );
    },

    formatDate(dateStr) {
      const split = dateStr.split("T");
      if (split) {
        return split[0];
      }
      return dateStr;
    }
  },
  created() {
    this.fetchData();
  }
};
</script>
