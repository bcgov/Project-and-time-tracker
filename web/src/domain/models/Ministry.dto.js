// @flow
import BaseDto from '../abstract/Base.dto';

export default class MinistryDto extends BaseDto {
  static constructFromObject(data, obj) {
    if (data) {
      obj = obj || new MinistryDto();
      BaseDto.setProperties(data, obj);
    }

    return obj;
  }

  id = '';

  ministryName = '';
}
