/* eslint-disable */

class StringHelper {
  static capitalizeFirstLetter = str => str.charAt(0).toUpperCase() + str.slice(1);

  static hyphenize = str => str.replace(/[A-Z]/g, str => `-${str.toLowerCase()}`);

  static underscore = str => str.replace(/[A-Z]/g, str => `_${str.toLowerCase()}`);

  static camelize = str => str.replace(/[\s\-_]+(\w)/g, str => str.toUpperCase().replace(/[\s\-_]+/, ''));

  static swapSubstrings = (str, sub1, sub2) => {
    str = str.replace(new RegExp(`(${sub1}|${sub2})`, 'g'), match => (match === sub1 ? sub2 : sub1));

    return str;
  };

  static escapeRegExp = str => str.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, '\\$1');

  static shortenText = (str, maxLength) => {
    maxLength = maxLength || str.length;
    const trimmed = str.substr(0, maxLength);
    return trimmed.substr(0, Math.min(trimmed.length, trimmed.lastIndexOf(' ')));
  };

  static toSentenceCase = text => text.replace(/\w\S*/g, txt => txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase());

  static quoteIfNecessary = (text) => {
    if (text.indexOf(' ') !== -1) {
      text = `'${text}'`;
    }
    return text;
  };

  static unquoteIfNecessary = (text) => {
    if (
      (text[0] === "'" && text[text.length - 1] === "'")
      || (text[0] === '"' && text[text.length - 1] === '"')
    ) {
      text = text.slice(1, text.length - 1);
    }
    return text;
  };

  static decodeHtmlEntities(str) {
    const element = document.createElement('div');

    const decode = (str) => {
      if (str && typeof str === 'string') {
        // Strip script/html tags
        str = str.replace(/<script[^>]*>([\S\s]*?)<\/script>/gim, '');
        str = str.replace(/<\/?\w(?:[^"'>]|"[^"]*"|'[^']*')*>/gim, '');
        element.innerHTML = str;
        str = element.textContent;
        element.textContent = '';
      }

      return str;
    };

    return decode(str);
  }

  static stringIsInteger(str) {
    if (typeof str === 'undefined' || str === null) {
      return false;
    }

    const n = Math.floor(Number(str));
    return String(n) === str && n >= 0;
  }
}

export default StringHelper;
