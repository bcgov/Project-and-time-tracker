import Vue from "vue";
import VueQuillEditor from "vue-quill-editor";

import "./registerServiceWorker";
import "roboto-fontface/css/roboto/roboto-fontface.css";
import "@fortawesome/fontawesome-free/css/all.css";
import "material-design-icons-iconfont/dist/material-design-icons.css";
import moment from "moment";
import "./plugins/vuetify";

import App from "./App.vue";
import router from "./router";

import i18n from "@/i18n";
import store from "@/store";

import VForm from "@/modules/widgets/Form.vue";
import VField from "@/modules/widgets/Field.vue";
import VCalendar from "v-calendar";

Vue.use(VCalendar, {
  componentPrefix: "vc" // Use <vc-calendar /> instead of <v-calendar />
  // ...,                // ...other defaults
});

Vue.use(VueQuillEditor);
Vue.filter("formatDate", function(value) {
  if (value) {
    return moment(String(value)).format("MM/DD/YYYY");
  }
});

Vue.filter("withCommas", value => {
  if (!value) return;
  const anyNonNumbers = value.toString().match(/[^\d,.]+/g, "");
  if (anyNonNumbers) {
    return value;
  }
  const stripped = value.toString().replace(/,/g, ""); // Remove commas to get real number, so 1,245 != 1.
  const format = new Intl.NumberFormat().format(stripped);
  // console.log('withCommas', {value, format, stripped})
  return format;
});

Vue.component("v-form", VForm);
Vue.component("v-field", VField);
// Useful for v-selects, this opens them when tabbed into them
Vue.directive("open-on-focus", {
  bind: function(el) {
    el.addEventListener(
      "focus",
      event => {
        event.target.click();
      },
      true
    );
  }
});

Vue.config.productionTip = false;

/* eslint-disable */
const appInstance = new Vue({
  el: "#app",
  i18n,
  store,
  router,
  render: h => h(App),
  mounted() {},
  methods: {
    back() {
      this.$router.go(-1);
    }
  }
});
/* eslint-enable */
