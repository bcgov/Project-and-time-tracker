import { Repository, getRepository } from 'typeorm';
import { ProjectIntakeServices } from '../../models/entities/project_Intake_Services.entity';

const projectIntakeServicesRepo = (): Repository<ProjectIntakeServices> => {
    return getRepository(ProjectIntakeServices);
  };
  
export const  retrieveProjectIntakeServices = async () => {
  const repo = projectIntakeServicesRepo();
  return await repo.find();
};

export const retrieveProjectIntakeServicesById = async (id: string) => {
  const repo = projectIntakeServicesRepo();
  const res = await repo.findOne(id);
  if (!res) {
    throw Error(`projectIntakeServices not found for the id specified: ${id}`);
  }
  return res;
};
