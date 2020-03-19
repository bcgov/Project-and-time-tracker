<template>
  <v-container grid-list-xl fluid class="custom-manage-projects-container">
    <snackbar ref="snackbar"></snackbar>
    <v-layout>
      <v-flex md12>
        <h1 class="projects-header">Admin &mdash; Hourly Rates</h1>
      </v-flex>
    </v-layout>
    <v-layout row wrap>
      <v-flex xs12>
        <v-layout>
          <v-data-table :headers="headers" :items="users" class="elevation-1">
            <template v-slot:items="props">
              <td>{{ props.item.contact.fullName }}</td>
              <td>
                <v-edit-dialog
                  :return-value.sync="props.item.contact.hourlyRate"
                  lazy
                  @save="save(props.item.contact)"
                  @cancel="cancel"
                  @open="open"
                  @close="close"
                >
                  {{ props.item.contact.hourlyRate ? props.item.contact.hourlyRate : 'none set' }}
                  <template
                    v-slot:input
                  >
                    <v-text-field v-model="props.item.contact.hourlyRate" label="Rate" single-line type="number"></v-text-field>
                  </template>
                </v-edit-dialog>
              </td>
            </template>
          </v-data-table>
        </v-layout>
      </v-flex>
    </v-layout>
  </v-container>
</template>
<script>
import Snackbar from "../common/Snackbar.vue";

export default {
  name: "admin-hourly-rates",
  components: {
    Snackbar
  },
  data() {
    return {
      headers: [
        { text: "Name", value: "name" },
        { text: "Rate", value: "rate" }
      ]
    };
  },
  computed: {
    users() {
      return this.$store.state.users;
      // return [];
    }
    // userList() {
    //   return this.$store.state.users;
    // }
  },
  methods: {
    fetchData() {
      console.log("fetch");
      this.$store.dispatch("fetchUsers");
    },
    async save(contact) {
      console.log("save", { contact });
      await this.$store.dispatch("updateContactPartial", {
        id: contact.id,
        hourlyRate: contact.hourlyRate
      });
      this.$refs.snackbar.displaySnackbar("success", "Data saved");
    },
    cancel() {
      this.$refs.snackbar.displaySnackbar("info", "Cancelled");
    },
    open() {
      console.log("opened");
    },
    close(x) {
      console.log("Dialog closed, update user", x);
      // const body = {id, hourlyRate}
      // can we update CONTACT via the USER service???
      // this.$store.dispatch('updateContactPartial', )
    }
  },
  created() {
    this.fetchData();
  }
};
</script>
