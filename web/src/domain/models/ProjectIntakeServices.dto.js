// @flow
import BaseDto from '../abstract/Base.dto';

export default class ProjectIntakeServicesDto extends BaseDto {
  static constructFromObject(data, obj) {
    if (data) {
      obj = obj || new ProjectIntakeServicesDto();
      BaseDto.setProperties(data, obj);
    }

    return obj;
  }


  id = '';

  ProjectIntakeServiceName = '';
}
