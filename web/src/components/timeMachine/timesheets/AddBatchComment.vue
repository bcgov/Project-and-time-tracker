<template>
  <v-layout row justify-center class="proc-layout">
    <snackbar ref="snackbar"></snackbar>
    <v-dialog id="newNote" class="proc-dialgue" max-width="40%" v-model="dialog">
      <v-form ref="newBatchComment" v-model="valid" lazy-validation>
        <spinner ref="spinner"></spinner>
        <v-card style="width:100%">
          <v-card-text class="card-contents">
            <v-layout row wrap>
              <v-flex md12 v-if="replyNoteName" class="replyheaderdiv">
                <div class="replytoheader">Reply to: {{replyNoteName}}</div>
              </v-flex>
              <v-flex md12>
                <div class="v-form-container">
                  <v-textarea
                    name="project-description"
                    label="Please input your description"
                    v-model="batchComment"
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
                  >SUBMIT AND CLOSE</v-btn>
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
    comment: String
  },
  methods: {
    async savenote() {
    this.$emit('savecomment', this.batchComment,this.index,this.sheetIndex,this.type)
    this.closeDialog();
    // this.$props.comment = this.batchComment;
    },
    parseDate(date) {
      if (!date) return null;
      const [month, day, year] = date.split("/");
      return `${year}-${month.padStart(2, "0")}-${day.padStart(2, "0")}`;
    },
    open(value,index,sheetIndex,type) {
      // this.replyNoteName = name;
      // this.flag = value
      this.type = type;
      this.sheetIndex = sheetIndex;
      this.index = index;
      this.dialog = true;
      setTimeout(() => {
        if (document.getElementsByClassName("v-dialog v-dialog--active")[0]) {
          document.getElementsByClassName(
            "v-dialog v-dialog--active"
          )[0].scrollTop = 0;
        }
      }, 400);
      this.batchComment = value;
    },
    closeDialog() {
      this.dialog = false;
    },
    reset() {
      // this.$refs.form.resetValidation();
      // const data = this.initData();
    },
    initData() {
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
        batchComment: "",
        index:'',
        type:'',
        sheetIndex:'',
        replyNoteName: undefined,
        parentNoteId: undefined
      };
    }
  }
};
</script>
<style scoped>
.replyheaderdiv {
  background-color: gainsboro;
}

.replytoheader {
  margin-left: 40px;
  font-size: medium;
  font-weight: 600;
}
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
