import { getRepository, Repository } from 'typeorm';
import { ProjectIntake } from '../../models/entities/projectIntake.entity';
import { IProjectIntake } from '../../models/interfaces/i-project-intake';

const intakeRepo = (): Repository<ProjectIntake> => {
  return getRepository(ProjectIntake);
};

export const retrieveIntakes = async () => {
  const repo = intakeRepo();
  return await repo
    .createQueryBuilder('i')
    .innerJoin('i.client', 'c')
    .leftJoin('c.ministry', 'm')
    .leftJoin('i.mou', 'd')
    .leftJoin('project', 'p', 'p.id = i.projectId')
    .orderBy('i.dateModified', 'DESC')
    .select([
      'i.id AS "id"',
      'i.projectName AS "projectName"',
      'i.estimatedCompletionDate AS "estimatedCompletionDate"',
      'i.status AS "status"',
      'c.orgDivision AS "orgDivision"',
      'm.ministryName AS "ministryName"',
      'i."projectId" AS "projectId"',
      'p."leadUserId" AS "leadUserId"',
      'p."backupUserId" AS "backupUserId"',
      'i.isReprocurement AS "isReprocurement"',
      'i.dateOfReprocurement AS "dateOfReprocurement"',
      'i.previousContractBackground AS "previousContractBackground"',
      'i.projectFailImpact AS "projectFailImpact"',
      'i.projectSuccess AS "projectSuccess"',
      'c.isNonMinistry AS "isNonMinistry"',
      'c.nonMinistryName AS "nonMinistryName"',
      'd.name AS "mouName"',
      'i."mouId" AS "mouId"',
      'i.isMinistry AS "isMinistry"',
      'i.intakeRiskLevel  AS "intakeRiskLevel"'
    ])
    .getRawMany();
};

export const retrieveIntakeById = async (intakeId: string) => {
  const repo = intakeRepo();
  const res = await repo
    .createQueryBuilder('i')
    .innerJoinAndSelect('i.client', 'c')
    .innerJoinAndSelect('i.projectSector', 'ps')
    .leftJoinAndSelect('c.ministry', 'm')
    .leftJoinAndSelect('i.mou', 'mou')
    .where('i.id = :id', { id: intakeId })
    .getOne();
  if (!res) {
    throw Error(`intake not found for the id specified: ${intakeId}`);
  }
  return res;
};

export const createIntake = async (obj: IProjectIntake) => {
  const intake: ProjectIntake = intakeRepo().create(obj);
  intake.dateCreated = new Date();
  intake.dateModified = new Date();
  await intakeRepo().save(intake);
  return intake;
};

export const updateIntake = async (id: string, fields: any) => {
  const repo = intakeRepo();
  const intake: ProjectIntake = await repo.findOne(id);

  if (!intake) {
    throw Error('intake not found');
  }
  const updatedIntake = await repo.merge(intake, fields);
  updatedIntake.dateModified = new Date();

  console.log('\n\nupdateIntake in service', fields);

  await repo.save(updatedIntake);
  return updatedIntake;
};

export const deleteIntake = async (id: string) => {
  const repo = intakeRepo();
  const intake = await repo.findOne(id);

  if (!intake) {
    throw Error('intake not found');
  }
  return await repo.delete(intake);
};
