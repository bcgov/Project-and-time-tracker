import Vue from 'vue';
import VueQuillEditor from 'vue-quill-editor';

import './registerServiceWorker';
import 'roboto-fontface/css/roboto/roboto-fontface.css';
import '@fortawesome/fontawesome-free/css/all.css';
import 'material-design-icons-iconfont/dist/material-design-icons.css';

import './plugins/vuetify';

import App from './App.vue';
import router from './router';

import i18n from '@/i18n';
import store from '@/store';

import VForm from '@/modules/widgets/Form.vue';
import VField from '@/modules/widgets/Field.vue';
import VueCurrencyInput from 'vue-currency-input'


Vue.use(VueQuillEditor);
Vue.use(VueCurrencyInput, { globalOptions: { currency: 'CAD'}});

Vue.component('v-form', VForm);
Vue.component('v-field', VField);

Vue.config.productionTip = false;

/* eslint-disable */
const appInstance = new Vue({
  el: '#app',
  i18n,
  store,
  router,
  render: h => h(App),
  mounted() {},
  methods: {
    back() {
      this.$router.go(-1);
    },
  },
});
/* eslint-enable */
