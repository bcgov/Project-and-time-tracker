/* eslint-disable */
import Vue from 'vue';
import inflector from 'i';

//const storage = window.sessionStorage;
const helper = {};

/**
 * string processor
 */
helper.i = inflector();

/**
 * sessionStorage
 */
helper.ls = {
  set(key, value) {
    value = JSON.stringify(value);
    window.sessionStorage.setItem(key, value); // Use localStorage or sessionStorage
  },
  get(key, defaultValue) {
    let value = window.sessionStorage.getItem(key); // Corrected to use localStorage
    if (value === null || value === 'undefined' || value === '') {
      value = defaultValue;
    } else {
      value = JSON.parse(value);
    }
    return value;
  },
};
/**
 * a wrapper for helper.ls
 */
helper.store = (key, value) => {
  if (arguments.length < 2) {
    return helper.ls.get(key);
  }
  return helper.ls.set(key, value);
};
Vue.directive('back', (el, binding) => {
  el.onclick = () => window.history.go(-1);
});

export default helper;
