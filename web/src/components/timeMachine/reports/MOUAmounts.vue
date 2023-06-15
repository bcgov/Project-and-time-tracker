<template>
<v-container style="margin:10px 0px; align-content:start">
    <v-layout>
        <v-flex md12>
          <h1>MOU Amounts</h1>
        </v-flex>
    </v-layout>
    <v-flex class="d-inline-flex align-start">
    </v-flex>
    <v-card>
    <v-card-title>
      <v-text-field
        v-model="search"
        append-icon="mdi-magnify"
        label="Search"
        single-line
        hide-details
      ></v-text-field>
      <v-spacer></v-spacer>
    </v-card-title>
    <v-data-table
    :headers="headers"
    :items="mouList"
    :search="search"
    :pagination.sync="pagination"
    class="elevation-1">
    <template v-slot:items="props" >
      <td class="text-xs-left" >{{ props.item.name }}</td>
      <td class="text-xs-left" >$ {{ props.item.mouAmount }}</td>
      <td class="text-xs-left" >$ {{ Math.round(props.item.mouBilled) }}</td>
      <td class="text-xs-left" >$ {{ Math.round(props.item.mouAmount - props.item.mouBilled) }}</td>
    </template>
    </v-data-table>
    </v-card>
</v-container>
</template>

<script>

export default{
    data() {
        return{
          headers:[
          {text: 'MOU Name',value: 'name'},
          {text: 'MOU Amount', value: ''},
          {text: 'Amount Billed', value: ''},
          {text: 'MOU Available', value: ''},
          //{text: 'Last Updated', value: ''},
          ],
          parsedobj: [],
          search: '',
          pagination: {
            rowsPerPage: 10,
          }, 
        };
    },
    computed: {
      mouList() {
        return this.$store.state.mouListAmounts;
      },
    },
    methods: {
      async fetchData() {
        if (this.$store.state.allProjects.length == 0) 
          await this.$store.dispatch('fetchAllProjects');
        if (!this.$store.state.mouListAmounts || this.$store.state.mouListAmounts.length == 0){ 
          await this.$store.dispatch('fetchMOUAmounts');
          console.log("fetching mou amounts");
        }
        if(this.$store.state.mouListAmounts){
        this.$store.state.mouListAmounts.forEach(element => {
          const project = this.$store.state.allProjects.find(item => item.mou && item.mou.id === element.mouId)
          if(project){
            element.mouAmount = project.mouAmount;
          }
        });
      }

      },
      checkDuplicate(id) {
        const projectMOU = this.$store.state.allProjects.find(item => item.mou && item.mou.id === id);
        if (projectMOU) {
          return false;
        }
        return true;
      },
    },
    async created() {
      console.log('created called');
      await this.fetchData();
      console.log(this.$store.state.mouListAmounts);
    }
}
</script>


<style scoped>
</style>