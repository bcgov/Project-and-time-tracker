<template>
  <v-container grid-list-xl fluid class="custom-manage-projects-container">
    <confirm ref="confirm"></confirm>
    <v-layout>
      <v-flex md12>
        <h1 class="projects-header">Admin &mdash; Ministries</h1>
      </v-flex>
    </v-layout>
    <v-layout row wrap>
      <v-flex xs12>
        <v-layout>
          <v-flex sm-6>
            <v-btn @click="createMinistryPrompt()">Create New Ministry</v-btn>
          </v-flex>
          <v-flex sm-6>
            <v-text-field
              class="search-bar"
              v-model="search"
              append-icon="search"
              label="Search Ministry"
              single-line
              hide-details
            ></v-text-field>
          </v-flex>
        </v-layout>

        <v-data-table :headers="headers" :items="allMinistries" class="elevation-1">
          <template v-slot:items="props">
            <td v-bind:class="{ 'archived': props.item.is_archived}">{{ props.item.ministryName }}</td>

            <td v-if="!props.item.is_archived" @click="archivePrompt(props.item, true)">
              <v-btn flat color="grey">
                <v-icon>archive</v-icon>Archive
              </v-btn>
            </td>
            <td v-else @click="archivePrompt(props.item, false)">
              <v-btn flat>Restore</v-btn>
            </td>
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
          <span class="headline">Create Ministry</span>
        </v-card-title>
        <v-card-text>
          <v-container grid-list-md>
            <v-layout wrap>
              <v-flex xs12>
                <v-text-field v-model="newMinistryName" label="Ministry Name" required></v-text-field>
              </v-flex>
            </v-layout>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" flat @click="dialog = false">Close</v-btn>
          <v-btn color="blue darken-1" flat @click="createMinistry(newMinistryName)">Save</v-btn>
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
          text: "Ministry",
          align: "left",
          value: "ministryName"
        },
        { text: "Actions", value: "actions", value: "is_archived" }
      ],
      dialog: false,
      newMinistryName: "",
      search: '',
    };
  },
  computed: {
    // ministries() {
    //   return this.$store.state.ministries;
    // },
    allMinistries() {
      // TODO - Need to
      if (this.search){
        return this.$store.state.allMinistries
          .filter(item => {
            return item.ministryName
              .toLowerCase()
              .includes(this.search.toLowerCase())
          });
      }
      return this.$store.state.allMinistries;
    }
  },
  methods: {
    async archivePrompt(item, archiveVal) {
      if (
        await this.$refs.confirm.open(
          "info",
          archiveVal
            ? `Are you sure to archive ${item.ministryName}?`
            : `Are you sure you wish to UN-ARCHIVE (i.e. restore) ${item.ministryName}?`
        )
      ) {
        item.is_archived = archiveVal;
        await this.$store.dispatch("updateMinistries", item);
        this.$store.dispatch("fetchAllMinistries");
      }
    },
    createMinistryPrompt() {
      this.dialog = true;
    },
    async createMinistry(name) {
      await this.$store.dispatch("addMinistry", { ministryName: name });
      this.dialog = false; // Close window
      this.$store.dispatch("fetchAllMinistries");
      // TODO - Need to refresh!
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
