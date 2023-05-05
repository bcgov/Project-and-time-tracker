<template>
  <v-container style="margin:10px 0px; align-content:start">
    <confirm ref="confirm"></confirm>
      <!--<v-layout>
        <v-flex md12>
          <h1>Dashboard</h1>
        </v-flex>
      </v-layout>-->
      <v-sheet>
        <v-layout>
        <v-flex md12>
          <h1 style="padding:20px 10px 0px 10px" >Branch Wide</h1>
        </v-flex>
      </v-layout>
      <div class="d-flex flex-row mb-6 bg-surface-variant">
        <v-card class="ma-4 pa-4 custom-card" elevation="1" dark color="#ff9800" outlined  style="width:25%; height:140px">
          <v-card-title style="padding: 0px 0px; font-size:24px">Total Projects</v-card-title>
          <div v-if="totalProjects>-1" style="font-size:32px; font-weight:bold; padding: 10px 0px" >{{totalProjects}}</div>
        </v-card>
        <v-card color="#009688" dark class="ma-4 pa-4" elevation="1" style="width:25%; height:140px">
          <v-card-title style="padding: 0px 0px; font-size:24px">Projects Added this Month</v-card-title>
          <div v-if="newProjects>-1" style="font-size:32px; font-weight:bold; padding: 10px 0px" >{{newProjects}}</div>
        </v-card>
        <v-card color="#03a9f4" dark class="ma-4 pa-4" elevation="1" style="width:25%; height:140px">
          <v-card-title style="padding: 0px 0px; font-size:24px">Projects Actively Billed</v-card-title>
          <div v-if="newProjects>-1" style="font-size:32px; font-weight:bold; padding: 10px 0px" >{{activeProjects}}</div>
        </v-card>
        <v-card color="#ce61d2" dark class="ma-4 pa-4 custom-card" elevation="1" style="width:25%; height:140px">
          <v-card-title style="padding: 0px 0px; font-size:24px">Example</v-card-title>
          <div style="font-size:32px; font-weight:bold; padding: 10px 0px">101</div>
        </v-card>
      </div>
      <!--
        Per User (user list, date)
          - Billable vs NonBillable percent
          - My top projects (top 8) (option for billable vs non billable)

        Trend over last 6 months (per month bar chart billable vs non billable)
      -->
      </v-sheet>
      <br>
     <!-- <v-sheet>-->
      <v-card>
        <v-layout>
        <v-flex md12>
          <h1 style="padding:20px 10px 0px 10px">User Specific</h1>
        </v-flex>

        <v-flex class="d-flex cardheadlabel1" style="align-items:center">
          <v-flex md5 class="headerinfo">
            For User:
          </v-flex>
          <v-flex md7 style="align-items:center; padding: 0px 80px 0px 0px;width: 400px;">
            <v-select
              class="currentuser"
              v-model="userId"
              @input="onChangeUser(userId)"
              :items="userList"
              item-value="id"
              item-text="contact.fullName"
              label="User"
              style="width: 200px"
            ></v-select>
          </v-flex>
        </v-flex>

        </v-layout>
          

        <div class="d-flex flex-row">
          <v-card color="#ffffff" class="ma-4 pa-4" width="20%" elevation="1" height="500px">
            <h2 style="text-align:center">Billable Hours Over Time</h2>
            <Bar
            :chart-options="barChartOptions"
            :chart-data="barChartData"
            />
          </v-card>
          <v-card color="#ffffff" class="ma-4 pa-4" width="20%" elevation="1" height="500px">
            <h2 style="text-align:center">Expenses Over Time</h2>
            <Bar
            :chart-options="expenseBarChartOptions"
            :chart-data="expenseBarChartData"
            />
          </v-card>
          <v-card class="ma-4 pa-4"  color="#ffffff" width="20%" elevation="1" outlined border-color="red" height="500px">
            <h2 style="text-align:center">Billable Vs Non-Billable</h2>
            <Doughnut
            :chart-options="doughnutChartOptions"
            :chart-data="doughnutChartData"
            />
          </v-card>
        </div>
        </v-card>
      <!--</v-sheet>-->
      <!--:chart-id="chartId"
      :dataset-id-key="datasetIdKey"
      :plugins="plugins"
      :css-classes="cssClasses"
      :styles="styles"
      :width="width"
      :height="height"-->

  </v-container>
</template>

<script>

import Confirm from '../common/Confirm.vue';
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
  ArcElement,
} from 'chart.js';
import { Bar, Doughnut } from 'vue-chartjs/legacy'

ChartJS.register(CategoryScale, LinearScale, BarElement, ArcElement, Title, Tooltip, Legend)
//import BarChart from '../charts/Bar.vue'

import './dashboard.styl';

