<template>
  <v-container grid-list-xl fluid class="custom-manage-projects-container">
    <confirm ref="confirm"></confirm>
    <snackbar ref="snackbar"></snackbar>
    <v-layout>
      <v-flex md12>
        <h1 class="projects-header">Admin &mdash; Rfx-phase</h1>
      </v-flex>
    </v-layout>
    <v-layout row wrap>
      <v-flex xs12>
        <v-layout>
          <v-flex sm-6>
            <v-btn class="btn-create" @click="createRfxPhasePrompt()">Create New</v-btn>
          </v-flex>
          <v-flex sm-6>
            <v-text-field
              class="search-bar"
              v-model="search"
              append-icon="search"
              label="Search Rfx Phase"
              single-line
              hide-details
            ></v-text-field>
          </v-flex>
        </v-layout>

        <v-data-table
          :headers="headers"
          :items="allRfxPhases"
          class="elevation-1"
          :rows-per-page-items="[15, 30, 50, 100]"
          :pagination.sync="pagination"
        >
          <template v-slot:items="props">
            <td class="text-xs-left">{{ props.item.rfxPhaseName }}</td>
            <td class="text-xs-center">
              <v-tooltip top>
                <template v-slot:activator="{ on }">
                  <v-btn flat icon color="grey" @click="editRfxPhases(props.item.id)" v-on="on">
                    <v-icon>edit</v-icon>
                  </v-btn>
                </template>
                <span>Edit</span>
              </v-tooltip>
              <v-tooltip top>
                <template v-slot:activator="{ on }">
                  <v-btn
                    flat
                    icon
                    color="grey"
                    v-on="on"
                    @click="deleteRfxPhase(props.item.id)"
                  >
                    <v-icon>delete</v-icon>
                  </v-btn>
                </template>
                <span>Delete</span>
              </v-tooltip>
            </td>
          </template>
        </v-data-table>
      </v-flex>
    </v-layout>

    <v-dialog v-model="dialog" persistent max-width="800px">
      <v-card>
        <v-form  ref="rfxPhase">
          <v-card-title>
            <span class="headline spanmargin">Rfx Phase</span>
          </v-card-title>
          <v-card-text>
            <v-container grid-list-md>
              <v-layout wrap py-2>
                <v-flex xs12>
                  <div class="v-form-container">
                    <v-text-field v-model="rfxPhaseName" label="Rfx Phase"></v-text-field>
                  </div>
                </v-flex>
              </v-layout>
            </v-container>
          </v-card-text>
        </v-form>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" class="btnposition" flat @click="closeDialog()">Close</v-btn>
          <v-btn color="blue darken-1" class="btnposition" flat @click="saveRfxPhases"
            >Save</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script>
import Confirm from '../common/Confirm.vue';
import Snackbar from '../common/Snackbar.vue';

export default {
  components: {
    Confirm,
    Snackbar,
  },
  data() {
    return {
      pagination: {
        rowsPerPage: 30,
      },
      headers: [
        { text: 'Rfx Phase', value: 'rfxPhaseName', sortable: false },
        { text: 'Action', align: 'center', sortable: false },
      ],
      dialog: false,
      rfxPhaseName: '',
      search: '',
      id: '',
    };
  },
  computed: {
    allRfxPhases() {
      if (this.search) {
        return this.$store.state.rfxPhases.filter(item => item.rfxPhaseName.toLowerCase().includes(this.search.toLowerCase()));
      }
      return this.$store.state.rfxPhases;
    },
  },
  methods: {
    checkIsDisabled(val) {
      if (val) {
        return true;
      } return false;
    },
    async saveRfxPhases() {
      if (this.$refs.rfxPhase.validate()) {
        const formData = {
          rfxPhaseName: this.rfxPhaseName,
        };
        if (this.id) {
          formData.id = this.id;
          await this.$store
            .dispatch('updateRfxPhase', {
              RfxPhase: formData,
            })
            .then(
              () => {
                this.$refs.snackbar.displaySnackbar('success', 'Successfully Updated Rfx-phase');
                this.$store.dispatch('fetchRFxPhases');
                this.closeDialog();
              },
              (err) => {
                try {
                  const { message } = err.response.data.error;
                  this.$refs.snackbar.displaySnackbar('error', message);
                } catch (ex) {
                  this.$refs.snackbar.displaySnackbar('error', 'Failed to Add Rfx-phase');
                }
              },
            );
        } else {
          await this.$store
            .dispatch('addRfxPhase', {
              RfxPhase: formData,
            })
            .then(
              () => {
                this.$refs.snackbar.displaySnackbar('success', 'Rfx-phase Added Sucessfully');
                this.$store.dispatch('fetchRFxPhases');
                this.closeDialog();
              },
              (err) => {
                try {
                  const { message } = err.response.data.error;
                  this.$refs.snackbar.displaySnackbar('error', message);
                } catch (ex) {
                  this.$refs.snackbar.displaySnackbar('error', 'Failed to Add Rfx-phase');
                }
              },
            );
        }
      }
    },
    createRfxPhasePrompt() {
      this.dialog = true;
    },
    closeDialog() {
      this.reset();
      this.dialog = false;
    },
    reset() {
      this.id = '';
      this.rfxPhaseName = '';
      this.search = '';
    },
    editRfxPhases(id) {
      const rfxPhase = this.$store.state.rfxPhases.find(element => element.id === id);
      this.rfxPhaseName = rfxPhase.rfxPhaseName;
      this.id = id;
      this.dialog = true;
    },


    async deleteRfxPhase(id) {
      if (await this.$refs.confirm.open('danger', 'Are you sure to delete this record?')) {
        const res = await this.$store.dispatch('deleteRfxPhase', { id });
        if (res === 'ERROR') {
          this.$refs.snackbar.displaySnackbar('error', 'This Rfx Phase is already used.');
        } else if (res === 'SUCCESS') {
          this.$refs.snackbar.displaySnackbar('success', 'Successfully deleted the record.');
          this.$store.dispatch('fetchRFxPhases');
        }
      }
    },
  },
  created() {
    this.$store.dispatch('fetchRFxPhases');
  },
};
</script>

<style>
.btnposition {
  margin-right: 25px !important;
}
.spanmargin {
  margin-left: 30px;
}
.btn-create {
  margin-left: 12px;
}
</style>
