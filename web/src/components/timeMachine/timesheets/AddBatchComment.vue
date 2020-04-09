<template>
  <v-layout row justify-center class="proc-layout">
    <v-dialog id="newNote" class="proc-dialgue" max-width="40%" v-model="dialog">
      <v-form ref="newBatchComment" v-model="valid" lazy-validation>
        <v-card style="width:100%">
          <br /><v-layout row wrap>
            <v-flex md1></v-flex>
            <v-flex md10 class="headline"> Add a Description</v-flex>
            <v-flex md1></v-flex>
          </v-layout>

          <br />
          <v-divider></v-divider>
 <br />
          <v-layout row wrap>
            <v-flex md1></v-flex>
            <v-flex md10> {{ description }}</v-flex>
            <v-flex md1></v-flex>
          </v-layout>
          <br />
          <br />

          <v-card-text class="card-contents">
            <v-layout row wrap>
              <v-flex md12>
                <div class="v-form-container">
                  <v-text-field
                    name="project-description"
                    label="Please input your description"
                    v-model="batchComment"
                  ></v-text-field>
                </div>
              </v-flex>
              <v-flex md12>
                <v-flex d-flex justify-end>
                  <v-btn class="add-log-button" color="btnPrimary" dark @click="saveComment()"
                    >SUBMIT AND CLOSE</v-btn
                  >
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
    comment: String,
  },
  methods: {
    async saveComment() {
      this.$emit('savecomment', this.batchComment, this.index, this.sheetIndex, this.type);
      this.closeDialog();
    },
    open(value, index, sheetIndex, type, description) {
      this.description = description;
      this.type = type;
      this.sheetIndex = sheetIndex;
      this.index = index;
      this.dialog = true;
      setTimeout(() => {
        if (document.getElementsByClassName('v-dialog v-dialog--active')[0]) {
          document.getElementsByClassName('v-dialog v-dialog--active')[0].scrollTop = 0;
        }
      }, 400);
      this.batchComment = value;
    },
    closeDialog() {
      this.dialog = false;
    },
    initData() {
      return {
        description: '',
        flag: undefined,
        valid: true,
        dialog: false,
        batchComment: '',
        index: '',
        type: '',
        sheetIndex: '',
      };
    },
  },
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
