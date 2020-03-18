import { getRepository, Repository } from 'typeorm';
import { Timesheet } from './../../models/entities/timesheet.entity';
import { ITimesheet } from '../../models/interfaces/i-timesheet';

const timesheetRepo = (): Repository<Timesheet> => {
  return getRepository(Timesheet);
};

export const createTimesheet = async (obj: ITimesheet) => {
  const timesheet: Timesheet = timesheetRepo().create(obj);
  timesheet.dateCreated = new Date();
  timesheet.dateModified = new Date();
  await timesheetRepo().save(timesheet);
  return timesheet;
};

export const updateTimesheet = async (id: string, fields: any) => {
  const repo = timesheetRepo();
  const timesheet: Timesheet = await repo.findOne(id);

  if (!timesheet) {
    throw Error('timesheet not found');
  }
  const updatedTimesheet = await repo.merge(timesheet, fields);
  updatedTimesheet.dateModified = new Date();

  await repo.save(updatedTimesheet);
  return updatedTimesheet;
};

export const deleteTimesheet = async (id: string) => {
  const repo = timesheetRepo();

  const timesheet = await repo.findOne(id);

  if (!timesheet) {
    throw Error('timesheet not found');
  }
  return await repo.delete(timesheet);
};

export const retrieveTimesheetById = async (id: string) => {
  const repo = timesheetRepo();
  const res = await repo
    .createQueryBuilder('t')
    .innerJoinAndSelect('t.projectRfx', 'pr')
    .innerJoinAndSelect('t.project', 'p')
    .innerJoinAndSelect('t.mou', 'm')
    .leftJoinAndSelect('t.timesheetEntries', 'te')
    .where('t.id = :id', { id: id })
    .getOne();
  if (!res) {
    throw Error(`timesheet not found for the id specified: ${id}`);
  }
  return res;
};

export const retrieveForLightTimesheet = async model => {
  const repo = timesheetRepo();
  const res = await repo
    .createQueryBuilder('t')
    .leftJoinAndSelect('t.timesheetEntries', 'te')
    .where(
      't."mouId" = :mouId AND ' +
        't."projectId" = :projectId AND' +
        ' t."projectRfxId" = :projectRfxId AND' +
        ' t."userId" = :userId AND' +
        ' t."startDate" <= :entryDate AND t."endDate" >= :entryDate',
      {
        mouId: model.mou,
        projectId: model.project,
        projectRfxId: model.projectRfx,
        userId: model.userId,
        entryDate: model.startDate
      }
    )
    .getOne();
  return res;
};

export const retrieveForLightTimesheetPreview = async (
  projectId: string,
  projectRfxId: string,
  userId: string,
  entryDate: Date
) => {
  const repo = timesheetRepo();
  const res = await repo
    .createQueryBuilder('t')
    .leftJoinAndSelect('t.timesheetEntries', 'te')
    .where(
      't."projectId" = :projectId AND' +
        ' t."projectRfxId" = :projectRfxId AND' +
        ' t."rfxPhaseId" = :rfxPhaseId AND' +
        ' t."userId" = :userId AND' +
        ' t."startDate" <= :entryDate AND t."endDate" >= :entryDate',
      {
        projectId: projectId,
        projectRfxId: projectRfxId,
        userId: userId,
        entryDate: entryDate
      }
    )
    .getMany();
  return res;
};

export const retrieveTimesheets = async (
  projectId: string,
  startDate: Date,
  endDate: Date
) => {
  const repo = timesheetRepo();

  return await repo
    .createQueryBuilder('t')
    .innerJoinAndSelect('t.projectRfx', 'pr')
    .innerJoinAndSelect('t.project', 'p')
    .innerJoinAndSelect('t.rfxPhase', 'rp')
    .leftJoinAndSelect('t.timesheetEntries', 'te')
    .where(
      't."projectId" = :projectId AND t."startDate" >= :startDate AND t."endDate" <= :endDate',
      { projectId: projectId, startDate: startDate, endDate: endDate }
    )
    .getMany();
};
