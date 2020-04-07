<template>
  <v-layout row justify-center class="proc-layout">
    <snackbar ref="snackbar"></snackbar>
    <v-dialog id="newNote" class="proc-dialgue" max-width="40%" v-model="dialog">
      <v-form ref="newNotes" v-model="valid" lazy-validation>
        <spinner ref="spinner"></spinner>
        <v-card style="width:100%">
          <v-card-text class="card-contents">
            <v-layout row wrap>
              <v-flex md12>
                <div class="v-form-container">
                  <v-textarea
                    name="project-description"
                    label="Please input your note below"
                    v-model="userNote"
                    no-resize
                  ></v-textarea>
                </div>
              </v-flex>
              <v-flex md12>
                <v-flex d-flex justify-end>
                  <v-btn
                    class="add-log-button"
                    color="btnPrimary"
                    dark
                    @click="savenote()"
                  >Save Note</v-btn>
                </v-flex>
              </v-flex>
            </v-layout>
          </v-card-text>
        </v-card>
      </v-form>
    </v-dialog>
  </v-layout>
</template>
<script>
import "./procurementlog.styl";
// import moment from 'moment';
import Snackbar from "../common/Snackbar.vue";
import Spinner from "../common/Spinner.vue";

export default {
  computed: {
    projectRfx() {
      return this.$store.state.activeProjectRfxData;
    }
  },
  components: {
    Snackbar,
    Spinner
  },
  data() {
    return this.initData();
  },
  watch: {},
  props: {
    timeEntry: Object
  },
  methods: {
    async savenote() {
      console.log("flag value", this.flag);
      const referenceId = this.$store.state.activeUser.refId;
      const user = this.$store.state.users.find(
        value => value.referenceId === referenceId
      );
      if (this.flag != 1) {
        this.parentNoteId = this.flag;
      }
      const formData = {
        note: this.userNote,
        projectId: this.$store.state.activeProject.id,
        userId: user.id,
        parentId: this.parentNoteId
      };
      console.log(formData);
      await this.$store
        .dispatch("addProjectNotes", {
          projectNotes: formData
        })
        .then(
          () => {
            this.$refs.snackbar.displaySnackbar("success", "Updated");
             this.closeDialog();
          },
          err => {
            try {
              const { message } = err.response.data.error;
              this.$refs.snackbar.displaySnackbar("error", message);
            } catch (ex) {
              this.$refs.snackbar.displaySnackbar("error", "Failed to update");
            }
          }
        );
    },
    parseDate(date) {
      if (!date) return null;
      const [month, day, year] = date.split("/");
      return `${year}-${month.padStart(2, "0")}-${day.padStart(2, "0")}`;
    },
    open(value) {
      this.flag = value;
      this.dialog = true;
      setTimeout(() => {
        document.getElementsByClassName(
          "v-dialog v-dialog--active"
        )[0].scrollTop = 0;
      }, 400);
    },
    closeDialog() {
      this.$emit("closeNotes");
      this.dialog = false;
    },
    reset() {
      // this.$refs.form.resetValidation();
      // const data = this.initData();
    },
    initData() {
      const form = Object.assign({}, this.$props.timeEntry);

      form.userId = this.$store.state.activeUser.id;
      const existingTimeEntries = [];
      return {
        flag: undefined,
        valid: true,
        requiredRule: [v => !!v || "This field required"],
        requireRadioButtondRule: [
          v => ((v || !v) && v != null) || "This field required"
        ],
        dialog: false,
        userNote: "",
        parentNoteId: undefined
      };
    }
  }
};
</script>
<style scoped>
.add-log-button {
  width: 150px;
  flex: 0 0 200px !important;
  margin-right: 3%;
}
.primary-heading {
  margin-top: 10px !important;
}
.v-dialog:not(.v-dialog--fullscreen) {
  max-width: 40%;
  max-height: 90%;
}
</style>
