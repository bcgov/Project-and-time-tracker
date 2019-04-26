import HashTable from './HashTable';

/**
 * Object: App.Utilities.HashProxy
 * Type: Hash
 *
 * Proxy wrapper for App.Utilities.HashTable providing a cleaner interface.
 * Uses ES6 Proxy to auto-magically map getters / setters.
 */

function HashProxy(obj, obj2) {
  const obj1 = {
    get: (hashTable, key) => {
      // Ignore non-strings
      if (typeof key !== 'string') {
        return undefined;
      }

      return hashTable.getItem(key);
    },
    set: (hashTable, key, value) => {
      hashTable.setItem(key, value);
      return true;
    },
    apply: (hashTable, context, argumentsList) => hashTable.apply(context, argumentsList),
  };

  return new Proxy(new HashTable(obj), obj1, obj2);
}

export default HashProxy;
