/* eslint-disable */
/** ********************************************************
 * Namespace: QC.helpers.Object
 ********************************************************* */
import StringHelper from './String.js';

class ObjectHelper {
  /**
   * Method: App.helpers.Object.isEmpty
   */
  static isEmpty = (obj) => {
    obj = obj || null;

    if (obj === null) return true;

    for (const prop in obj) {
      if (obj.hasOwnProperty(prop) && obj.prop !== null) return false;
    }

    return true;
  };

  static cleanObject(obj) {
    obj = Object.entries(obj)
      .filter(([key, value]) => value !== undefined)
      .reduce((obj, [key, value]) => ((obj[key] = value), obj), {});

    return obj;
  }

  static recursiveFormatKeys = (data, from, to) => {
    const clone = {};
    const modes = ['underscore', 'camelcase', 'hyphenate'];
    if (!(modes.indexOf(from) > -1 || !modes.indexOf(to) > -1)) {
      throw new Error(
        "Cannot normalize data: incorrect mode and currentMode supplied. Valid modes are 'underscore', 'camelcase' and 'hyphenate'.",
      );
    }

    Object.keys(data).reduce((obj, prop) => {
      const val = data[prop];
      const newVal = typeof val === 'object' && val !== null
        ? ObjectHelper.recursiveFormatKeys(val, from, to)
        : val;

      switch (to) {
        case 'underscore':
          obj[StringHelper.underscore(prop)] = newVal;
          break;
        case 'camelcase':
          obj[StringHelper.camelize(prop)] = newVal;
          break;
        case 'hyphenate':
          obj[StringHelper.hyphenize(prop)] = newVal;
          break;
      }
      return obj;
    }, clone);

    return clone;
  };

  static recursiveRenameKeys = (data, mappings) => {
    const clone = {};
    /* let modes = ['underscore', 'camelcase', 'hyphenate']
     if (!(modes.indexOf(from) > -1 || !modes.indexOf(to) > -1)) {
     throw new Error("Cannot normalize data: incorrect mode and currentMode supplied. Valid modes are 'underscore', 'camelcase' and 'hyphenate'.")
     } */

    Object.keys(data).reduce((obj, prop) => {
      const val = data[prop];
      const newVal = typeof val === 'object' && val !== null
        ? ObjectHelper.recursiveFormatKeys(val, mappings)
        : val;

      /* switch (to) {
       case 'underscore':
       obj[StringHelper.underscore(prop)] = newVal
       break
       case 'camelcase':
       obj[StringHelper.camelize(prop)] = newVal
       break
       case 'hyphenate':
       obj[StringHelper.hyphenize(prop)] = newVal
       break
       }
       return obj
       }, clone) */

      return clone;
    });
  };

  static prefixKeys(obj, prefix, dest = {}) {
    return Object.keys(obj).reduce((o, key) => {
      o[`${prefix}${key}`] = obj[key];
      return o;
    }, dest || {});
  }

  /**
   * Quick and dirty way to compare arrays or objects without getting into too much detail.
   * This isn't the fastest solution by any means but it generally works.
   * I don't recommend using this to compare complex structures (it'll be slow).
   */
  static jsonSameMembers = (obj1, obj2) => JSON.stringify(obj1) === JSON.stringify(obj2);

  static generateUUIDv4() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
      const r = (Math.random() * 16) | 0;
      const v = c == 'x' ? r : (r & 0x3) | 0x8;
      return v.toString(16);
    });
  }
}

export default ObjectHelper;
