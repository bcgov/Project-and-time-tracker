import { Repository, getRepository } from 'typeorm';
import { ProjectIntakeCategory } from '../../models/entities/project_Intake_Category.entity';

const projectIntakeCategoryRepo = (): Repository<ProjectIntakeCategory> => {
    return getRepository(ProjectIntakeCategory);
  };
  
export const  retrieveProjectIntakeCategory = async () => {
  const repo = projectIntakeCategoryRepo();
  return await repo.find();
};

export const retrieveProjectIntakeCategoryById = async (id: string) => {
  const repo = projectIntakeCategoryRepo();
  const res = await repo.findOne(id);
  if (!res) {
    throw Error(`projectIntakeCategory not found for the id specified: ${id}`);
  }
  return res;
};
