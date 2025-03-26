// @flow
import BaseDto from '../abstract/Base.dto';

import RFxPhaseDto from './RFxPhase.dto';
import RFxTypeDto from './RFxType.dto';

export default class RFxDto extends BaseDto {
  static constructFromObject(data, obj) {
    if (data) {
      obj = obj || new RFxDto();
      BaseDto.setProperties(data, obj);
    }

    return obj;
  }

  id = '';

  rfxType = new RFxTypeDto();

  rfxPhase = new RFxPhaseDto();

  rfxName = '';

  rfxOverview = '';

  clientResponsibilities = '';

  psdResponsibilities = '';
}
