// @flow
import BaseDto from '../abstract/Base.dto';

export default class TimesheetEntryDto extends BaseDto {
  static constructFromObject(data, obj) {
    if (data) {
      obj = obj || new TimesheetEntryDto();
      BaseDto.setProperties(data, obj);
    }

    return obj;
  }

  id = '';

  projectRfxId = '';

  projectId = '';

  rfxPhaseId = '';

  userId = '';

  hoursBilled = '';

  startTime = '';

  endTime = '';

  entryDate = new Date();

  comments = '';
}
