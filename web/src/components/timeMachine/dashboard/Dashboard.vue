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
          <h1 style="padding:20px 10px 0px 10px" >User Wide</h1>
        </v-flex>
      </v-layout>
      <div class="d-flex flex-row mb-6 bg-surface-variant">
        <v-card class="ma-4 pa-4 custom-card" elevation="1" dark color="#ff9800" outlined  style="width:25%;">
          <v-card-title style="padding: 0px 0px; font-size:24px">Total Projects</v-card-title>
          <div v-if="totalProjects>-1" style="font-size:32px; font-weight:bold; padding: 10px 0px" >{{totalProjects}}</div>
        </v-card>
        <v-card color="#009688" dark class="ma-4 pa-4" elevation="1" style="width:25%;" >
          <v-card-title style="padding: 0px 0px; font-size:24px">Projects Added this Month</v-card-title>
          <div v-if="newProjects>-1" style="font-size:32px; font-weight:bold; padding: 10px 0px" >{{newProjects}}</div>
        </v-card>
        <v-tooltip top>
        <template v-slot:activator="{ on, attrs }">
        <v-card color="#03a9f4" dark class="ma-4 pa-4" elevation="1" style="width:25%;" v-bind="attrs" v-on="on">
          <v-card-title style="padding: 0px 0px; font-size:24px">Projects Actively Billed</v-card-title>
          <div v-if="newProjects>-1" style="font-size:32px; font-weight:bold; padding: 10px 0px" >{{activeProjects}}</div>
        </v-card>
        </template>
        <span>Based on Last 6 Months</span>
        </v-tooltip>
        <v-card color="#ce61d2" dark class="ma-4 pa-4 custom-card" elevation="1" style="width:25%;">
          <v-card-title style="padding: 0px 0px; font-size:24px">Example</v-card-title>
          <div style="font-size:32px; font-weight:bold; padding: 10px 0px">101</div>
        </v-card>
      </div>
      </v-sheet>
      <br>
      <v-card>  
        <v-layout row style="display:flex">
          <v-flex shrink>
          <h1 style="padding:20px 10px 0px 10px">User Specific</h1>
          </v-flex>
          <v-flex shrink style="align-items:center;display:flex; padding:10px 40px 0px">
          <v-btn-toggle v-model="toggle_exclusive" >
            <v-btn @click="changeUserMonths(6)">
              6M
            </v-btn>
            <v-btn @click="changeUserMonths(3)">
              3M
            </v-btn>
            <v-btn @click="changeUserMonths(1)">
              1M
            </v-btn>
          </v-btn-toggle>
          </v-flex>

          <v-flex grow justify-end style="text-align:end; flex-wrap:wrap;display:flex; align-items:center;">
              <v-select
                class="currentuser"
                v-model="userId"
                @input="onChangeUser(userId)"
                :items="userList"
                item-value="id"
                item-text="contact.fullName"
                label="User"
                style="width:200px; text-align:end; flex-wrap:wrap;display:flex; flex:none"
              ></v-select>
          </v-flex>
          </v-layout>
        
          
        <div class="d-flex flex-row">
          <v-card color="#ffffff" class="ma-4 pa-4" width="20%" elevation="1" height="500px">
            <h2 style="text-align:center">Billable Hours Over Time</h2>
            <canvas id ="BillableOverTime" style="padding:20px"></canvas>
          </v-card>
          <v-card color="#ffffff" class="ma-4 pa-4" width="20%" elevation="1" height="500px">
            <h2 style="text-align:center">Expenses Over Time</h2>
            <canvas id ="ExpenseOverTime" style="padding:20px" ></canvas>
          </v-card>
          <v-card class="ma-4 pa-4"  color="#ffffff" width="20%" elevation="1" height="500px">
            <h2 style="text-align:center">Billable Vs Non-Billable</h2>
            <canvas id ="doughChart" style="padding:20px"></canvas>
          </v-card>
        </div>
        </v-card>
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
  DoughnutController,
  CategoryScale,
  LinearScale,
  ArcElement,
  BarController,
} from 'chart.js';
import { Bar, Doughnut } from 'vue-chartjs/legacy'

