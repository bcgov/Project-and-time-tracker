// @flow
import BaseDto from '../abstract/Base.dto';

export default class AdditionalContactDto extends BaseDto {
  static constructFromObject(data, obj) {
    if (data) {
      obj = obj || new AdditionalContactDto();
      BaseDto.setProperties(data, obj);
    }

    return obj;
  }


  id = '';

  roleName='';

  contactType = '';

  userId = '';

  fullName = '';

  orgName = '';

  orgPosition = '';

  email = '';

  phoneNumber = '';

  addressLine1 = '';

  addressLine2 = '';

  city = '';

  province = '';

  country = '';

  postalCode = '';

  dateCreated = new Date();

  dateModified = new Date();
}
