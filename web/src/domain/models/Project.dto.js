// @flow
import BaseDto from '../abstract/Base.dto';

export default class ProjectDto extends BaseDto {
  static constructFromObject(data, obj) {
    if (data) {
      obj = obj || new ProjectDto();
      BaseDto.setProperties(data, obj);
    }

    return obj;
  }

  id = '';

  projectName = '';
}
