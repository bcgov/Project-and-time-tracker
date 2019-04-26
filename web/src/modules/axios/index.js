import axios from 'axios';
// import store from '@/store';

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


export default instance;
