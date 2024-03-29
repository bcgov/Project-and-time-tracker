<template>
  <v-container grid-list-xl fluid class="custom-manage-projects-container">
    <confirm ref="confirm"></confirm>
    <snackbar ref="snackbar"></snackbar>
    <v-layout>
      <v-flex md12>
        <h1 class="projects-header">Admin &mdash; Finance Codes</h1>
      </v-flex>
    </v-layout>
    <v-layout row wrap>
      <v-flex xs12>
        <v-layout>
          <v-flex sm-6>
            <v-btn class="btn-create" @click="createFinanceCodePrompt()">Create New</v-btn>
          </v-flex>
          <v-flex sm-6>
            <v-text-field
              class="search-bar"
              v-model="search"
              append-icon="search"
              label="Search Finance Name"
              single-line
              hide-details
            ></v-text-field>
          </v-flex>
        </v-layout>

        <v-data-table
          :headers="headers"
          :items="allFinanceCodes"
          class="elevation-1"
          :rows-per-page-items="[15, 30, 50, 100]"
          :pagination.sync="pagination"
        >
          <template v-slot:items="props">
            <td class="text-xs-left">{{ props.item.financeName }}</td>
            <td class="text-xs-left">{{ props.item.clientNo }}</td>
            <td class="text-xs-left">{{ props.item.responsibilityCenter }}</td>
            <td class="text-xs-left">{{ props.item.serviceCenter }}</td>
            <td class="text-xs-left">{{ props.item.stob }}</td>
            <td class="text-xs-left">{{ props.item.projectCode }}</td>
            <td class="text-xs-center">
              <v-tooltip top>
                <template v-slot:activator="{ on }">
                  <v-btn flat icon color="grey" @click="editFinanceCodes(props.item.id)" v-on="on">
                    <v-icon>edit</v-icon>
                  </v-btn>
                </template>
                <span>Edit</span>
              </v-tooltip>
              <v-tooltip top>
                <template v-slot:activator="{ on }">
                  <v-btn
                    :disabled="checkIsDisabled(props.item.contacts.length)"
                    flat
                    icon
                    color="grey"
                    v-on="on"
                    @click="deleteFinanceCode(props.item.id)"
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
      <!-- <template v-slot:activator="{ on }">
        <v-btn color="primary" dark v-on="on">Open Dialog</v-btn>
      </template>-->
      <v-card>
        <v-form id="add-financecodes" ref="fincodes">
          <v-card-title>
            <span class="headline spanmargin">Finance Codes</span>
          </v-card-title>
          <v-card-text>
            <v-container grid-list-md>
              <v-layout wrap py-2>
                <v-flex xs12>
                  <div class="v-form-container">
                    <v-text-field v-model="financeName" label="Finance Name"></v-text-field>
                  </div>
                </v-flex>
                <v-flex xs12>
                  <div class="v-form-container">
                    <v-text-field
                      v-model="clientNo"
                      :rules="[rules.clientNoRules]"
                      maxlength="3"
                      label="Client No. (3 characters)"
                    ></v-text-field>
                  </div>
                </v-flex>
                <v-flex xs6>
                  <div class="v-form-container">
                    <v-text-field
                      v-model="responsibility"
                      :rules="[rules.responsibilityCenterRules]"
                      maxlength="5"
                      label="Responsibility Center (5 characters)"
                    ></v-text-field>
                  </div>
                </v-flex>
                <v-flex xs6>
                  <div class="v-form-container">
                    <v-text-field
                      v-model="serviceCenter"
                      :rules="[rules.serviceCenterRules]"
                      maxlength="5"
                      label="Service Center (5 characters)"
                    ></v-text-field>
                  </div>
                </v-flex>
                <v-flex xs6>
                  <div class="v-form-container">
                    <v-text-field
                      v-model="stob"
                      :rules="[rules.stobRules]"
                      maxlength="4"
                      label="STOB (4 characters)"
                    ></v-text-field>
                  </div>
                </v-flex>
                <v-flex xs6>
                  <div class="v-form-container">
                    <v-text-field
                      v-model="projectCode"
                      :rules="[rules.projectCodeRules]"
                      label="Project Code (7 characters)"
                      maxlength="7"
                    ></v-text-field>
                  </div>
                </v-flex>
              </v-layout>
            </v-container>
          </v-card-text>
        </v-form>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" class="btnposition" flat @click="closeDialog()">Close</v-btn>
          <v-btn color="blue darken-1" class="btnposition" flat @click="saveFinanceCodes"
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
      rules: {
        clientNoRules: v => this.showValidationMessage(v, 3),
        responsibilityCenterRules: v => this.showValidationMessage(v, 5),
        serviceCenterRules: v => this.showValidationMessage(v, 5),
        stobRules: v => this.showValidationMessage(v, 4),
        projectCodeRules: v => this.showValidationMessage(v, 7),
      },
      headers: [
        { text: 'Finance Name', value: 'financeName', sortable: false },
        { text: 'Client Name', value: 'clientName', sortable: false },
        { text: 'Responsibility Center', value: 'responsibility', sortable: false },
        { text: 'Service Center', value: 'serviceCenter', sortable: false },
        { text: 'Stob', value: 'stob', sortable: false },
        { text: 'Project Code', value: 'projectCode', sortable: false },
        { text: 'Action', align: 'center', sortable: false },
      ],
      dialog: false,
      financeName: '',
      clientNo: '',
      responsibility: '',
      serviceCenter: '',
      stob: '',
      projectCode: '',
      search: '',
      id: '',
    };
  },
  computed: {
    // ministries() {
    //   return this.$store.state.ministries;
    // },
    allFinanceCodes() {
      // TODO - Need to
      if (this.search) {
        return this.$store.state.allFinanceCodes.filter(item => item.financeName.toLowerCase().includes(this.search.toLowerCase()));
      }
      return this.$store.state.allFinanceCodes;
    },
  },
  methods: {
    checkIsDisabled(val) {
      if (val) {
        return true;
      } return false;
    },
    async saveFinanceCodes() {
      if (this.$refs.fincodes.validate()) {
        const formData = {
          clientNo: this.clientNo,
          responsibilityCenter: this.responsibility,
          serviceCenter: this.serviceCenter,
          stob: this.stob,
          projectCode: this.projectCode,
          financeName: this.financeName,
        };

        if (this.id) {
          formData.id = this.id;
          await this.$store
            .dispatch('updateFinanceCodes', {
              FinanceCodes: formData,
            })
            .then(
              () => {
                this.$refs.snackbar.displaySnackbar('success', 'FinanceCodes Updated');
                this.$store.dispatch('fetchAllFinanceCodes');
                this.closeDialog();
              },
              (err) => {
                try {
                  const { message } = err.response.data.error;
                  this.$refs.snackbar.displaySnackbar('error', message);
                } catch (ex) {
                  this.$refs.snackbar.displaySnackbar('error', 'Failed to Add FinanceCodes');
                }
              },
            );
        } else {
          await this.$store
            .dispatch('addFinanceCodes', {
              FinanceCodes: formData,
            })
            .then(
              () => {
                this.$refs.snackbar.displaySnackbar('success', 'FinanceCodes Added');
                this.$store.dispatch('fetchAllFinanceCodes');
                this.closeDialog();
              },
              (err) => {
                try {
                  const { message } = err.response.data.error;
                  this.$refs.snackbar.displaySnackbar('error', message);
                } catch (ex) {
                  this.$refs.snackbar.displaySnackbar('error', 'Failed to Add FinanceCodes');
                }
              },
            );
        }
      }
    },
    showValidationMessage(value, count) {
      if (value && value.length && value.length !== count) {
        return `Exactly ${count} characters required`;
      }
      return true; // added to avoid warning 'rules can't be undefined' after atyping valid value
    },
    createFinanceCodePrompt() {
      this.dialog = true;
    },
    closeDialog() {
      this.reset();
      this.dialog = false;
    },
    reset() {
      this.id = '';
      this.financeName = '';
      this.clientNo = '';
      this.responsibility = '';
      this.serviceCenter = '';
      this.stob = '';
      this.projectCode = '';
      this.search = '';
    },
    editFinanceCodes(id) {
      const FinCodeValues = this.$store.state.allFinanceCodes.find(element => element.id == id);
      this.clientNo = FinCodeValues.clientNo;
      this.responsibility = FinCodeValues.responsibilityCenter;
      this.serviceCenter = FinCodeValues.serviceCenter;
      this.stob = FinCodeValues.stob;
      this.projectCode = FinCodeValues.projectCode;
      this.financeName = FinCodeValues.financeName;
      this.id = id;
      this.dialog = true;
    },
    async deleteFinanceCode(id) {
      if (await this.$refs.confirm.open('danger', 'Are you sure to delete this record?')) {
        await this.$store.dispatch('deleteFinanceCodes', { id });
        this.$refs.snackbar.displaySnackbar('success', 'Successfully deleted the record.');
        this.$store.dispatch('fetchAllFinanceCodes');
      }
    },
    async createSTOB(stobname, stobvalue) {
      //   await this.$store.dispatch("addMinistry", { ministryName: name });
      //   this.dialog = false; // Close window
      //   this.$store.dispatch("fetchAllMinistries");
    },
  },
  created() {
    this.$store.dispatch('fetchAllFinanceCodes');
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
