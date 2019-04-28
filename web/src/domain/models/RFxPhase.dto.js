// @flow
import BaseDto from '../abstract/Base.dto';

export default class RFxPhaseDto extends BaseDto {
  static constructFromObject(data, obj) {
    if (data) {
      obj = obj || new RFxPhaseDto();
      BaseDto.setProperties(data, obj);
    }

    return obj;
  }

  id = '';

  rfxPhaseName = '';
}
