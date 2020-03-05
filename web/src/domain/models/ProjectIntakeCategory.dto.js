// @flow
import BaseDto from '../abstract/Base.dto';

export default class ProjectIntakeCategoryDto extends BaseDto {
  static constructFromObject(data, obj) {
    if (data) {
      obj = obj || new ProjectIntakeCategoryDto();
      BaseDto.setProperties(data, obj);
    }

    return obj;
  }


  id = '';

  projectIntakeCategoryName = '';
}
