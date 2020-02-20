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
        <p>Welcome to ministries list</p>
        <ul>
          <li><b>TODO</b></li>
          <li>Create New Ministries</li>
          <li>Un-Archive</li>
          <li>Style archived text strike-out</li>
          <li>See Archived?</li>
        </ul>

        <v-btn>Create New Ministry</v-btn>

        <v-data-table :headers="headers" :items="allMinistries" class="elevation-1">
          <template v-slot:items="props">
            <td v-bind:class="{ 'archived': props.item.is_archived}">{{ props.item.ministryName }}</td>

            <td v-if="!props.item.is_archived" @click="archivePrompt(props.item, true)">
              <v-btn flat color="grey">
                <v-icon>archive</v-icon>
                Archive
              </v-btn>
            </td>
            <td v-else @click="archivePrompt(props.item, false)">
              <v-btn flat >
              Restore
              </v-btn>
            </td>
          </template>
        </v-data-table>
      </v-flex>
    </v-layout>
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
      ]
    };
  },
  computed: {
    ministries() {
      return this.$store.state.ministries;
    },
    allMinistries(){
      // TODO - Need to
      return this.$store.state.allMinistries;
    },
  },
  methods: {
    async archivePrompt(item, archiveVal) {
      if (
        await this.$refs.confirm.open(
          "info",
          archiveVal ? `Are you sure to archive ${item.ministryName}?`
          : `Are you sure you wish to UN-ARCHIVE (i.e. restore) ${item.ministryName}?`
        )
      ) {
        item.is_archived = archiveVal;
        await this.$store.dispatch("updateMinistries", item);
        this.$store.dispatch("fetchAllMinistries");
      }
    },
  },
  created(){
    this.$store.dispatch('fetchAllMinistries');
  }
};
</script>

<style>
.archived {
  text-decoration: line-through;
}
</style>
