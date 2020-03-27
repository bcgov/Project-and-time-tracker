/**
 * One store to rule them all...
 */
import Vue from 'vue';
import Vuex from 'vuex';

import merge from 'object-merge';

// Menu items
import menu from '@/menu';
// Env config
import config from '@/config';
// Security store module
import security from '@/modules/security/store';

// import axios from 'axios';
import $http from '@/modules/axios';
import moment from 'moment';

// Import dtos
import IntakeRequestDto from '@/domain/models/Intake.dto';

import HashTable from '@/utils/HashTable';
import RFxDto from '@/domain/models/RFx.dto';

const API_URI = process.env.VUE_APP_API_URI || 'http://localhost:3000';
console.log('API URL:', { API_URI })

Vue.use(Vuex);

if (typeof security === 'undefined') throw new Error('Security cannot be undefined');
const store = new Vuex.Store({
  modules: {
    security,
    // app
  },
  state: {
    menuIsOpen: false,
    menu,
    config,
    // Users and roles
    activeUser: {}, // TODO: Default user shape
    activeRoles: [],
    users: [],
    clients: [],
    services: [],
    projectSectors: [],
    projectIntakeCategory: [],
    projectIntakeServices: [],
    ministries: [],
    allMinistries: [],
    rfxPhases: [],
    rfxTypes: [],
    timesheetEntryData: [],
    projectRiskAnswers: [],
    intakeRiskQuestions: [],
    mouList: [],
    // Intake form component
    activeIntakeRequestId: null,
    activeIntakeRequest: {},
    intakeRequests: [],
    // Projects component
    activeProjectId: null,
    activeProject: {},
    activeProjectRfxData: [],
    activeProjectContacts: [],
    projects: [],
    archivedProjects: [],
    projectsRfx: new HashTable(),
    // Timesheets component
    activeTimesheetEntryRowId: null, // Row of timesheet entries (1 week)
    activeTimesheetEntryRow: {},
    timesheets: [],
    unbilledTimesheets: [],
    timesheetEntries: [],
    allTimesheets: [], // used in table view of all timesheets
    allProcurementLog: [],
    allProjectNotes: [],
    collapseNavigationBar: false,
    projectInformation: false,
    ministryInformation: false,
    contactInformation: false,
    intakeRisk: false,
    timesheetsWeek: {
      startDate: null,
      endDate: null,
    },
    drawerComments: false,
    drawerCommentsEntries: [],
    verifyTokenServer: null,
    timeLogOfSelectedDate: null,
  },
  /**
   * Mutations are functions that are used to modify store data - they should be pure.
   */
  mutations: {
    setAuth(state, {
      user,
      token,
    }) {
      state.user = user;
      state.token = token;
      global.helper.ls.set('user', user);
      global.helper.ls.set('token', token);
    },
    setMenu(state, data) {
      state.menu = data;
    },
    setPageTitle(state, data) {
      state.pageTitle = data;
    },
    setFeedbackMessages(state, type, body) {
      state.message = {
        type,
        body,
      };
    },
    // Timesheet Dates
    setTimesheetsWeek(state, data) {
      state.timesheetsWeek = {
        startDate: data.startDate,
        endDate: data.endDate,
      };
    },
    // Verify data
    verifyTokenServer(state, data) {
      // console.log('verifyTokenServer called', {state, data})
      state.verifyTokenServer = data;
    },
    // Master data
    fetchMinistries(state, data) {
      // console.log('fetchMinistries called', data);
      state.ministries = data;
    },
    fetchAllMinistries(state, data) {
      state.allMinistries = data;
    },
    fetchintakeRiskQuestions(state, data) {
      state.intakeRiskQuestions = data;
    },
    fetchprojectRiskAnswers(state, data) {
      state.projectRiskAnswers = data;
    },
    fetchTimesheetEntries(state, data) {
      state.timesheetEntryData = data;
    },
    fetchRFxPhases(state, data) {
      state.rfxPhases = data;
    },
    fetchRFxTypes(state, data) {
      state.rfxTypes = data;
    },
    fetchProjectSectors(state, data) {
      // console.log('fetchProjectSectors called', {state, data})
      state.projectSectors = data;
      // TODO: Remove me! I'm just for backward compat right now...
      state.services = data;
    },
    fetchProjectIntakeCategory(state, data) {
      state.projectIntakeCategory = data;
      // TODO: Remove me! I'm just for backward compat right now...
      state.services = data;
    },
    fetchProjectIntakeServices(state, data) {
      state.projectIntakeServices = data;
      // TODO: Remove me! I'm just for backward compat right now...
      state.services = data;
    },
    fetchProjectRfx(state, data) {
      state.projectsRfx.set(data.projectId, data.content);
    },
    // Clients or Government Ministries
    fetchClients(state, data) {
      state.clients = data;
    },
    fetchClient() {
    },
    fetchMOUs(state, data) {
      state.mouList = data;
    },
    addClient() {
      throw new Error('Not implemented!');
    },
    updateClient() {
      throw new Error('Not implemented!');
    },
    deleteClient() {
      throw new Error('Not implemented!');
    },
    fetchContacts(state, data) {
      state.contacts = data;
    },
    addContact() {
      throw new Error('Not implemented!');
    },
    updateContact() {
      throw new Error('Not implemented!');
    },
    deleteContact() {
      throw new Error('Not implemented!');
    },
    // User contacts (profiles?)
    fetchUsers(state, data) {
      // console.log('fetchUsers called', { state, data } )
      state.users = data;
    },
    addUser() {
      throw new Error('Not implemented!');
    },
    addMinistry(state, data) {
      console.log('TODO - NOT SURE IF COMPLETE - addMinistry MUTATION called', { state, data });
      // state.ministries = data;
      // throw new Error('Not implemented');
    },
    updateUser(state, data) {
      // throw new Error('Not implemented!');
      console.log('TODO', {users: state.users, data});
    },
    deleteUser() {
      throw new Error('Not implemented!');
    },
    // Intake requests
    fetchIntakeRequests(state, data) {
      Vue.set(state, 'intakeRequests', [...data]);
    },
    fetchIntakeRequest(state, data) {
      // TODO: Overwrite intakeRequests entry
      state.activeIntakeRequest = IntakeRequestDto.constructFromObject(data);
    },
    clearActiveIntakeRequest(state, data) {
      state.activeIntakeRequest = data;
    },
    addIntakeRequest(state, data) {
      state.activeIntakeRequest = IntakeRequestDto.constructFromObject(data);
    },
    updateIntakeRequest(state, data) {
      // console.log('mutation.updateIntakeRequest', state.intakeRequests)
      // update only the correct record, use filter or something?
      // console.log('state.intakeRequests')

      // throw new Error('Not implemented!');
    },
    deleteIntakeRequest() {
      // throw new Error('Not implemented!');

    },
    approveIntakeRequest() {
      throw new Error('Not implemented!');
    },
    assignContactToIntakeRequest() {
      throw new Error('Not implemented!');
    },
    createMOU(state, data) {
      console.log('createMOU mutation', data);
      // state.mouList = data;
      state.mouList.push(data);
    },
    // Projects
    fetchProjects(state, data) {
      state.projects = []; //reset state, helps when archiving/deleting.
      if (data instanceof Array) {
        data.forEach((project) => {
          project.projectLeadUserId = project.leadUserId;

          project.projectBackupUserId = project.backupUserId;
          project.ministryInformation = project.ministryInformation
          const exists = state.projects.filter(item => item.id === project.id) || [];

          if (exists.length > 0) {
            const itemIdx = state.projects.indexOf(exists[0]);
            state.projects[itemIdx] = merge(state.projects[itemIdx], project);
          } else {
            state.projects.push(project);
          }
        });
      }
    },
    fetchProject(state, data) {
      // TODO: Overwrite projects entry
      state.activeProject = data;
    },
    fetchArchivedProjects(state, data) {
      state.archivedProjects = data;
    },
    addProject() {
      throw new Error('Not implemented!');
    },
    updateProject() {
    },
    deleteProject() {
      throw new Error('Not implemented!');
    },
    assignResourceToProject() {
      throw new Error('Not implemented!');
    },
    assignContactToProject() {
      throw new Error('Not implemented!');
    },
    assignProjectLead() {
    },
    assignProjectBackup() {
    },
    // Project Contacts
    fetchProjectContacts(state, data) {
      state.activeProjectContacts = data;
    },
    updateProjectContacts() {
    },
    updateProjectFinanceCodes() {
    },
    updateProcurementLog() {
    },
    addProjectNotes() {
    },
    // Project RFx
    fetchProjectRFxData(state, data) {
      // if it's an empty array, need to add blank rfX type
      console.log('fetchProjectRFxData', { data })
      if (data && data.length === 0) {
        data.push(new RFxDto());
      }

      state.activeProjectRfxData = data;
    },
    addProjectRFxData() {
    },
    updateProjectRFxData() {
    },
    // Timesheets
    fetchTimesheets(state, { data, replace }) {
      if (data instanceof Array) {
        if (replace === true) {
          state.timesheets = data;
        } else {
          data.forEach((timesheet) => {
            const exists = state.timesheets.filter(item => item.id === timesheet.id) || [];

            if (exists.length > 0) {
              const itemIdx = state.timesheets.indexOf(exists[0]);
              state.timesheets[itemIdx] = merge(state.timesheets[itemIdx], timesheet);
            } else {
              state.timesheets.push(timesheet);
            }
          });
        }
      }
    },
    fetchAllTimesheets(state, data) {
      console.log('fetchAllTimesheets', data);
      state.allTimesheets = data;
    },
    fetchAllProcurementLog(state, data) {
      console.log('fetchAllProcurementLog', data);
      state.allProcurementLog = data;
    },
    fetchAllProjectNotes(state, data) {
      console.log('fetchAllProjectNotes', data);
      console.log('projectnotes:', data);
      state.allProjectNotes = data;
    },
    getTimeLogOfSelectedDate(state, data) {
      state.timeLogOfSelectedDate = data;
    },
    addTimesheet(state, data) {
      const timesheet = data;

      const exists = state.timesheets.filter(item => item.id === timesheet.id) || [];

      if (exists.length > 0) {
        const itemIdx = state.timesheets.indexOf(exists[0]);
        state.timesheets[itemIdx] = merge(state.timesheets[itemIdx], timesheet);
      } else {
        state.timesheets.push(timesheet);
      }
    },
    updateTimesheet(state, data) {
      const timesheet = data;

      const exists = state.timesheets.filter(item => item.id === timesheet.id) || [];

      if (exists.length > 0) {
        const itemIdx = state.timesheets.indexOf(exists[0]);
        state.timesheets[itemIdx] = merge(state.timesheets[itemIdx], timesheet);
      } else {
        state.timesheets.push(timesheet);
      }
    },
    deleteTimesheet(state, data) {
      const deletedTimesheetArr = state.timesheets.filter(item => item.id !== data.timesheetId) || [];
      state.timesheets = deletedTimesheetArr;
    },
    addTimesheetEntry() {
      throw new Error('Not implemented!');
    },
    addWeekTimesheetEntries() {
      throw new Error('Not implemented!');
    },
    updateTimesheetEntry() {
      throw new Error('Not implemented!');
    },
    updateWeekTimesheetEntries() {
      throw new Error('Not implemented!');
    },
    deleteTimesheetEntry() {
      throw new Error('Not implemented!');
    },
    deleteWeekTimesheetEntries() {
      throw new Error('Not implemented!');
    },
    approveTimesheetEntry() {
      throw new Error('Not implemented!');
    },
    approveWeekTimesheetEntries() {
      throw new Error('Not implemented!');
    },
    addTimesheetEntryComment() {
      throw new Error('Not implemented!');
    },
    updateTimesheetEntryComment() {
      throw new Error('Not implemented!');
    },
    deleteTimesheetEntryComment() {
      throw new Error('Not implemented!');
    },
    archiveProject(state, data) {
      console.log('archiveProject response', data);
    }
  },
  /**
   * This layer uses our service classes to make AJAX requests to the backend.
   * They should NEVER mutate state directly, and should ONLY update store data
   * by invoking mutations.
   */
  actions: {
    checkAuth(ctx) {
      const data = {
        user: global.helper.ls.get('user'),
        token: global.helper.ls.get('token'),
      };
      ctx.commit('setAuth', data);
    },
    // Timesheet Dates
    setTimesheetsWeek(ctx, data) {
      ctx.commit('setTimesheetsWeek', {
        startDate: data.startDate,
        endDate: data.endDate,
      });
    },
    // Verification
    async verifyTokenServer(ctx) {
      const api = await $http
        .get(`${API_URI}/auth/verify`)
        .then((res) => {
          const content = res.data;
          ctx.commit('verifyTokenServer', content);
          return Promise.resolve(content);
        })
        .catch(err => Promise.reject(err.response));
      return Promise.resolve(api);
    },
    // Master data
    fetchMinistries(ctx) {
      $http
        .get(`${API_URI}/ministry`)
        .then((res) => {
          const content = res.data;
          ctx.commit('fetchMinistries', content);
        });
    },
    // Returns archived ministries + unarchived
    fetchAllMinistries(ctx) {
      $http
        .get(`${API_URI}/ministry/all`)
        .then((res) => {
          const content = res.data;
          ctx.commit('fetchAllMinistries', content);
        });
    },
    async addMinistry(ctx, req) {
      const body = req;
      const api = $http
        .post(`${API_URI}/ministry`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('addMinistry', content);
          return Promise.resolve(res.data);
        })
        .catch(err => Promise.reject(err));
      return Promise.resolve(api);
    },
    async updateMinistries(ctx, req) {
      const api = await $http
        .patch(`${API_URI}/ministry/${req.id}/update`, req)
        .then((res) => {
          console.log('updateMinistires RESPONSE', { res })
          return Promise.resolve(res.data)
        })
        .catch(err => Promise.reject(err));
      return Promise.resolve(api);
    },
    fetchintakeRiskQuestions(ctx) {
      $http
        .get(`${API_URI}/project-risk`)
        .then((res) => {
          const content = res.data;
          ctx.commit('fetchintakeRiskQuestions', content);
        });
    },
    fetchprojectRiskAnswers(ctx, req) {
      $http.get(`${API_URI}/project-risk/${req.id}`).then(res => {
        const content = res.data;
        ctx.commit("fetchprojectRiskAnswers", content);
      });
    },
    async fetchTimesheetEntries(ctx, req) {
      const body = req;
      const api = await $http
        .post(`${API_URI}/timesheet/timesheetentries`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('fetchTimesheetEntries', content);
          return Promise.resolve(content);
        })
        .catch(err => Promise.reject(err.response));
      return Promise.resolve(api);
    },
    fetchRFxPhases(ctx) {
      $http.get(`${API_URI}/rfx-phase`)
        .then((res) => {
          const content = res.data;
          ctx.commit('fetchRFxPhases', content);
        });
    },
    fetchRfxTypes(ctx) {
      $http
        .get(`${API_URI}/rfx-type`)
        .then((res) => {
          const content = res.data;
          ctx.commit('fetchRfxTypes', content);
        });
    },
    async fetchProjectRfx(ctx, req) {
      const api = await $http
        .get(`${API_URI}/project-rfx/${req.id}/by-project-id`)
        .then((res) => {
          const content = res.data;
          ctx.commit('fetchProjectRfx', {
            projectId: req.id,
            content,
          });
          return Promise.resolve(content);
        })
        .catch(err => Promise.reject(err));
      return Promise.resolve(api);
    },
    fetchRFxTypes(ctx) {
      $http
        .get(`${API_URI}/rfx-type`)
        .then((res) => {
          const content = res.data;
          ctx.commit('fetchRFxTypes', content);
        });
    },
    fetchProjectSectors(ctx) {
      $http
        .get(`${API_URI}/project-sector`)
        .then((res) => {
          const content = res.data;
          ctx.commit('fetchProjectSectors', content);
        });
    },
    fetchProjectIntakeCategory(ctx) {
      $http
        .get(`${API_URI}/project-intake-category`)
        .then((res) => {
          const content = res.data;
          ctx.commit('fetchProjectIntakeCategory', content);
        });
    },
    fetchProjectIntakeServices(ctx) {
      $http
        .get(`${API_URI}/project-intake-service`)
        .then((res) => {
          const content = res.data;
          ctx.commit('fetchProjectIntakeServices', content);
        });
    },
    // Clients or Government Ministries
    fetchClients(ctx) {
      $http
        .get(`${API_URI}/client`)
        .then((res) => {
          const content = res.data;
          ctx.commit('fetchClients', content);
        });
    },
    fetchClient(ctx, req) {
      $http
        .get(`${API_URI}/client/${req.id}`)
        .then((res) => {
          const content = res.data;
          ctx.commit('fetchClient', content);
        });
    },
    addClient(ctx, req) {
      const body = req;
      $http
        .post(`${API_URI}/client`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('addClient', content);
        });
    },
    updateClient(ctx, req) {
      const body = req;
      $http
        .patch(`${API_URI}/client/${req.id}`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('updateClient', content);
        });
    },
    deleteClient(ctx, req) {
      $http
        .delete(`${API_URI}/client/${req.id}`)
        .then((res) => {
          const content = res.data;
          ctx.commit('updateClient', content);
        });
    },
    // User contacts
    addContact(ctx, req) {
      const body = req;
      $http
        .post(`${API_URI}/contact`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('addContact', content);
        });
    },
    updateContact(ctx, req) {
      const body = req;
      $http
        .patch(`${API_URI}/contact/${req.id}`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('updateContact', content);
        });
    },
    updateContactPartial(ctx, req) {
      const body = req;
      return $http
        .patch(`${API_URI}/contact/${req.id}/partial`, body)
    },
    deleteContact(ctx, req) {
      $http
        .delete(`${API_URI}/contact/${req.id}`)
        .then((res) => {
          const content = res.data;
          ctx.commit('deleteContact', content);
        });
    },
    // User profiles
    fetchUsers(ctx) {
      $http
        .get(`${API_URI}/user`)
        .then((res) => {
          const content = res.data;
          ctx.commit('fetchUsers', content);
        });
    },
    addUser(ctx, req) {
      const body = req;
      $http
        .post(`${API_URI}/user`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('addUser', content);
        });
    },
    updateUser(ctx, req) {
      const body = req;
      $http
        .patch(`${API_URI}/user/${req.id}`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('updateUser', content);
        });
    },
    deleteUser(ctx, req) {
      $http
        .delete(`${API_URI}/user/${req.id}`)
        .then((res) => {
          const content = res.data;
          ctx.commit('deleteUser', content);
        });
    },
    fetchMOUs(ctx, req) {
      $http
        .get(`${API_URI}/MOU`)
        .then((res) => {
          // console.log('fetch MOUs', res);
          const content = res.data;
          ctx.commit('fetchMOUs', content);
        })
    },
    async createMOU(ctx, req) {
      const body = req;
      const api = await $http
        .post(`${API_URI}/MOU`, body)
        .then((res) => {
          const content = res.data;
          console.log('createMOU called with body', body);
          ctx.commit('createMOU', content);
          return Promise.resolve(content);
        })
        .catch(err => Promise.reject(err));
      return Promise.resolve(api);
    },
    // Intake requests
    fetchIntakeRequests(ctx) {
      $http
        .get(`${API_URI}/intake`)
        .then((res) => {
          const content = res.data;
          content.forEach((contentdata) => {
            contentdata.projectLeadId = contentdata.leadUserId;

            contentdata.projectBackupId = contentdata.backupUserId;

            contentdata.estimatedCompletionDate = moment(String(contentdata.estimatedCompletionDate)).format('YYYY-MM-DD');
          });
          ctx.commit('fetchIntakeRequests', content);
        });
    },
    fetchIntakeRequest(ctx, req) {
      // TODO: Make sure it's the right kind of ID - eg. numeric or GUID/UUID
      $http
        .get(`${API_URI}/intake/${req.id}`)
        .then((res) => {
          const content = res.data;
          ctx.commit('fetchIntakeRequest', content);
        });
    },
    clearActiveIntakeRequest(ctx) {
      ctx.commit('clearActiveIntakeRequest', new IntakeRequestDto());
    },
    async addIntakeRequest(ctx, req) {
      const body = req;
      const api = await $http
        .post(`${API_URI}/intake`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('addIntakeRequest', content);
          return Promise.resolve(content);
        })
        .catch(err => Promise.reject(err));
      return Promise.resolve(api);
    },
    async updateIntakeRequest(ctx, req) {
      const api = $http
        .patch(`${API_URI}/intake/${req.id}`, req)
        .then((res) => {
          const content = res.data;
          ctx.commit('updateIntakeRequest', content);
          return Promise.resolve(content);
        })
        .catch(err => Promise.reject(err));
      return Promise.resolve(api);
    },
    async updateProctLog(ctx, req) {
      console.log(req);
      const api = $http
        .patch(`${API_URI}/procurement/${req.id}`, req)
        .then((res) => {
          const content = res.data;
          ctx.commit('updateProctLog', content);
          return Promise.resolve(content);
        })
        .catch(err => Promise.reject(err));
      return Promise.resolve(api);
    },
    async deleteIntakeRequest(ctx, req) {
      try {
        const res = await $http.delete(`${API_URI}/intake/${req.id}`);
        const content = res.data;
        ctx.commit('deleteIntakeRequest', content);
      } catch (err) {
        throw err;
      }
    },
    async approveIntakeRequest(ctx, req) {
      const api = await $http
        .post(`${API_URI}/intake/${req.id}/approve`)
        .then((res) => {
          const content = res.data;
          return Promise.resolve(content);
        })
        .catch(err => Promise.reject(err));
      return Promise.resolve(api);
    },
    assignContactToIntakeRequest(ctx, req) {
      $http
        .post(`${API_URI}/intake/${req.id}/assign-contact`)
        .then((res) => {
          const content = res.data;
          ctx.commit('assignContactToIntakeRequest', content);
        });
    },
    // Projects
    fetchProjects(ctx) {
      $http
        .get(`${API_URI}/project`)
        .then((res) => {
          let content = res.data;
          content = res.data.map(project => project);
          ctx.commit('fetchProjects', content);
        });
    },
    fetchArchivedProjects(ctx) {
      $http
        .get(`${API_URI}/project/archived`)
        .then((res) => {
          let content = res.data;
          content = res.data.map(project => project);
          ctx.commit('fetchArchivedProjects', content);
        });
    },
    archiveProject(ctx, { id, is_archived }) {
      if (!(is_archived === true || is_archived === false)) {
        throw new Error(`is_archived must be boolean, instead you provided: ${typeof is_archived}`)
      }

      return $http
        .patch(`${API_URI}/project/${id}/archive`, { is_archived })
        .then((res) => {
          const content = res.data;
          ctx.commit('archiveProject', content);
        })
    },
    fetchProject(ctx, req) {
      // TODO: Make sure it's the right kind of ID - eg. numeric or GUID/UUID
      $http
        .get(`${API_URI}/project/${req.id}`)
        .then((res) => {
          const content = res.data;
          ctx.commit('fetchProject', content);
        });
    },
    addProject(ctx, req) {
      const body = req;
      $http
        .post(`${API_URI}/project`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('addProject', content);
        });
    },
    async updateProject(ctx, req) {
      const body = req;
      const api = await $http
        .patch(`${API_URI}/project/${req.id}`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('updateProject', content);
          return Promise.resolve(content);
        })
        .catch(err => Promise.reject(err));
      return Promise.resolve(api);
    },
    deleteProject(ctx, req) {
      $http
        .delete(`${API_URI}/project/${req.id}`)
        .then((res) => {
          const content = res.data;
          ctx.commit('deleteProject', content);
        });
    },
    assignResourceToProject(ctx, req) {
      $http
        .post(`${API_URI}/project/${req.id}/assign-resource`)
        .then((res) => {
          const content = res.data;
          ctx.commit('deleteProject', content);
        });
    },
    assignContactToProject(ctx, req) {
      $http
        .post(`${API_URI}/project/${req.id}/assign-contact`)
        .then((res) => {
          const content = res.data;
          ctx.commit('assignContactToProject', content);
        });
    },
    async assignProjectLead(ctx, req) {
      const body = {
        userId: req.userId,
      };
      const api = await $http
        .post(`${API_URI}/project/${req.projectId}/assign-lead`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('assignProjectLead', content);
          return Promise.resolve(content);
        })
        .catch(err => Promise.reject(err));
      return Promise.resolve(api);
    },
    async assignProjectBackup(ctx, req) {
      const body = {
        userId: req.userId,
      };
      const api = await $http
        .post(`${API_URI}/project/${req.projectId}/assign-backup`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('assignProjectBackup', content);
          return Promise.resolve(content);
        })
        .catch(err => Promise.reject(err));
      return Promise.resolve(api);
    },
    // Project Contacts Requests
    fetchProjectContacts(ctx, req) {
      // TODO: Make sure it's the right kind of ID - eg. numeric or GUID/UUID
      $http.get(`${API_URI}/contact/${req.id}/by-project-id`)
        .then((res) => {
          const content = res.data;
          ctx.commit('fetchProjectContacts', content);
        });
    },
    updateProjectContacts(ctx, req) {
      const body = req.contacts;
      $http
        .patch(`${API_URI}/contact/${req.id}`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('updateProjectContacts', content);
        });
    },
    updateProjectFinanceCodes(ctx, req) {
      const body = req.financeCodes;
      $http
        .patch(`${API_URI}/client/${req.id}/finance-code`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('updateProjectFinanceCodes', content);
        });
    },
   async updateProcurementLog(ctx, req) {
      const body = req.procurementlog;
      const api = await $http
        .post(`${API_URI}/procurement`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('updateProcurementLog', content);
          return Promise.resolve(content);
        })
        .catch(err => Promise.reject(err));
      return Promise.resolve(api);
    },
    async addProjectNotes(ctx, req) {
      const body = req.projectNotes;
      const api = await $http
        .post(`${API_URI}/projectnotes`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('addProjectNotes', content);
          return Promise.resolve(content);
        })
        .catch(err => Promise.reject(err));
      return Promise.resolve(api);
    },
    // Project RFx Requests
    fetchProjectRFxData(ctx, req) {
      // TODO: Make sure it's the right kind of ID - eg. numeric or GUID/UUID
      $http.get(`${API_URI}/project-rfx/${req.id}/by-project-id`)
        .then((res) => {
          const content = res.data;
          ctx.commit('fetchProjectRFxData', content);
        });
    },
    addProjectRFxData(ctx, req) {
      const body = req;
      const api = $http.post(`${API_URI}/project-rfx`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('addProjectRFxData', content);
          return Promise.resolve(res.data);
        });
      return Promise.resolve(api);
    },
    updateProjectRFxData(ctx, req) {
      const body = req;
      $http
        .patch(`${API_URI}/project-rfx/${req.id}`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('updateProjectRFxData', content);
        });
    },
    // Timesheets
    async fetchTimesheets(ctx, req) {
      const startDateString = sessionStorage.getItem('selectedStartDate');
      const endDateString = sessionStorage.getItem('selectedEndDate');

      const query = `projectId=${req.projectId}&startDate=${startDateString}&endDate=${endDateString}`;
      req.replace = req.replace || false;

      const res = await $http.get(`${API_URI}/timesheet?${query}`);
      ctx.commit('fetchTimesheets', { data: res.data, replace: req.replace });

      return Promise.resolve();
    },
    async fetchAllTimesheets(ctx) {
      const res = await $http.get(`${API_URI}/timesheet/all`)
      ctx.commit('fetchAllTimesheets', res.data);
      return Promise.resolve(res.data);
    },
    async fetchAllProcurementLog(ctx, req) {
      const res = await $http.get(`${API_URI}/procurement/${req.id}`)
      ctx.commit('fetchAllProcurementLog', res.data);
      return Promise.resolve(res.data);
    },
    async fetchAllProjectNotes(ctx, req) {
      const res = await $http.get(`${API_URI}/projectnotes/${req.id}`)
      ctx.commit('fetchAllProjectNotes', res.data);
      return Promise.resolve(res.data);
    },
    async updateRiskAnalysis(ctx, req) {
      const body = req.risk;
      const api = await $http
        .patch(`${API_URI}/project-risk/${req.projectId}/update`, body)
        .then(res => {
          const content = res.data;
          return Promise.resolve(content);
        })
        .catch(err => Promise.reject(err.response));
      return Promise.resolve(api);
    },
  async addBatchTimesheet(ctx, req) {
      const body = req;

      const api = await $http
        .post(`${API_URI}/timesheet/batch`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('addTimesheet', content);
          ctx.commit('setTimesheetsWeek', { startDate: content.startDate, endDate: content.endDate });
          return Promise.resolve(content);
        })
        .catch(err => Promise.reject(err.response));
      return Promise.resolve(api);
    },
    async addLightTimesheet(ctx, req) {
      const body = req;

      const api = await $http
        .post(`${API_URI}/timesheet/light`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('addTimesheet', content);
          ctx.commit('setTimesheetsWeek', { startDate: content.startDate, endDate: content.endDate });
          return Promise.resolve(content);
        })
        .catch(err => Promise.reject(err.response));
      return Promise.resolve(api);
    },
    async getLightTimesheet(ctx, req) {
      const body = req;

      const api = await $http
        .post(`${API_URI}/timesheet/getLight`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('getTimeLogOfSelectedDate', content);
          return Promise.resolve(content);
        })
        .catch(err => Promise.reject(err.response));
      return Promise.resolve(api);
    },

    async addTimesheet(ctx, req) {
      const body = req;

      const api = await $http
        .post(`${API_URI}/timesheet`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('addTimesheet', content);
          return Promise.resolve(content);
        })
        .catch(err => Promise.reject(err.response));
      return Promise.resolve(api);
    },
    async updateTimesheet(ctx, req) {
      const body = req.payload;
      const api = await $http
        .patch(`${API_URI}/timesheet/${req.id}`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('updateTimesheet', content);
          return Promise.resolve(content);
        })
        .catch(err => Promise.reject(err.response));
      return Promise.resolve(api);
    },
    async deleteTimesheet(ctx, req) {
      const api = await $http
        .delete(`${API_URI}/timesheet/${req.id}`)
        .then((res) => {
          const content = res.data;
          ctx.commit('deleteTimesheet', { timesheetId: req.id, content: res.data });
          return Promise.resolve(content);
        })
        .catch(err => Promise.reject(err.response));
      return Promise.resolve(api);
    },

    async addTimesheetEntry(ctx, req) {
      const body = req;

      try {
        const res = await $http.post(`${API_URI}/timesheet-entry`, body);
        ctx.commit('addTimesheetEntry', res.data);
      } catch (err) {
        return err;
      }

      return Promise.resolve();
    },

    addWeekTimesheetEntries(ctx, req) {
      const body = req;

      $http
        .post(`${API_URI}/timesheet`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('addWeekTimesheetEntries', content);
        });
    },

    updateTimesheetEntry(ctx, req) {
      const body = req;

      $http
        .patch(`${API_URI}/timesheet-entry/${req.id}`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('updateTimesheetEntry', content);
        });
    },

    updateWeekTimesheetEntries(ctx, req) {
      const body = req;

      $http
        .patch(`${API_URI}/timesheet/${req.id}`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('updateWeekTimesheetEntries', content);
        });
    },
    deleteTimesheetEntry(ctx, req) {
      $http
        .delete(`${API_URI}/timesheet-entry/${req.id}`)
        .then((res) => {
          const content = res.data;
          ctx.commit('deleteTimesheetEntry', content);
        });
    },
    deleteWeekTimesheetEntries(ctx, req) {
      $http
        .delete(`${API_URI}/timesheet/${req.id}`)
        .then((res) => {
          const content = res.data;
          ctx.commit('deleteWeekTimesheetEntries', content);
        });
    },
    approveTimesheetEntry(ctx, req) {
      $http
        .post(`${API_URI}/timesheet-entry/${req.id}/approve`)
        .then((res) => {
          const content = res.data;
          ctx.commit('approveTimesheetEntry', content);
        });
    },
    approveWeekTimesheetEntries(ctx, req) {
      $http
        .post(`${API_URI}/timesheet/${req.id}`)
        .then((res) => {
          const content = res.data;
          ctx.commit('approveWeekTimesheetEntries', content);
        });
    },

    addTimesheetEntryComment(ctx, req) {
      const body = req;

      $http
        .post(`${API_URI}/timesheet-entry/${req.id}/comment`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('addTimesheetEntryComment', content);
        });
    },
    updateTimesheetEntryComment(ctx, req) {
      const body = req;

      $http
        .patch(`${API_URI}/timesheet-entry/${req.id}/comment`, body)
        .then((res) => {
          const content = res.data;
          ctx.commit('updateTimesheetEntryComment', content);
        });
    },
    deleteTimesheetEntryComment(ctx, req) {
      $http
        .delete(`${API_URI}/timesheet-entry/${req.id}/comment`)
        .then((res) => {
          const content = res.data;
          ctx.commit('deleteTimesheetEntryComment', content);
        });
    },
  },
  getters: {
    getProjectContactByType: state => contactType => state.activeProjectContacts.find(data => (data.contactType === contactType)),
  },
});

export default store;
