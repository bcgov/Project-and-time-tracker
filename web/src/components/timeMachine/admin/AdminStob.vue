<template>
  <v-container grid-list-xl fluid class="custom-manage-projects-container">
    <confirm ref="confirm"></confirm>
    <v-layout>
      <v-flex md12>
        <h1 class="projects-header">Admin &mdash; STOB</h1>
      </v-flex>
    </v-layout>
    <v-layout row wrap>
      <v-flex xs12>
        <v-layout>
          <v-flex sm-6>
            <v-btn @click="createStobPrompt()">Create New Stob</v-btn>
          </v-flex>
          <v-flex sm-6>
            <v-text-field
              class="search-bar"
              v-model="search"
              append-icon="search"
              label="Search Stob"
              single-line
              hide-details
            ></v-text-field>
          </v-flex>
        </v-layout>

        <v-data-table :headers="headers" :items="allStobs" class="elevation-1">
          <template v-slot:items="props">
            <td >{{ props.item.stobName }}</td>
            <td >{{ props.item.stobValue }}</td>
          </template>
        </v-data-table>
      </v-flex>
    </v-layout>

    <v-dialog v-model="dialog" persistent max-width="600px">
      <!-- <template v-slot:activator="{ on }">
        <v-btn color="primary" dark v-on="on">Open Dialog</v-btn>
      </template>-->
      <v-card>
        <v-card-title>
          <span class="headline">Create STOB</span>
        </v-card-title>
        <v-card-text>
          <v-container grid-list-md>
            <v-layout wrap>
              <v-flex xs12>
                <v-text-field v-model="newStobName" label="STOB Name" required></v-text-field>
              </v-flex>
              <v-flex xs12>
                <v-text-field v-model="newStobValue" label="STOB Value" required></v-text-field>
              </v-flex>
            </v-layout>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" flat @click="dialog = false">Close</v-btn>
          <v-btn color="blue darken-1" flat @click="createSTOB(newStobName,newStobValue)">Save</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script>
import Confirm from "../common/Confirm.vue";

export default {
  components: {
    Confirm
  },
  data() {
    return {
      headers: [
        {
          text: "STOB Name",
          align: "left",
          value: "stobName"
        },
        { text: "STOB Value", value: "stobValue" }
      ],
      dialog: false,
      newStobName: "",
      newStobValue:"",
      search: '',
    };
  },
  computed: {
    // ministries() {
    //   return this.$store.state.ministries;
    // },
    allStobs() {
      // TODO - Need to
      if (this.search){
        return this.$store.state.allStobs
          .filter(item => {
            return item.stobName
              .toLowerCase()
              .includes(this.search.toLowerCase())
          });
      }
      return this.$store.state.allStobs;
    }
  },
  methods: {
  
    createStobPrompt() {
      this.dialog = true;
    },
    async createSTOB(stobname,stobvalue) {
    //   await this.$store.dispatch("addMinistry", { ministryName: name });
    //   this.dialog = false; // Close window
    //   this.$store.dispatch("fetchAllMinistries");
    }
  },
  created() {
    this.$store.dispatch("fetchAllMinistries");
  }
};
</script>

<style>
.archived {
  text-decoration: line-through;
}
</style>
