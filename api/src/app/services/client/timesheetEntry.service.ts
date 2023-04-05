import { getRepository, Repository } from 'typeorm';
import { TimesheetEntry } from './../../models/entities/timesheetEntry.entity';
import { ITimesheetEntry } from '../../models/interfaces/i-timesheet-entry';
import { Timesheet } from './../../models/entities/timesheet.entity';
import connection from '../../database/database.connection';

const timesheetEntryRepo = (): Repository<TimesheetEntry> => {
  return getRepository(TimesheetEntry);
};

const timesheetRepo = (): Repository<Timesheet> => {
  return getRepository(Timesheet);
};

export const createTimesheetEntry = async (
  obj: ITimesheetEntry | ITimesheetEntry[]
) => {
  if (Array.isArray(obj)) {
    const arr: any = [];
    const queryRunner = (await connection).createQueryRunner();
    const saveDate = new Date();
    queryRunner.startTransaction();
    try{
      for (let index = 0; index < obj.length; index++) {
        const timesheetEntry: TimesheetEntry = timesheetEntryRepo().create(obj[index]);
        timesheetEntry.dateCreated = saveDate;
        timesheetEntry.dateModified = saveDate;
        await queryRunner.manager.save(timesheetEntry);
      }
    }catch(err){
      console.log(err);
      console.log("Rolling back transaction");
      await queryRunner.rollbackTransaction();
      throw(err);
    }finally{
      await queryRunner.release();
    }
    return arr;
  }
  const timesheetEntry: TimesheetEntry = timesheetEntryRepo().create(obj);
  timesheetEntry.dateCreated = new Date();
  timesheetEntry.dateModified = new Date();
  await timesheetEntryRepo().save(timesheetEntry);
  return timesheetEntry;
};

export const updateTimesheetEntry = async (id: string, fields: any) => {
  const repo = timesheetEntryRepo();
  const timesheetEntry: TimesheetEntry = await repo.findOne(id);

  if (!timesheetEntry) {
    throw Error('timesheetEntry not found');
  }
  const updatedTimesheetEntry = await repo.merge(timesheetEntry, fields);
  updatedTimesheetEntry.dateModified = new Date();

  await repo.save(updatedTimesheetEntry);
  return updatedTimesheetEntry;
};

export const deleteEntryByTimesheetId = async (id: string) => {
  const repo = timesheetEntryRepo();

  const timesheetRep = timesheetRepo();
  const timesheet = await timesheetRep.findOne(id);
  if (!timesheet || timesheet.documentNo != null) {
    throw Error('timesheet not found');
  }

  return await repo.delete({ timesheet: { id: id } });
};

export const retrieveTimesheetEntryById = async (id: string | string[]) => {
  const repo = timesheetEntryRepo();
  if (Array.isArray(id)) {
    const arr: any = [];
    for (let index = 0; index < id.length; index++) {
      arr.push(await retrieveTimesheetEntryById(id[index]));
    }
    return arr;
  }
  const res = await repo.findOne(id);
  if (!res) {
    throw Error(`timesheetEntry not found for the id specified: ${id}`);
  }
  return res;
};

export const retrieveTimesheetEntries = async () => {
  const repo = timesheetEntryRepo();
  return await repo.find();
};

export const retrieveTimesheetEntriesForUser = async (
  userId: string,
  startDate: Date,
  endDate: Date
) => {
  const repo = timesheetEntryRepo();
  return await repo
    .createQueryBuilder('t')
    .where(
      't."userId" = :userId AND :startDate <= t."entryDate" AND :endDate >= t."entryDate"',
      { userId: userId, startDate: startDate, endDate: endDate }
    )
    .getMany();
};
