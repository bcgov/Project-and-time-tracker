<template>
  <v-card style="margin: 15px;width: 100%;">
  <v-container grid-list-xl fluid  >
    <v-layout>
      <v-flex md12>
        <h2 class="timesheet-header" style="text-align: center; font-size: 24px;">Timesheet Details Report</h2>
      </v-flex>
    </v-layout>
    
        
<!-- FILTERS -->
    <v-layout row wrap style="gap:40px; height: 60px;">
      <v-flex xs12 md3>
        <v-text-field
          label="Start Date"
          v-model="filters.startDate"
          type="date"
          clearable
          @change="onFilterChange"
        />
      </v-flex>
      <v-flex xs12 md3>
        <v-text-field
          label="End Date"
          v-model="filters.endDate"
          type="date"
          clearable
          @change="onFilterChange"
        />
      </v-flex>
    </v-layout>
    <v-layout row wrap style="gap:40px; height: 100px;">
      <v-flex xs12 md5>
        <v-select
          label="User"
          :items="users"                
          :item-text="userLabel"        
          item-value="id"               
          v-model="filters.userIds"
          multiple
          chips
          deletable-chips
          clearable
          autocomplete
          @change="onFilterChange"
          :disabled="!isAdmin"
        ></v-select>
        </v-flex>

      <v-flex xs12 md5>
        <v-select
          label="Project"
          :items="projects"
          item-text="projectName"
          item-value="id"
          v-model="filters.projectIds"
          multiple
          chips
          deletable-chips
          clearable
          autocomplete
          @change="onFilterChange"
        />
      </v-flex>
    </v-layout>

    <!-- ACTIONS -->
    <v-layout row align-center justify-space-between class="mb-2">
      
        <div class="text-caption">
        <strong>{{ totalHours }}</strong> total rows match filters
        <span v-if="pagination.rowsPerPage > 0">
            • showing {{ pageCountThisPage }} on page {{ pagination.page }}
        </span>
        </div>

      <div>
        <v-btn small color="primary" class="mr-2" @click="exportCsv">
          Export CSV
        </v-btn>

      </div>
    </v-layout>

    <hr></hr>
    
<!-- DATA TABLE (Vuetify 1.5 API) -->
    <v-data-table
        :headers="headers"
        :items="items"
        :loading="loading"
        :pagination.sync="pagination"
        :rows-per-page-items="[10, 25, 50, 100]"
        :total-items="totalHours"        
        @update:pagination="onPaginate"
    >
      <template slot="items" slot-scope="props">
        <td>{{ props.item.fullName }}</td>
        <td>{{ formatDate(props.item.entryDate) }}</td>
        <td class="text-xs-right">{{ formatNumber(props.item.hoursBillable) }}</td>
        <td class="text-xs-right">{{ formatNumber(props.item.hoursUnBillable) }}</td>
        <td>{{ props.item.projectName }}</td>
        <td>{{ props.item.rfxName }}</td>
        <td>{{ props.item.Mou }}</td>
        <td>{{ props.item.IsProjectBillable }}</td>
      </template>

      <v-progress-linear slot="progress" color="primary" indeterminate />
    </v-data-table>
  </v-container>
  </v-card>
</template>



<script>
import { getRoles } from '../../../modules/security/init';

