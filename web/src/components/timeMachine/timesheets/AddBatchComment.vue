<template>
  <v-layout row justify-center class="proc-layout">
    <v-dialog id="newNote" class="proc-dialgue" max-width="40%" v-model="dialog">
      <v-form ref="newBatchComment" v-model="valid" lazy-validation>
        <v-card style="width:100%">
          <br />
          <v-layout row wrap>
            <v-flex md1></v-flex>
            <v-flex md10 class="headline">Add a Description</v-flex>

            <v-flex md1>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="18"
                height="18"
                @click="closeDialog()"
                viewBox="0 0 18 18"
              >
                <path
                  d="M14.53 4.53l-1.06-1.06L9 7.94 4.53 3.47 3.47 4.53 7.94 9l-4.47 4.47 1.06 1.06L9 10.06l4.47 4.47 1.06-1.06L10.06 9z"
                />
              </svg>
            </v-flex>
          </v-layout>

          <br />
          <v-divider></v-divider>
          <v-layout row wrap>
            <v-flex md1></v-flex>
            <v-flex md10 class="description-date">
              <span class="datevalue">Date:{{ new Date(date).toString().slice(0,10)}}</span>
              <span class="projectvalue">{{project}}</span>
            </v-flex>
            <v-flex md1></v-flex>
          </v-layout>
          <br />
          <br />

          <v-card-text class="card-contents">
            <v-layout row wrap>
              <v-flex md12>
                <div class="v-form-container" style="margin-left: 20px;">
                  <v-text-field
                    class="pa-0"
                    name="project-description"
                    label="Please input your description"
                    v-model="batchComment"
                  ></v-text-field>
                </div>
              </v-flex>
              <br />
                  <br />
                  <br />
                  <br />
              <v-flex md12>
                <v-flex>
                  <v-btn class="btn-discard" @click="closeDialog()" :ripple="false">DISCARD</v-btn>
                </v-flex>
                <v-flex d-flex justify-end>
                  <v-btn
                    class="add-log-button"
                    color="btnPrimary"
                    dark
                    @click="saveComment()"
                  >SUBMIT AND CLOSE</v-btn>
                  <br />
                  <br />
                  <br />
                  <br />
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
export default {
  computed: {},
  components: {},
  data() {
    return this.initData();
  },
  watch: {},
  props: {
    comment: String
  },
  methods: {
    async saveComment() {
      this.$emit(
        "savecomment",
        this.batchComment,
        this.index,
        this.sheetIndex,
        this.type
      );
      this.closeDialog();
    },
    open(value, index, sheetIndex, type, date, project) {
      this.date = date;
      this.project = project;
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
      this.batchComment = "";
      this.dialog = false;
    },
    initData() {
      return {
        date: "",
        project: "",
        flag: undefined,
        valid: true,
        dialog: false,
        batchComment: "",
        index: "",
        type: "",
        sheetIndex: ""
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
  margin-right: 5%;
}
.primary-heading {
  margin-top: 10px !important;
}
.v-dialog:not(.v-dialog--fullscreen) {
  max-width: 40%;
  max-height: 90%;
}
.headline {
  font-weight: 500;
}
.description-date {
  font-weight: 400;
  color: rgb(160, 154, 154);
}
.datevalue {
  padding-right: 15px;
}
.projectvalue {
  padding-left: 15px;
}
.btn-discard,
.btn-discard:focus:before,
.btn-discard:before {
  background: none !important;
  border: none;
  padding: 0 !important;
  font-family: arial, sans-serif;
  color: grey;
  cursor: pointer;
  box-shadow: none !important;
  float: left;
  margin-left: 6%;
  
}
</style>
