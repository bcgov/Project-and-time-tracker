import { getRepository, Repository } from 'typeorm';
import { Timesheet } from './../../models/entities/timesheet.entity';
import { ITimesheet } from '../../models/interfaces/i-timesheet';
import { User, Contact } from '../../models/entities';

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

  if (!timesheet || timesheet.documentNo != null) {
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
    .innerJoinAndSelect('t.timesheetEntries', 'te')
    .where('t.id = :id', { id: id })
    .orderBy('te.entryDate', 'ASC')
    .getOne();
  if (!res) {
    throw Error(`timesheet not found for the id specified: ${id}`);
  }
  return res;
};

export const retrieveAllTimesheets = async () => {
  const repo = timesheetRepo();
  return await repo
    .createQueryBuilder('t')
    .innerJoinAndSelect('t.project', 'p')
    .leftJoinAndSelect('t.user', 'u')
    .leftJoinAndSelect('u.contact', 'c')
    .innerJoin('t.timesheetEntries', 'te')
    .innerJoin('t.projectRfx', 'pr')
    .orderBy('t.startDate', 'DESC')
    .getMany();
};

export const retrieveAllTimesheetsFromDate = async (date) => {
  const repo = timesheetRepo();
  return await repo
    .createQueryBuilder('t')
    .innerJoinAndSelect('t.project', 'p')
    .leftJoinAndSelect('t.user', 'u')
    .leftJoinAndSelect('u.contact', 'c')
    .innerJoin('t.timesheetEntries', 'te')
    .innerJoin('t.projectRfx', 'pr')
    .orderBy('t.startDate', 'DESC')
    .where(' t."startDate" > :date', {
      date,
    })
    .getMany();
};
export const retrieveAllTimesheetsByWeek = async (startOfWeek) => {
  const repo = timesheetRepo();
  return await repo
    .createQueryBuilder('t')
    .innerJoinAndSelect('t.project', 'p')
    .leftJoinAndSelect('t.user', 'u')
    .leftJoinAndSelect('u.contact', 'c')
    .innerJoin('t.timesheetEntries', 'te')
    .innerJoin('t.projectRfx', 'pr')
    .orderBy('t.startDate', 'DESC')
    .where(' t."startDate" = :startOfWeek', {
      startOfWeek,
    })
    .getMany();
};
export const retrieveMyTimesheets = async (userId) => {
  const repo = timesheetRepo();
  return await repo
    .createQueryBuilder('t')
    .innerJoin('t.projectRfx', 'pr')
    .innerJoinAndSelect('t.project', 'p')
    .leftJoinAndSelect('t.user', 'u')
    .leftJoinAndSelect('u.contact', 'c')
    .innerJoin('t.timesheetEntries', 'te')
    .orderBy('t.dateModified', 'DESC')
    .where('t.userId = :userId', {
      userId,
    })
    .getMany();
};
export const retrieveForLightTimesheet = async (model) => {
  const repo = timesheetRepo();
  const res = await repo
    .createQueryBuilder('t')
    .innerJoinAndSelect('t.timesheetEntries', 'te')
    .orderBy('te.entryDate', 'ASC')
    .where(
      // 't."mouId" = :mouId AND ' +
      't."projectId" = :projectId AND' +
        ' t."projectRfxId" = :projectRfxId AND' +
        ' t."userId" = :userId AND' +
        ' t."startDate" = :entryDate AND t."endDate" >= :entryDate',
      {
        // mouId: model.mou,
        projectId: model.project,
        projectRfxId: model.projectRfx,
        userId: model.userId,
        entryDate: model.startDate,
      }
    )
    .getOne();
  return res;
};
export const retrieveForLightTimesheetByUser = async (model) => {
  const repo = timesheetRepo();
  console.log('model', model);
  const res = await repo
    .createQueryBuilder('t')
    .innerJoinAndSelect('t.projectRfx', 'pr')
    .innerJoinAndSelect('t.timesheetEntries', 'te')
    .innerJoinAndSelect('t.project', 'p')
    .orderBy('te.entryDate', 'ASC')
    .where(
      ' t."userId" = :userId AND' +
      ' t."startDate" >= :startDate AND t."endDate" <= :endDate',
      {
      userId: model.userId,
      startDate: model.startDate,
      endDate: model.endDate,
    })
    .getMany();
  return res;
};
export const retrieveTimesheetByUserAndDate = async (model) => {
  const repo = timesheetRepo();
  const res = await repo
    .createQueryBuilder('t')
    .innerJoinAndSelect('t.timesheetEntries', 'te')
    .innerJoinAndSelect('t.project', 'p')
    .innerJoinAndSelect('t.mou', 'm')
    .innerJoinAndSelect('t.projectRfx', 'pr')
    .orderBy('te.entryDate, te.dateCreated', 'ASC')
    .where(
      ' t."userId" = :userId AND' +
        ' t."startDate" = :entryDate AND t."endDate" >= :entryDate',
      {
        userId: model.userId,
        entryDate: model.startDate,
      }
    )
    .getMany();
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
    .innerJoinAndSelect('t.timesheetEntries', 'te')
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
        entryDate: entryDate,
      }
    )
    .getMany();
  return res;
};

export const retrieveTimesheets = async (
  projectId?: string,
  startDate?: Date,
  endDate?: Date
) => {
  const repo = timesheetRepo();

  let ret = await repo
    .createQueryBuilder('t')
    .innerJoinAndSelect('t.projectRfx', 'pr')
    .innerJoinAndSelect('t.project', 'p')
    .innerJoinAndSelect('t.rfxPhase', 'rp')
    .innerJoinAndSelect('t.timesheetEntries', 'te')
    .orderBy('te.entryDate', 'ASC');
  // .where(
  //   't."projectId" = :projectId AND t."startDate" >= :startDate AND t."endDate" <= :endDate',
  //   { projectId: projectId, startDate: startDate, endDate: endDate }
  // )
  // .getMany();

  // Only use query params if provided, otherwise return all items
  if (projectId && startDate && endDate) {
    ret = ret.where(
      't."projectId" = :projectId AND t."startDate" >= :startDate AND t."endDate" <= :endDate',
      { projectId: projectId, startDate: startDate, endDate: endDate }
    );
  }

  return ret.getMany();
};
