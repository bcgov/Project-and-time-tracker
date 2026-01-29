<template>
  <v-container grid-list-xl fluid class="page-container custom-timesheets-container">
    <v-layout>
      <v-flex md12>
        <h1 class="timesheet-header">Timesheet Details Report</h1>
      </v-flex>
    </v-layout>
    <v-card>
        
<!-- FILTERS -->
    <v-layout row wrap>
      <v-flex xs12 md3>
        <v-text-field
          label="Start Date"
          v-model="filters.startDate"
          type="date"
          box
          clearable
          @change="onFilterChange"
        />
      </v-flex>

      <v-flex xs12 md3>
        <v-text-field
          label="End Date"
          v-model="filters.endDate"
          type="date"
          box
          clearable
          @change="onFilterChange"
        />
      </v-flex>

      <v-flex xs12 md3>
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
        box
        @change="onFilterChange"
        />
        </v-flex>

      <v-flex xs12 md3>
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
          box
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
        <v-btn small color="success" @click="exportXlsx">
          Export Excel (.xlsx)
        </v-btn>
      </div>
    </v-layout>

    
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



    </v-card>
  </v-container>
</template>



<script>
export default {
  name: 'TimesheetReportV15',
  
data() {
    return {
      loading: false,
      items: [],
      //users: [],

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
        userIds: [],      // <-- use ids (not names)
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
    /*filteredItems() {
      const { startDate, endDate, user, project } = this.filters;
      const start = startDate ? new Date(startDate) : null;
      const end = endDate ? new Date(endDate) : null;

      return this.items.filter(row => {
        const rowDate = row.entryDate ? new Date(row.entryDate) : null;
        const matchesDate =
          (!start || (rowDate && rowDate >= start)) &&
          (!end || (rowDate && rowDate <= end));
        const matchesUser = !user || row.fullName === user;
        const matchesProject = !project || row.projectName === project;
        return matchesDate && matchesUser && matchesProject;
      });
    },*/
    
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
        // Load reference data first (if not already loaded elsewhere)
        await this.$store.dispatch('fetchProjects'); // and fetchUsers if you have it
        await this.onPaginate(this.pagination);      // initial page with filters
    },


    methods: {
        
    async onFilterChange() {
      // reset to first page when filters change
      this.pagination = { ...this.pagination, page: 1 };
      await this.onPaginate(this.pagination);
    },


    async onPaginate(p) {
        this.pagination = p;
        const { page, rowsPerPage } = p;
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
        // your existing call (make sure backend caps with .limit(100) as discussed)
        await this.$store.dispatch('fetchProjects');
        await this.$store.dispatch('fetchAllHours');
        
        this.items = this.$store.state.allHours;       // current page array
        this.total = this.$store.state.totalHours;     // (if you want a local copy)
        //this.users = this.$store.state.users;
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

    // CSV/XLSX export (same safe version we discussed)
    exportCsv() {
      const rows = this.filteredItems;
      const cols = this.headers.filter(h => !!h.value);
      const header = cols.map(h => this.escapeCsv(h.text)).join(',');
      const lines = rows.map(r => cols.map(h => this.escapeCsv(this.csvCellValue(h.value, r))).join(','));
      const csvString = '\uFEFF' + [header, ...lines].join('\r\n');
      const filename = this.buildCsvFilename();

      if (window.navigator && window.navigator.msSaveOrOpenBlob) {
        const blob = new Blob([csvString], { type: 'text/csv;charset=utf-8;' });
        window.navigator.msSaveOrOpenBlob(blob, filename);
      } else {
        const blob = new Blob([csvString], { type: 'text/csv;charset=utf-8;' });
        const url = URL.createObjectURL(blob);
        const link = document.createElement('a');
        link.href = url;
        link.setAttribute('download', filename);
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        URL.revokeObjectURL(url);
      }
    },
    escapeCsv(val) {
      if (val == null) return '';
      const str = String(val);
      return /[",\n]/.test(str) ? `"${str.replace(/"/g, '""')}"` : str;
    },
    csvCellValue(key, row) {
      switch (key) {
        case 'entryDate': return this.formatDate(row.entryDate);
        case 'hoursBillable': return this.formatNumber(row.hoursBillable);
        case 'hoursUnBillable': return this.formatNumber(row.hoursUnBillable);
        default: return row[key] != null ? row[key] : '';
      }
    },
    buildCsvFilename() {
      const date = new Date();
      const yyyy = date.getFullYear();
      const mm = String(date.getMonth() + 1).padStart(2, '0');
      const dd = String(date.getDate()).padStart(2, '0');
      let userName = '';
      try {
        const user = this.$store?.state?.users?.find(item => item.id === this.form?.userId);
        if (user) userName = user.contact.fullName;
      } catch {}
      return `TimeMachine-${yyyy}${mm}${dd}-${userName || 'All'}.csv`;
    },

    async exportXlsx() {
      const XLSX = window.XLSX;
      if (!XLSX) {
        console.warn('SheetJS not found, falling back to CSV.');
        this.exportCsv();
        return;
      }
      const rows = this.filteredItems;
      const cols = this.headers.filter(h => !!h.value);
      const aoa = [
        cols.map(h => h.text),
        ...rows.map(r => cols.map(c => {
          const key = c.value;
          if (key === 'entryDate') return this.formatDate(r.entryDate);
          if (key === 'hoursBillable') return Number(r.hoursBillable || 0);
          if (key === 'hoursUnBillable') return Number(r.hoursUnBillable || 0);
          return r[key] != null ? r[key] : '';
        }))
      ];
      const ws = XLSX.utils.aoa_to_sheet(aoa);
      ws['!cols'] = cols.map(h => {
        if (/hours/i.test(h.text)) return { wch: 16 };
        if (/date/i.test(h.text)) return { wch: 12 };
        if (/project|name|rfx|mou/i.test(h.text)) return { wch: 24 };
        return { wch: 12 };
      });
      const wb = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(wb, ws, 'Timesheets');
      const wbout = XLSX.write(wb, { bookType: 'xlsx', type: 'array' });
      const blob = new Blob([wbout], { type: 'application/octet-stream' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = this.buildCsvFilename().replace('.csv', '.xlsx');
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
    }
  }
};
</script>

<style scoped>
.v-data-table td, .v-data-table th { white-space: nowrap; }
</style>
``
