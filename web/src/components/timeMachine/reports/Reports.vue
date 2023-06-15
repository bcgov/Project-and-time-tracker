<template>
<v-container style="margin:10px 0px; align-content:start">
    <v-layout>
        <v-flex md12>
          <h1>Reports</h1>
        </v-flex>
    </v-layout>
    <v-flex class="d-inline-flex align-start">
      <!--
        <v-hover v-slot="{ hover }">
        </v-hover>
      -->
      <v-btn color="#ffffff" class="ma-3 pa-3" style="width:250px; height:50px" elevation="1" v-on:click="SendTo('MOUAmounts')">
        <div style="text-align:center;">
        <h4 style="align-items:center; justify-content:center;">MOU Amounts</h4>
        </div>
      </v-btn>
      <v-btn color="#ffffff" class="ma-3 pa-3" style="width:250px; height:50px" elevation="1" >
        <div style="text-align:center;">
        <h4 style="align-items:center; justify-content:center;">Report2</h4>
        </div>
      </v-btn>
      <v-btn color="#ffffff" class="ma-3 pa-3" style="width:250px; height:50px" elevation="1" >
        <div style="text-align:center;">
        <h4 style="align-items:center; justify-content:center;">Report3</h4>
        </div>
      </v-btn>
    </v-flex>
</v-container>
</template>

<script>

export default{
    /*data() {
        return null;
    },*/
    methods: {
      SendTo: function(url){
        console.log(url);
        this.$router.push({ path: `reports/${url}` });
      }
    },
}
</script>


<style scoped>
</style>