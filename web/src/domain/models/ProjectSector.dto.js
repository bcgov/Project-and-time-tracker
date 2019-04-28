// @flow
import BaseDto from '../abstract/Base.dto';

export default class ProjectSectorDto extends BaseDto {
  static constructFromObject(data, obj) {
    if (data) {
      obj = obj || new ProjectSectorDto();
      BaseDto.setProperties(data, obj);
    }

    return obj;
  }


  id = '';

  projectSectorName = '';
}
