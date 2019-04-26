export default class BaseDto {
  static setProperties(data, obj) {
    const propertyNames = Object.keys(data);
    propertyNames.forEach((key) => {
      if (Object.prototype.hasOwnProperty.call(data, key)) {
        obj[key] = data[key];
      }
    });
  }
}
