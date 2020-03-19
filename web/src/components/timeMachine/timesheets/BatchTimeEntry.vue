<template>
  <v-layout column justify-center>
      <v-flex>
          <v-data-table
                :headers="headers"
                :items="weekEntries"
                hide-actions
                class="elevation-0 tm-v-datatable"
              >
            <template v-slot:items="props">
              <td>
                  <v-select
                        :items="allProjects"
                        item-text="projectName"
                        item-value="id"
                        label="Project Name">
                        <!-- TODO - Truncate name if Proj name too long -->
                        <!-- <template v-slot:selection='{item}'>
                        {{ item.projectName }}
                        </template> -->
                  </v-select>
              </td>
              <td>
                <v-text-field type='number' single-line label='Hours'></v-text-field>
              </td>
              <td>
                <v-text-field type='number' single-line label='Hours'></v-text-field>
              </td>
              <td>
                <v-text-field type='number' single-line label='Hours'></v-text-field>
              </td>
              <td>
                <v-text-field type='number' single-line label='Hours'></v-text-field>
              </td>
              <td>
                <v-text-field type='number' single-line label='Hours'></v-text-field>
              </td>
              <td>

                <v-edit-dialog
                  :return-value.sync="props.item.commentsBillable"
                  lazy
                >
                  {{ props.item.commentsBillable ? props.item.commentsBillable : '...' }}
                  <template
                    v-slot:input
                  >
                    <v-text-field
                      v-model="props.item.commentsBillable"
                      label="Rate"
                      single-line
                    ></v-text-field>
                  </template>
                </v-edit-dialog>
              </td>
            </template>
          </v-data-table>
  </v-flex>


    <v-flex>
        <v-btn @click='addRow'>Add another entry</v-btn>
    </v-flex>





     <!-- <v-form ref="form" v-model="valid" lazy-validation class="timesheet-entry">
      <spinner ref="spinner"></spinner>
      <v-container grid-list-xl>
        <v-layout row wrap>
          <v-flex md1>Day</v-flex>
          <v-flex md2>Hours</v-flex>

          <v-flex md8>Description</v-flex>
          <v-flex md1></v-flex>
        </v-layout>

        <v-layout v-for="(item, index) in weekData" :key="item.day" class="time-records">
          <v-flex md1>{{ item.day }}</v-flex>
          <v-flex md2>
            <v-text-field
              type="number"
              max="24"
              step="0.1"
              min="0"
              oninput="validity.valid||(value=0);"
              v-model="item.hours"
            ></v-text-field>
          </v-flex>

          <v-flex md8>
            <v-text-field v-model="item.description"></v-text-field>
          </v-flex>
          <v-flex md2>
            <v-tooltip top open-delay='500'>
              <template v-slot:activator="{ on }">
                <v-btn flat icon @click="copyfunc(item.hours, item.description)" v-on="on">
                  <v-icon>file_copy</v-icon>
                </v-btn>
              </template>
              <span>Copy</span>
            </v-tooltip>

            <v-tooltip top open-delay='500'>
              <template v-slot:activator="{ on }">
                <v-btn flat icon @click="pastefunc(index)" v-on="on">
                  <v-icon>post_add</v-icon>
                </v-btn>
              </template>
              <span>Paste</span>
            </v-tooltip>

          </v-flex>
        </v-layout>
      </v-container>
    </v-form> -->


  </v-layout>
</template>
<script>
import Spinner from '../common/Spinner'
export default {
  components: {
    Spinner
  },
  computed: {
    allProjects() {
      return this.$store.state.projects;
    }
  },
  data(){
    return {
      weekData: [
        { day: "Mon", description: "", hours: 0, date: "" },
          { day: "Tue", description: "", hours: 0, date: "" },
          { day: "Wed", description: "", hours: 0, date: "" },
      ],
      valid: true,

       headers: [
        { text: "Project", value: "contact.fullName" },
        { text: "Monday", value: "contact.fullName" , sortable: false},
        { text: "Tuesday", value: "contact.hourlyRate" , sortable: false},
        { text: "Wednesday", value: "contact.hourlyRate" , sortable: false},
        { text: "Thursday", value: "contact.hourlyRate" , sortable: false},
        { text: "Friday", value: "contact.hourlyRate" , sortable: false},
        { text: "Comments", value: "contact.hourlyRate", sortable: false }
      ],

      weekEntries: [
        this.createEmptyWeekEntry()
      ]
    }
  },
  methods: {
    createEmptyWeekEntry(){
      return {
        // project: undefined
        // monday: undefined,
        // tuesday: undefined,
        // wednesday: undefined,
        // thursday: undefined
        // friday: undefined
        // comments: undefined
      }
    },
    addRow(){
      this.weekEntries.push(this.createEmptyWeekEntry());
    }
  }
}
</script>
