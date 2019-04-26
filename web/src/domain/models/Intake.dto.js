// @flow
import BaseDto from '../abstract/Base.dto';

import ClientDto from './Client.dto';
import ProjectSectorDto from './ProjectSector.dto';

export default class IntakeDto extends BaseDto {
  static constructFromObject(data, obj) {
    if (data) {
      obj = obj || new IntakeDto();
      BaseDto.setProperties(data, obj);
    }

    return obj;
  }

  id = null;

  projectName = '';

  client = new ClientDto();

  projectSector = new ProjectSectorDto();

  commodityCode = '';

  estimatedCompletionDate = '';

  estimatedContractValue = null;

  mouAmount = null;

  description = '';

  status = '';

  dateCreated = new Date();

  dateModified = new Date();

  contacts = [];
}
