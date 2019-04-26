// @flow
import BaseDto from '../abstract/Base.dto';

export default class ContactDto extends BaseDto {
  static constructFromObject(data, obj) {
    if (data) {
      obj = obj || new ContactDto();
      BaseDto.setProperties(data, obj);
    }

    return obj;
  }


  id = '';

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
