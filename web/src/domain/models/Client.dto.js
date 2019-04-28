// @flow
import BaseDto from '../abstract/Base.dto';

import MinistryDto from './Ministry.dto';

export default class ClientDto extends BaseDto {
  static constructFromObject(data, obj) {
    if (data) {
      obj = obj || new ClientDto();
      BaseDto.setProperties(data, obj);
    }

    return obj;
  }


  id = '';

  clientNo = null;

  responsibilityCenter = null;

  serviceCenter = null;

  stob = null;

  projectCode = null;

  ministry = new MinistryDto();

  orgDivision = '';

  email = '';

  addressLine1 = '';

  addressLine2 = '';

  city = '';

  province = '';

  country = '';

  postalCode = '';

  dateCreated = new Date();

  dateModified = new Date();
}
