<template>
  <v-container grid-list-xl fluid class="custom-manage-projects-container">
    <confirm ref="confirm"></confirm>
    <snackbar ref="snackbar"></snackbar>
    <v-layout>
      <v-flex md12>
        <h1 class="projects-header">Admin &mdash; Rfx-type</h1>
      </v-flex>
    </v-layout>
    <v-layout row wrap>
      <v-flex xs12>
        <v-layout>
          <v-flex sm-6>
            <v-btn class="btn-create" @click="createRfxTypePrompt()">Create New</v-btn>
          </v-flex>
          <v-flex sm-6>
            <v-text-field
              class="search-bar"
              v-model="search"
              append-icon="search"
              label="Search rfx Type Name"
              single-line
              hide-details
            ></v-text-field>
          </v-flex>
        </v-layout>

        <v-data-table
          :headers="headers"
          :items="allRfxTypes"
          class="elevation-1"
          :rows-per-page-items="[15, 30, 50, 100]"
          :pagination.sync="pagination"
        >
          <template v-slot:items="props">
            <td class="text-xs-left">{{ props.item.rfxTypeName }}</td>
            <td class="text-xs-center">
              <v-tooltip top>
                <template v-slot:activator="{ on }">
                  <v-btn flat icon color="grey" @click="editRfxTypes(props.item.id)" v-on="on">
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
                    @click="deleteRfxType(props.item.id)"
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
            <span class="headline spanmargin">Rfx-type</span>
          </v-card-title>
          <v-card-text>
            <v-container grid-list-md>
              <v-layout wrap py-2>
                <v-flex xs12>
                  <div class="v-form-container">
                    <v-text-field v-model="rfxTypeName" label="Rfx-type Name"></v-text-field>
                  </div>
                </v-flex>
              </v-layout>
            </v-container>
          </v-card-text>
        </v-form>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" class="btnposition" flat @click="closeDialog()">Close</v-btn>
          <v-btn color="blue darken-1" class="btnposition" flat @click="saveRfxTypes"
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
        { text: 'Rfx-type Name', value: 'rfxTypeName', sortable: false },
        { text: 'Action', align: 'center', sortable: false },
      ],
      dialog: false,
      rfxTypeName: '',
      search: '',
      id: '',
    };
  },
  computed: {
    allRfxTypes() {
      if (this.search) {
        return this.$store.state.rfxTypes.filter(item => item.rfxTypeName.toLowerCase().includes(this.search.toLowerCase()));
      }
      return this.$store.state.rfxTypes;
    },
  },
  methods: {
    checkIsDisabled(val) {
      if (val) {
        return true;
      } return false;
    },
    async saveRfxTypes() {
      if (this.$refs.rfxPhase.validate()) {
        const formData = {
          rfxTypeName: this.rfxTypeName,
        };
        if (this.id) {
          formData.id = this.id;
          await this.$store
            .dispatch('updateRfxType', {
              RfxType: formData,
            })
            .then(
              () => {
                this.$refs.snackbar.displaySnackbar('success', 'Successfully Updated Rfx-type');
                this.$store.dispatch('fetchRFxTypes');
                this.closeDialog();
              },
              (err) => {
                try {
                  const { message } = err.response.data.error;
                  this.$refs.snackbar.displaySnackbar('error', message);
                } catch (ex) {
                  this.$refs.snackbar.displaySnackbar('error', 'Failed to Add Rfx-type');
                }
              },
            );
        } else {
          await this.$store
            .dispatch('addRfxType', {
              RfxType: formData,
            })
            .then(
              () => {
                this.$refs.snackbar.displaySnackbar('success', 'Rfx-type Added Sucessfully');
                this.$store.dispatch('fetchRFxTypes');
                this.closeDialog();
              },
              (err) => {
                try {
                  const { message } = err.response.data.error;
                  this.$refs.snackbar.displaySnackbar('error', message);
                } catch (ex) {
                  this.$refs.snackbar.displaySnackbar('error', 'Failed to Add Rfx-type');
                }
              },
            );
        }
      }
    },
    createRfxTypePrompt() {
      this.dialog = true;
    },
    closeDialog() {
      this.reset();
      this.dialog = false;
    },
    reset() {
      this.id = '';
      this.rfxTypeName = '';
      this.search = '';
    },
    editRfxTypes(id) {
      const rfxPhase = this.$store.state.rfxTypes.find(element => element.id === id);
      this.rfxTypeName = rfxPhase.rfxTypeName;
      this.id = id;
      this.dialog = true;
    },


    async deleteRfxType(id) {
      if (await this.$refs.confirm.open('danger', 'Are you sure to delete this record?')) {
        const res = await this.$store.dispatch('deleteRfxType', { id });
        if (res === 'ERROR') {
          this.$refs.snackbar.displaySnackbar('error', 'This Rfx Type is already used.');
        } else if (res === 'SUCCESS') {
          this.$refs.snackbar.displaySnackbar('success', 'Successfully deleted the record.');
          this.$store.dispatch('fetchRFxTypes');
        }
      }
    },
  },
  created() {
    this.$store.dispatch('fetchRFxTypes');
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
