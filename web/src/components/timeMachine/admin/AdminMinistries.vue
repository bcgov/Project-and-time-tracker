<template>
  <v-container grid-list-xl fluid class="custom-manage-projects-container">
   <confirm ref="confirm"></confirm>
    <v-layout>
      <v-flex md12>
        <h1 class="projects-header">Admin &mdash; Ministries</h1>
      </v-flex>
    </v-layout>
    <v-layout row wrap>
      <v-flex xs12>
        <p>Welcome to ministries list</p>
        <p>TODO: Re-name, Create.</p>
        <p>TODO: Copy Archive icon used by Tanya</p>
        <p>TODO: Need to handle re-names in a way that don't retroactively rename.</p>

        <!-- <v-list>
          <v-list-tile v-for="ministry in ministries" :key="ministry.id">
            <v-list-tile-content>NAME: {{ ministry.ministryName }}</v-list-tile-content>
          </v-list-tile>
        </v-list>-->

        <v-btn>Create New Ministry</v-btn>

        <v-data-table :headers="headers" :items="ministries" class="elevation-1">
          <template v-slot:items="props">
            <td v-if="!editableRows[props.item.id]">{{ props.item.ministryName }}</td>
            <td v-else>
              <v-text-field label="Name" v-model='props.item.ministryName'></v-text-field>
            </td>

            <td @click="archivePrompt(props.item)">
              <v-btn>Archive</v-btn>
            </td>
            <!-- <td v-if="!editableRows[props.item.id]" @click="editName(props.item.id, props.item.ministryName)">
              Rename
            </td>
            <td v-else>
              <v-btn @click='cancelName(props.item.id, props.item.ministryName)'>Cancel</v-btn>
              <v-btn @click='saveName(props.item)'>Save</v-btn>
              </td> -->
          </template>
        </v-data-table>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import Confirm from '../common/Confirm.vue'


export default {
  components: {
    Confirm
  },
  data() {
    return {
      headers: [
        {
          text: "Ministry",
          align: "left",
          value: "ministryName"
        },
        { text: "Actions", value: "actions" }
      ],

      editableRows: {},
      _originalName: '',
    };
  },

  beforeMount() {
    // this.$store.state.collapseNavigationBar = true;
  },
  // computed: {},
  computed: {
    ministries() {
      return this.$store.state.ministries;
    }
  },
  methods: {
    editName(i, name) {
      const toggle = !this.editableRows[i];
      this.$set(this.editableRows, i, toggle);
      this._originalName = name;
    },
    cancelName(i, name){
      const ministry = this.ministries.find(x => x.id === i)
      ministry.ministryName = this._originalName;
      this.$set(this.editableRows, i, false); // false=make non-editable
    },
    // saveName(i, name){
    saveName(item){
      this.$set(this.editableRows, item.id, false); // false=make non-editable
      console.log('TODO! MAKE API CALL HERE');
      this.$store.dispatch('updateMinistries', item)
    },
    async archivePrompt(item){
       if (
        await this.$refs.confirm.open(
          'info',
          `Are you sure to archive ${item.ministryName}?`,
        )
      ) {
        console.log('TODO - Archive!')
        // this.$store.dispatch('approveIntakeRequest', { id }).then(() => {
        //   this.$store.dispatch('fetchIntakeRequests');
        //   this.$refs.snackbar.displaySnackbar('success', 'Request Approved.');
        // });
      }
    },
  },
};
</script>

<style></style>
