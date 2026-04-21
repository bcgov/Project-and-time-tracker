import axios from 'axios';
// import store from '@/store';
import Vue from 'vue';

export const backendState = Vue.observable({
  down: false
});

const instance = axios.create();
instance.interceptors.request.use((config) => {
  config.headers.get['Content-Type'] = 'application/json';
  config.headers.post['Content-Type'] = 'application/json';
  config.headers.put['Content-Type'] = 'application/json';
  config.headers.patch['Content-Type'] = 'application/json';
  config.headers.delete['Content-Type'] = 'application/json';
  config.headers.common.Authorization = `Bearer ${sessionStorage.getItem('keycloak_token')}`;
  return config;
});


instance.interceptors.response.use(
  response => response,
  error => {
    if (!error.response || error.response.status >= 500) {
      backendState.down = true;
    }
    return Promise.reject(error);
  }
);


export default instance;
