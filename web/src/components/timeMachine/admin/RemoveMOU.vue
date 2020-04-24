<template>
  <v-container grid-list-xl fluid class="custom-manage-projects-container">
    <snackbar ref="snackbar"></snackbar>
    <confirm ref="confirm"></confirm>
    <v-layout>
      <v-flex md12>
        <h1 class="projects-header">Admin &mdash; Remove MOU</h1>
      </v-flex>
    </v-layout>
    <v-layout row wrap>
      <v-flex>
        <v-data-table
          :headers="headers"
          :items="mouList"
          hide-actions
          class="elevation-0 tm-v-datatable"
        >
          <template v-slot:items="props">
            <td class="text-xs-left">{{ props.item.name }}</td>
            <td class="text-xs-left">
              <v-tooltip top v-if="checkdelete(props.item.id)">
                <template v-slot:activator="{ on }">
                  <v-btn flat icon color="grey" v-on="on" @click="deleteRequest(props.item.id)">
                    <v-icon>delete</v-icon>
                  </v-btn>
                </template>
                <span>Delete</span>
              </v-tooltip>
              <span v-else>Already Assigned</span>
            </td>
            <!-- <td>
              <v-edit-dialog
                :return-value.sync="props.item.contact.hourlyRate"
                lazy
                @save="save(props.item.contact)"
                @cancel="cancel"
                @open="open"
                @close="close"
              >
                {{ props.item.contact.hourlyRate ? `$${props.item.contact.hourlyRate}/hr` : 'n/a - click to set' }}
                <template
                  v-slot:input
                >
                  <v-text-field
                    v-model="props.item.contact.hourlyRate"
                    label="Rate"
                    single-line
                    type="number"
                  ></v-text-field>
                </template>
              </v-edit-dialog>
            </td>-->
          </template>
        </v-data-table>
        <!-- </v-layout> -->
      </v-flex>
    </v-layout>
  </v-container>
</template>
<script>
import Snackbar from "../common/Snackbar.vue";
import Confirm from "../common/Confirm.vue";

export default {
  name: "admin-remove-mou",
  components: {
    Snackbar,
    Confirm
  },
  data() {
    return {
      headers: [
        { text: "MOU", value: "fullName" },
        { text: "Action", value: "" }
      ]
    };
  },
  computed: {
    mouList() {
      return this.$store.state.mouList;
    }
  },
  methods: {
    checkdelete(id) {
      const projectMOU = this.$store.state.allProjects.find(
        item => item.mou && item.mou.id === id
      );

      if (projectMOU) {
        return false;
      } else {
        return true;
      }
    },
    async fetchData() {
      if (this.$store.state.allProjects.length == 0)
        await this.$store.dispatch("fetchAllProjects");
      if (this.$store.state.mouList.length == 0)
        await this.$store.dispatch("fetchMOUs");
    },
    async deleteRequest(id) {
      if (
        await this.$refs.confirm.open(
          "danger",
          "Are you sure you wish to delete this MOU?"
        )
      ) {
        await this.$store.dispatch("deleteMOUs", { id });
        await this.$store.dispatch("fetchMOUs");
        this.$refs.snackbar.displaySnackbar("success", "Deleted.");
      }
    },
    cancel() {
      this.$refs.snackbar.displaySnackbar("info", "Cancelled");
    },
    open() {},
    close() {}
  },
  created() {
    this.fetchData();
  }
};
</script>