export default {
  name: 'TimesheetReportV15',
  
data() {
    return {
      loading: false,
      items: [],
      isAdmin: false,
      ready: false, 

      // Vuetify 1.5 pagination object (client-side)
      pagination: {
        page: 1,
        rowsPerPage: 25,
        sortBy: 'fullName', // must match a header 'value'
        descending: false
      },

      // Add 'user' and 'project' if you want those client-side filters to work
      filters: { 
        startDate: null,
        endDate: null, 
        userIds: [],
        userNames: [],
        projectIds: [],
      },

      headers: [
        { text: 'Name', value: 'fullName', sortable: true },
        { text: 'Entry Date', value: 'entryDate', sortable: true },
        { text: 'Billable Hours', value: 'hoursBillable', align: 'right', sortable: true },
        { text: 'Unbillable Hours', value: 'hoursUnBillable', align: 'right', sortable: true },
        { text: 'Project', value: 'projectName', sortable: true },
        { text: 'RFX', value: 'rfxName', sortable: true },
        { text: 'MOU', value: 'Mou', sortable: true },
        { text: 'IsBillable', value: 'IsProjectBillable', sortable: true }
      ]
    };
  },

  computed: {
    // optional helpers to build dropdowns if you want them
    
        users() {
            // Ensure it's an array; if your store keeps a dictionary, convert it:
            const src = this.$store.state.users;
            return Array.isArray(src) ? src : Object.values(src || {});
        },

        projects() {
            // Ensure it's an array; if your store keeps a dictionary, convert it:
            const src = this.$store.state.projects;
            return Array.isArray(src) ? src : Object.values(src || {});
        },

    
    // If you’re still using client-side filteredItems for display:
    pageCountThisPage() {
        // when using server-side items, this is just items.length
        const list = Array.isArray(this.items) ? this.items : [];
        return list.length;
    },

    totalHours() {
        // from Vuex
        return this.$store.state.totalHours;
        // or via getter: return this.$store.getters['timesheet/totalHours'];
    }

  },

  
    async mounted() {
      
      await Promise.all([
        this.$store.dispatch('fetchProjects'),
        this.$store.dispatch('fetchUsers') // <-- fetch unconditionally (or guard correctly)
      ]);

      const referenceId = this.$store.state.activeUser?.refId;
      const me = this.users.find(u => u.referenceId === referenceId);
      
      if (!this.isAdmin) {
        // Non-admins are restricted to themselves
        this.$set(this.filters, 'userIds', [me.id]); // ensure reactivity
      } else {
        // Admins can choose (default: nobody selected = fetch all depending on API rules)
      }

      this.ready = true;
      await this.onPaginate(this.pagination);      // initial page with filters
    },

    created(){
     this.setAdmin();
    },


    methods: {
    async setAdmin() {
      const roles =  await getRoles();
      console.log(roles);
      this.isAdmin = roles.includes('PSB_Admin');
    },
        
    async onFilterChange() {
      // reset to first page when filters change
      this.pagination = { ...this.pagination, page: 1 };
      await this.onPaginate(this.pagination);
    },


    async onPaginate(p) {
        this.pagination = p;
        const { page, rowsPerPage } = p;
        if (!this.ready) return;
        this.loading = true;
        try {
            // Pass page + multi-select arrays to store action
            const res = await this.$store.dispatch('fetchAllHours', {
            page,
            pageSize: rowsPerPage,
            startDate: this.filters.startDate,
            endDate: this.filters.endDate,
            userIds: this.filters.userIds,
            projectIds: this.filters.projectIds
            });
            // Assign current page + total from store or response
            this.items = this.$store.state.allHours;     // array
            this.total = this.$store.state.totalHours;   // number
        } finally {
            this.loading = false;
        } 
    },

    async loadData() {
      try {
        this.loading = true;
        await this.$store.dispatch('fetchProjects');
        
        this.items = this.$store.state.allHours;       // current page array
        this.total = this.$store.state.totalHours;     // (if you want a local copy)
        console.log(this.items);
        console.log( this.$store.state.projects);
      } catch (e) {
        console.error('Failed to load timesheet data', e);
      } finally {
        this.loading = false;
      }
    },
    
    userLabel(u) {
        return u?.contact?.fullName || u?.fullName || '(Unknown user)';
    },


    
// Formatting helpers
    formatDate(d) {
      if (!d) return '';
      const date = new Date(d);
      return isNaN(date) ? d : date.toISOString().slice(0, 10);
    },
    formatNumber(n) {
      if (n == null || n === '') return '';
      const num = Number(n);
      return isNaN(num) ? n : num.toFixed(2);
    },
    
    
    buildExportQuery() {
        const params = new URLSearchParams();
        if (this.filters.startDate) params.set('startDate', this.filters.startDate);
        if (this.filters.endDate) params.set('endDate', this.filters.endDate);
        if (Array.isArray(this.filters.userIds) && this.filters.userIds.length) {
          params.set('userIds', this.filters.userIds.join(','));
          // 2. Map IDs to Full Names
          const selectedFullNames = this.filters.userIds.map(id => {
            const user = this.users.find(u => u.id === id);
            return user ? this.userLabel(user) : null;
          }).filter(name => name !== null);

          if (selectedFullNames.length) {
            params.set('userNames', selectedFullNames.join(','));
          }
        }
        if (Array.isArray(this.filters.projectIds) && this.filters.projectIds.length) {
          params.set('projectIds', this.filters.projectIds.join(','));
        }
        return params.toString();
      },



      exportCsv() {
        const qs = this.buildExportQuery();
        this.$store.dispatch("fetchTimesheetReport", {qs});
      },
      
    // If you *must* send Authorization headers (Bearer token), use axios/fetch with blob:
      async exportCsvWithHeaders() {
        const qs = this.buildExportQuery();
        const res = await this.$http.get(`${API_URI}/report/export.csv?${qs}`, { responseType: 'blob' });
        const blob = new Blob([res.data], { type: 'text/csv;charset=utf-8;' });
        const a = document.createElement('a');
        a.href = URL.createObjectURL(blob);
        a.download = this.buildCsvFilename();
        document.body.appendChild(a); a.click(); a.remove();
        URL.revokeObjectURL(a.href);
      },

  }
};
</script>

<style scoped>
.v-data-table td, .v-data-table th { white-space: nowrap; }

::v-deep .v-select--chips .v-select__selections {
  max-height: 42px; /* Leaves room for 1 row of chips */
  overflow-y: auto; /* Adds a tiny scroll if they select too many, instead of expanding */
}
</style>