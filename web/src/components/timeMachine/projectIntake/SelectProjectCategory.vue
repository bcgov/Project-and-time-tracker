<template>
  <v-dialog
    id="SelectProject"
    v-model="showDialog"
    content-class="select-project-dialog"
    max-width="450"
    @keydown.esc="cancel"
  >
    <v-card>
      <v-toolbar dark color="blue" dense flat>
        <v-icon>help</v-icon>
        <v-toolbar-title class="white--text ml-1">Approve Intake?</v-toolbar-title>
      </v-toolbar>
      <v-card-text>
        <div>
          To complete the approval of the project, please select the category below and click on the 'Approve' button.
          <v-select solo
            label="Select Project Category"
            :items="projectCategories"
            item-value="id"
            item-text="description"
            v-model="selectedCategory"
            class="mt-2"></v-select>
        </div>
      </v-card-text>
      <v-card-actions class="pt-0 clear-margin">
        <v-spacer></v-spacer>
        <v-btn color="primary" :disabled="!selectedCategory" flat="flat" @click.native="approve">Approve</v-btn>
        <v-btn color="secondary" flat="flat" @click.native="cancel">Cancel</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  data: () => ({
    showDialog: false,
    resolve: null,
    selectedCategory: null,
  }),
  computed:{
    projectCategories() {
      return this.$store.state.projectCategories;
    },
  },
  methods: {
    open() {
      this.selectedCategory = null;
      this.showDialog = true;
      return new Promise((resolve, reject) => {
        this.resolve = resolve;
      });
    },
    approve() {
      this.resolve(this.selectedCategory);
      this.showDialog = false;
    },
    cancel() {
      this.resolve(false);
      this.showDialog = false;
    },
  },
  created(){
    this.$store.dispatch('fetchProjectCategories');
  }
};
</script>