ChartJS.register(CategoryScale, LinearScale, BarElement, ArcElement, Title, Tooltip, Legend, DoughnutController, BarController)

import './dashboard.styl';

export default {
  methods: {
    initializeDoughChart(){
      const ctx = document.getElementById('doughChart').getContext('2d');
      ctx.canvas.height = 500;
      this.billableDoughnutChart = new ChartJS(ctx, {
        type: 'doughnut',
        data: {
          labels: [ 'Billable','Non-Billable' ],
          datasets: [ { 
            backgroundColor: ['#03a9f4', '#ce61d2'],
            data: null,
           } 
        ]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
            position: 'bottom'
            }
          }
        }
      })
    },
    initializeExpenseOverTimeChart(){
      const ctx = document.getElementById('BillableOverTime').getContext('2d');
      ctx.canvas.height = 400;
      this.billingOverTimeChart = new ChartJS(ctx, {
        type: 'bar',
        data: {
          labels: null,
          datasets: [ {
            data: null,
            backgroundColor: ['#03a9f4'],
          
        }],
        }, 
        options:{
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend:{
              display: false
            },
          }
        }
      })
    },
    initializeBillableOverTimeChart(){
      const ctx = document.getElementById('ExpenseOverTime').getContext('2d');
      this.expenseOverTimeChart = new ChartJS(ctx, {
        type: 'bar',
        data: {
          labels: null,
          color: ['#03a9f4'],
          datasets: [ { 
            data: null,
            backgroundColor: ['#03a9f4'],
           } ],
        }, 
        options:{
          responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend:{
              display: false
            },
        }
        }
      })
    },
    async fetchData() {
      if (this.$store.state.users.length === 0) {
        //this.$refs.spinner.open();
        await this.$store.dispatch('fetchUsers');
        //this.$refs.spinner.close();
      }
      await this.$store.dispatch('fetchAllProjects');
      this.totalProjects = this.$store.state.allProjects.length;
      this.newProjects = 0;
      this.activeProjects = 0;
      this.monthBillables = 0;

      this.newProjects = this.$store.state.allProjects.filter(filterByDate).length;

      
      const d = new Date();
      console.log("CurrentDate: ");
      console.log(d);

      var sixMonthsAgo = new Date(d.getFullYear(), d.getMonth()-5, 1); //6 months
      /*console.log("SixMonthsPrior: ");
      console.log(sixMonthsAgo);
      if(d.getMonth()<6){
        sixMonthsAgo.setFullYear(sixMonthsAgo.getFullYear() - 1);
        sixMonthsAgo.setMonth(sixMonthsAgo.getMonth()+12);
      }

      const timesheetDate = new Date(d.getFullYear(), d.getMonth()-6, 1); //6 months
      console.log("SixMonthsPrior Corrected: ");
      console.log(timesheetDate);*/

      let dateString = sixMonthsAgo.getFullYear() + "-"+ (sixMonthsAgo.getMonth()+1)+"-"+sixMonthsAgo.getDate();

      await this.$store.dispatch('fetchAllTimesheetsFromDate', { date: dateString })
      console.log(this.$store.state.allTimesheetsFromDate[0]);
      const res = [...this.$store.state.allTimesheetsFromDate.reduce((a,c)=>{
        a.set(c.project.id, c);
        return a;
      }, new Map()).values()]
      this.activeProjects = res.length;
    },
    fetchUser() {
      const referenceId = this.$store.state.activeUser.refId;
      const user = this.$store.state.users.find(value => value.referenceId === referenceId);
      if (user && user.id) {
        this.onChangeUser(user.id);
        return user.id;
      }
      return '';
    },
    async onChangeUser(userId) {
      /*console.log('onChangeUserCalled');
      console.log(this.$store.state.allTimesheetsFromDate.length);*/
      let res = this.$store.state.allTimesheetsFromDate.filter(obj => {
        return obj.userId === userId;
      });
      /*console.log('User Timesheets');
      console.log(res.length);
      console.log(res);*/

      var xMonths = this.userMonthsSelected; //default for now, allow this to be modified in the future
      var monthNames = getLastXMonthNames(xMonths);
      var monthlySums = caclulateMonthlyTimesheetSums(res);
      var lastXMonths = getLastXMonthDates(xMonths);
      

      var billableHoursArray = lastXMonths.map(function (key){
        return monthlySums[key] ? monthlySums[key].billableHours : 0;
      });

      var expenseArray = lastXMonths.map(function (key){
        return monthlySums[key] ? monthlySums[key].expenseAmount : 0;
      });

      var nonBillableHoursArray = lastXMonths.map(function (key){
        return monthlySums[key] ? monthlySums[key].nonBillableHours : 0;
      })


      let billableHours = 0;
      let nonBillableHours  = 0;
      billableHours = billableHoursArray.reduce((partialSum, a) => partialSum + a, 0);
      nonBillableHours = nonBillableHoursArray.reduce((partialSum, a) => partialSum + a, 0);

      this.billableDoughnutChart.data.datasets[0].data = [billableHours, nonBillableHours];
      this.billableDoughnutChart.update();

      this.billingOverTimeChart.data.labels = monthNames;
      this.billingOverTimeChart.data.datasets[0].data = billableHoursArray;
      this.billingOverTimeChart.update();

      this.expenseOverTimeChart.data.labels = monthNames;
      this.expenseOverTimeChart.data.datasets[0].data = expenseArray;
      this.expenseOverTimeChart.update();
      
      return null;
    },
    changeUserMonths(number){
      console.log("changeUserMonths")
      this.userMonthsSelected = number;
      this.onChangeUser(this.userId);
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
  mounted(){
    this.initializeDoughChart();
    this.initializeBillableOverTimeChart();
    this.initializeExpenseOverTimeChart();
  },
  data() {
    return {
      userMonthsSelected: 6,
      toggle_exclusive: 0,
      expenseOverTimeChart: null,
      billingOverTimeChart: null,
      billableDoughnutChart: null,
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

/*function changeUserMonths(){
    this.userMonthsSelected = 3;
    this.onChangeUser(this.userId);
  }*/

function getLastXMonthNames(x) {
  let currentDate = new Date();
  var monthNames = [];
  for(var i = 0; i< x; i++){
    var month = currentDate.getMonth() -i;
    var year = currentDate.getFullYear();
    if(month < 0){
      month+= 12;
      year--;
    }
    var monthDate = new Date(year, month,1);
    var monthName = monthDate.toLocaleString('default', {month: 'long'});
    monthNames.push(monthName);
  }
  monthNames.reverse();
  return monthNames;
}

function getLastXMonthDates(x) {
  var lastXMonths = [];
  var currentDate = new Date();
  for(var i = 0; i< x; i++){
    var month = currentDate.getMonth() -i;
    var year = currentDate.getFullYear();
    if(month < 0){
      month+= 12;
      year--;
    }
    lastXMonths.push(year + '-'+month);
  }
  lastXMonths.reverse();
  return lastXMonths;
}

function caclulateMonthlyTimesheetSums(timesheets){
  let monthlySums = {};
  timesheets.forEach(function (timesheet){
      timesheet.timesheetEntries.forEach(timesheetEntry =>{
        var entryDate = new Date(timesheetEntry.entryDate);
        var year = entryDate.getFullYear();
        var month = entryDate.getMonth();
        var key = year + '-'+month;

        if(!monthlySums[key]){
          monthlySums[key] = {billableHours: 0, expenseAmount: 0, nonBillableHours: 0};
        }

        if(timesheet.project.categoryId === 3 || timesheet.project.categoryId === null){
          monthlySums[key].billableHours += timesheetEntry.hoursBillable;
          monthlySums[key].expenseAmount += timesheetEntry.expenseAmount;
        }else{
          monthlySums[key].nonBillableHours += (timesheetEntry.hoursBillable + timesheetEntry.hoursUnBillable);
        }
      })
    }
  );
  return monthlySums;
}
</script>

<style scoped>
.v-card{
  outline-color: black !important;
  box-shadow: 10px !important;
}

.v-flex{
  display: flex;
}

</style>