export default {
  methods: {
    async fetchData() {
      if (this.$store.state.users.length === 0) {
        //this.$refs.spinner.open();
        await this.$store.dispatch('fetchUsers');
        //this.$refs.spinner.close();
      }
      await this.$store.dispatch('fetchAllProjects');
      this.totalProjects = this.$store.state.allProjects.length;
      this.newProjects = 0; //calculation for this month
      this.activeProjects = 0; //More Complex calculation
      this.monthBillables = 0;

      const month = ["January","February","March","April","May","June","July","August","September","October","November","December"];
      const d = new Date();
      let monthName = month[d.getMonth()];
      console.log(monthName);

      console.log(this.$store.state.allProjects[0]);
      this.newProjects = this.$store.state.allProjects.filter(filterByDate).length;

      const timesheetDate = new Date(d.getFullYear(), d.getMonth()-2, 1); //6 months
      /*timesheetDate.setDate(timesheetDate.getMonth()-5);
      timesheetDate.setDate(timesheetDate.getDay()-5);*/
      let dateString = timesheetDate.getFullYear() + "-"+ timesheetDate.getMonth()+"-"+timesheetDate.getDate();

      await this.$store.dispatch('fetchAllTimesheetsFromDate', { date: dateString })
      
      console.log(this.$store.state.allTimesheetsFromDate[0]);
      const res = [...this.$store.state.allTimesheetsFromDate.reduce((a,c)=>{
        a.set(c.project.id, c);
        return a;
      }, new Map()).values()]
      console.log(res);
      this.activeProjects = res.length;
    },
    fetchUser() {
      const referenceId = this.$store.state.activeUser.refId;
      const user = this.$store.state.users.find(value => value.referenceId === referenceId);
      if (user && user.id) {
        return user.id;
      }
      return '';
    },
    async onChangeUser(userId) {
      console.log('onChangeUserCalled');
        /*if (this.$refs.spinner) {
          this.$refs.spinner.open();
        }*/
        /*this.form.userId = userId;

        const vm = this;
        vm.projectList = [];
        vm.rfxList = [];
        vm.userMouProjects = [];
        await vm.$store.dispatch('fetchMouProjects', { id: userId }).then((res) => {
          vm.userMouProjects = res;
        });
        if (!editMode) {
          await this.getTimeSheets();
        }
        if (this.$refs.spinner) {
          this.$refs.spinner.close();
        }

        return vm.userMouProjects;*/
        return null;
      }
    },
  computed:{ 
    userList() {
      return this.$store.state.users;
    },
  },
  components: {
    Confirm,
    Bar,
    Doughnut,
  },
  async created() {
    console.log('created called');
    await this.fetchData();
    this.userId = this.fetchUser();

  },
  /*updated(){
    console.log('updated called');
  },*/
  data() {
    //const form = Object.assign({});
    return {
      totalProjects:{
        type: Number,
        default: null,
      },
      newProjects:{
        type: Number,
        default: null,
      },
      activeProjects:{
        type: Number,
        default: null,
      },
      monthBillables:{
        type: Number,
        default: null,
      },
      userId:{
        type: String,
        defualt: '',
      },
      barChartData: {
        labels: [ 'December', 'January', 'February', 'March', 'April', 'May'],
        color: ['#03a9f4'],
        datasets: [ { 
          data: [40, 20, 12, 36, 22, 25],
          backgroundColor: ['#03a9f4'],
           } ],
      },
      barChartOptions: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend:{
              display: false
            },
        }
      },
      expenseBarChartData: {
        labels: [ 'December', 'January', 'February', 'March', 'April', 'May'],
        datasets: [ {
          data: [1200, 3000, 350, 0, 2000, 750], 
          backgroundColor: ['#03a9f4'],
          
        }],
      },
      expenseBarChartOptions: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend:{
              display: false
            },
        }
      },
      doughnutChartData: {
        labels: [ 'Billed','Non-Billed' ],
        datasets: [ { 
          backgroundColor: ['#03a9f4', '#ce61d2'],
          data: [40, 60] } 
        ]
      },
      doughnutChartOptions: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
        legend: {
          position: 'bottom'
          }
      },
      width: {
      type: Number,
      default: 100
      },
      height: {
        type: Number,
        default: 300
      },
      doughnutWidth:{
        type: Number,
        default: 400
      },
      doughnutWidth:{
        type: Number,
        default: 400
      },
      },
      datasetIdKey: {
        type: String,
        default: 'label'
      },
      chartId: {
        type: String,
        default: 'doughnut-chart'
      },
      plugins: {
        type: Array,
        default: () => []
      }/*,
      form: { ...form }*/
    }
  }
};

function filterByDate(item) {
  let d = new Date(); 
  d.setDate(d.getDay()-30);
  let d2 = new Date(item.dateCreated);
  if(d2>d){
    return true;
  }
  return false;
}
</script>

<style scoped>
.v-card{
  outline-color: black !important;
  box-shadow: 10px !important;
}
</style>
