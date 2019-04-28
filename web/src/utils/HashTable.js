/**
 * Object: App.Utilities.HashTable
 * Type: Hash
 *
 * Basic hash table implementation
 */
/* eslint-disable */
export default class HashTable {
  constructor(obj) {
    obj = obj || null;

    this.length = 0;
    this.items = {};

    let p;

    if (obj !== null) {
      for (p in obj) {
        if (obj.hasOwnProperty(p)) {
          this.items[p] = obj[p];
          this.length++;
        }
      }
    }

    return this;
  }

  setItem(key, value) {
    let previous;

    if (this.hasItem(key)) {
      previous = this.items[key];
    } else {
      this.length++;
    }

    this.items[key] = value;
    return previous;
  }

  getItem(key) {
    return this.hasItem(key) ? this.items[key] : undefined;
  }

  hasItem(key) {
    return this.items.hasOwnProperty(key);
  }

  removeItem(key) {
    let previous;

    if (this.hasItem(key)) {
      previous = this.items[key];
      this.length--;
      delete this.items[key];
      return previous;
    }

    return undefined;
  }

  keys() {
    const keys = [];
    let k;

    for (k in this.items) {
      if (this.hasItem(k)) {
        keys.push(k);
      }
    }

    return keys;
  }

  values() {
    const values = [];
    let k;

    for (k in this.items) {
      if (this.hasItem(k)) {
        values.push(this.items[k]);
      }
    }

    return values;
  }

  each(fn) {
    let k;

    for (k in this.items) {
      if (this.hasItem(k)) {
        fn(k, this.items[k]);
      }
    }
  }

  clear() {
    this.items = {};
    this.length = 0;
  }

  // Alias for hasItem
  has(key) {
    return this.hasItem(key);
  }

  // Alias for getItem
  get(key) {
    return this.getItem(key);
  }

  // Chainable alias for setItem
  set(key, value) {
    this.setItem(key, value);
    return this;
  }

  // Chainable alias for removeItem
  remove(key) {
    return this.removeItem(key) !== undefined ? this : false;
  }

  count() {
    return Object.keys(this.items).length;
  }
}
