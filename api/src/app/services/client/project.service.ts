import { getRepository, Repository } from 'typeorm';
import {
  Project,
  ProjectContacts,
  Contact,
  ProjectRfx,
} from '../../models/entities';
import { Client } from '../../models/entities';
import { IProject } from '../../models/interfaces/i-project';
import { Timesheet } from './../../models/entities/timesheet.entity';
import { TimesheetEntry } from './../../models/entities/timesheetEntry.entity';
import { IClient } from '../../models/interfaces/i-client';
import { type } from 'os';
import { ReplaceSource } from 'webpack-sources';
import { User } from '../../models/entities/user.entity';
import { FinanceExport } from '../../models/entities';
import { IFinanceExport } from '../../models/interfaces/i-finance-export';
import { IFinanceExportDetail } from '../../models/interfaces/i-finance-export-detail';
import {
  IFinanceJSON,
  IUserFinanceCodes,
} from '../../models/interfaces/i-finance-json';

const userRepo = (): Repository<User> => {
  return getRepository(User);
};

const projectRFXRepo = (): Repository<ProjectRfx> => {
  return getRepository(ProjectRfx);
};
const contactRepo = (): Repository<Contact> => {
  return getRepository(Contact);
};
const financeRepo = (): Repository<FinanceExport> => {
  return getRepository(FinanceExport);
};
const timesheetRepo = (): Repository<Timesheet> => {
  return getRepository(Timesheet);
};
const projectRepo = (): Repository<Project> => {
  return getRepository(Project);
};
const projectContactRepo = (): Repository<ProjectContacts> => {
  return getRepository(ProjectContacts);
};

const clientRepo = (): Repository<Client> => {
  return getRepository(Client);
};

export const createProject = async (obj: IProject | IProject[]) => {
  if (Array.isArray(obj)) {
    const arr: any = [];
    for (let index = 0; index < obj.length; index++) {
      arr.push(await createProject(obj[index]));
    }
    return arr;
  }

  const project: Project = projectRepo().create(obj);
  project.dateCreated = new Date();
  project.dateModified = new Date();
  await projectRepo().save(project);
  return project;
};

export const updateProject = async (
  id: string,
  fields: any,
  clientFilds: any = null
) => {
  const repo = projectRepo();
  const project: Project = await repo.findOne(id);

  if (!project) {
    throw Error('project not found');
  }
  const updatedProject = await repo.merge(project, fields);
  updatedProject.dateModified = new Date();

  if (fields.teamWideProject) {
    if (fields.backupUserId === undefined) {
      updatedProject.backupUserId = null;
    }
    if (fields.leadUserId === undefined) {
      updatedProject.leadUserId = null;
    }
  }

  await repo.save(updatedProject);
  if (clientFilds) {
    const repoClient = clientRepo();
    const client: Client = await repoClient.findOne(clientFilds.id);

    if (!client) {
      throw Error('client not found');
    }
    const updatedClient = await repoClient.merge(client, clientFilds);
    updatedClient.dateModified = new Date();

    await repoClient.save(updatedClient);
  }
  return updatedProject;
};

export const deleteProject = async (id: string) => {
  const repo = projectRepo();
  const project = await repo.findOne(id);

  if (!project) {
    throw Error('project not found');
  }
  return await repo.delete(project);
};

export const retrieveProjectById = async (id: string | string[]) => {
  const repo = projectRepo();
  if (Array.isArray(id)) {
    const arr: any = [];
    for (let index = 0; index < id.length; index++) {
      arr.push(await retrieveProjectById(id[index]));
    }
    return arr;
  }
  const res = await repo
    .createQueryBuilder('p')
    .innerJoinAndSelect('p.client', 'c')
    .leftJoinAndSelect('c.ministry', 'm')
    .leftJoinAndSelect('p.mou', 'o')
    .where('p.id = :id', { id: id })
    .getOne();
  if (!res) {
    throw Error(`project not found for the id specified: ${id}`);
  }
  return res;
};

export const retrieveProjects = async () => {
  const repo = projectRepo();
  return await repo
    .createQueryBuilder('p')
    .innerJoin('p.client', 'c')
    .leftJoin('c.ministry', 'm')
    .leftJoinAndSelect('p.mou', 'o')
    .innerJoin('p.projectSector', 'ps')
    .orderBy('p.dateModified', 'DESC')
    .select([
      'p.id',
      'p.projectName',
      'ps',
      'p.dateModified',
      'p.completionDate',
      'c.orgDivision',
      'm.ministryName',
      'p.leadUserId',
      'p.backupUserId',
      'o.name',
      'o.id',
      'p.isReprocurement',
      'c.isNonMinistry',
      'p.dateOfReprocurement',
      'p.previousContractBackground',
      'p.projectFailImpact',
      'p.projectSuccess',
      'p.otherProjectSectorName',
      'c.nonMinistryName',
      'p.mouAmount',
      'p.teamWideProject',
    ])
    .where('p.is_archived IS NULL OR p.is_archived = :is_archived', {
      is_archived: false,
    })
    .getMany();
};

function uuidv4() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
    var r = (Math.random() * 16) | 0,
      v = c == 'x' ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}
function getPDFName(date, count) {
  var month = new Array();
  month[0] = 'Janu';
  month[1] = 'Feb';
  month[2] = 'Mar';
  month[3] = 'Apr';
  month[4] = 'May';
  month[5] = 'Jun';
  month[6] = 'Jul';
  month[7] = 'Aug';
  month[8] = 'Sep';
  month[9] = 'Oct';
  month[10] = 'Nov';
  month[11] = 'Dec';

  var newDate = new Date(date);
  if (count === 1) {
    return (
      month[newDate.getMonth()] +
      ' - ' +
      newDate.getFullYear() +
      ' - ' +
      count.toString() +
      ' Project.pdf'
    );
  }
  return (
    month[newDate.getMonth()] +
    ' - ' +
    newDate.getFullYear() +
    ' - ' +
    count.toString() +
    ' Projects.pdf'
  );
}
function round(x) {
  return Number.parseFloat(Number.parseFloat(x).toFixed(2));
}
async function fillUserFinanceCodes(
  userFinanceCodes,
  financeDetail,
  contactId
) {
  let userItemEntry = userFinanceCodes.find((item) => {
    return item.user === contactId && item.type === financeDetail.type;
  });
  if (userItemEntry) {
    userItemEntry.amount = userItemEntry.amount + financeDetail.amount;
  } else {
    let userFinance = {} as IUserFinanceCodes;

    const repo = contactRepo();
    const contactRes = await repo
      .createQueryBuilder('c')
      .innerJoinAndSelect('c.financeCodes', 'f')
      .where('c."id" = :contactId', {
        contactId: contactId,
      })
      .getOne();
    if (contactRes) {
      userFinance.amount = financeDetail.amount;
      userFinance.clientNo = contactRes.financeCodes.clientNo;
      userFinance.financeName = contactRes.financeCodes.financeName;
      userFinance.projectCode = contactRes.financeCodes.projectCode;
      userFinance.responsibilityCenter =
        contactRes.financeCodes.responsibilityCenter;
      userFinance.serviceCenter = contactRes.financeCodes.serviceCenter;
      userFinance.stob = contactRes.financeCodes.stob;
      userFinance.type = financeDetail.type;
      userFinance.user = contactId;
      userFinanceCodes.push(userFinance);
    }
  }
}
export const retrieveFinanceData = async (obj, userId) => {
  const financeExport = obj.selectedProjects as IFinanceExport[];
  const documentNo: string = uuidv4();

  const selectedDate = obj.selectedDate.split('-');

  const year = parseInt(selectedDate[0], 10);
  const month = parseInt(selectedDate[1], 10);

  const startDate = new Date(year, month - 1, 1);
  const endDate = new Date(year, month, 0);

  const documentPath: string = getPDFName(startDate, financeExport.length);

  for (let index = 0; index < financeExport.length; index++) {
    let model = financeExport[index];
    if (!model) {
      return [];
    }
    let billingCount = 1;
    const exportData = {} as IFinanceJSON;
    exportData.projectId = financeExport[index].projectId;
    const repo = projectRepo();
    const res = await repo
      .createQueryBuilder('p')
      .innerJoin('p.client', 'c')
      .innerJoin('p.mou', 'm')
      .select([
        'p.id',
        'p.projectName',
        'p.leadUserId',
        'p.teamWideProject',
        'c.responsibilityCenter',
        'p.mouAmount',
        'c.clientNo',
        'c.id',
        'c.billingCount',
        'c.stob',
        'c.projectCode',
        'c.serviceCenter',
        'm.name',
      ])
      .where('p.id = :projectId', { projectId: exportData.projectId })
      .getOne();

    exportData.leadUser = '';
    exportData.financeName = '';
    if (res.teamWideProject) {
      exportData.leadUser = 'Procurement and Supply Division';
    } else if (res.leadUserId) {
      const repoUser = userRepo();
      const leadUser = await repoUser
        .createQueryBuilder('u')
        .innerJoinAndSelect('u.contact', 'c')
        .where('u.id = :projectLeadId', { projectLeadId: res.leadUserId })
        .getOne();
      if (leadUser) {
        const repo = contactRepo();
        const contactRes = await repo
          .createQueryBuilder('c')
          .leftJoin('c.financeCodes', 'f')
          .select(['c.fullName', 'f.financeName'])
          .where('c."id" = :contactId', {
            contactId: leadUser.contact.id,
          })
          .getOne();

        if (contactRes) {
          exportData.leadUser = contactRes.fullName;
          if (contactRes.financeCodes)
            exportData.financeName = contactRes.financeCodes.financeName;
        }
      }
    } else {
      exportData.leadUser = 'Procurement and Supply Division';
    }

    // Get previous Bill amount
    const financeRep = financeRepo();

    const prevBills = await financeRep
      .createQueryBuilder('f')
      .select(['f.projectId'])
      .addSelect('SUM(f.totalAmount)', 'sum')
      .where('f.projectId = :projectId  and f.isDischarged != :discharged', {
        projectId: exportData.projectId,
        discharged: true,
      })
      .groupBy('f.projectId ')
      .getRawOne();

    const contactproRepo = projectContactRepo();
    const contactRes = await contactproRepo
      .createQueryBuilder('pc')
      .leftJoinAndSelect('pc.project', 'p')
      .leftJoinAndSelect('pc.contact', 'c')
      .where('c."contactType" = :contactType and pc."projectId" = :projectId', {
        contactType: 'clientfinance',
        projectId: exportData.projectId,
      })
      .getOne();
    exportData.contact = contactRes.contact.fullName;
    exportData.projectName = res.projectName;

    let details = [] as IFinanceExportDetail[];
    let userFinanceCodes = [] as IUserFinanceCodes[];
    let projectFinance = {} as IUserFinanceCodes;
    if (res.client) {
      projectFinance.responsibilityCenter = res.client.responsibilityCenter;
      projectFinance.clientNo = res.client.clientNo;
      projectFinance.stob = res.client.stob;
      projectFinance.projectCode = res.client.projectCode;
      projectFinance.serviceCenter = res.client.serviceCenter;
      billingCount = res.client.billingCount ? res.client.billingCount + 1 : 1;
    }
    projectFinance.type = 'Project';
    userFinanceCodes.push(projectFinance);

    exportData.documentPath = documentPath;
    exportData.documentNo = documentNo;
    exportData.lineDesc = documentNo;
    exportData.createdUserId = userId;
    exportData.billingCount = billingCount;
    exportData.mouName = res.mou.name;
    exportData.mouEstimate = res.mouAmount;
    const timeSheet = await timesheetRepo()
      .createQueryBuilder('t')
      .leftJoinAndSelect('t.timesheetEntries', 'te')
      .innerJoinAndSelect('t.user', 'u')
      .innerJoinAndSelect('u.contact', 'c')
      .where(
        't."projectId" = :projectId and (t.is_locked = :is_locked or t.is_locked IS NULL) and (t.startDate >= :start and t.startDate <= :end)',
        {
          projectId: exportData.projectId,
          is_locked: false,
          start: startDate,
          end: endDate,
        }
      )
      .getMany();
    if (timeSheet.length == 0) {
      continue;
    }

    for (
      let timeSheetIndex = 0;
      timeSheetIndex < timeSheet.length;
      timeSheetIndex++
    ) {
      let timeSheetId = timeSheet[timeSheetIndex].id;
      for (
        let timeSheetEntryIndex = 0;
        timeSheetEntryIndex < timeSheet[timeSheetIndex].timesheetEntries.length;
        timeSheetEntryIndex++
      ) {
        const timesheetEntry: TimesheetEntry[] =
          timeSheet[timeSheetIndex].timesheetEntries;
        if (
          timesheetEntry[timeSheetEntryIndex].hoursBillable &&
          timesheetEntry[timeSheetEntryIndex].hoursBillable > 0
        ) {
          let financeDetailHour = {} as IFinanceExportDetail;
          financeDetailHour.entryDate =
            timesheetEntry[timeSheetEntryIndex].entryDate;
          financeDetailHour.description =
            timesheetEntry[timeSheetEntryIndex].commentsBillable;
          financeDetailHour.hours =
            timesheetEntry[timeSheetEntryIndex].hoursBillable;
          financeDetailHour.type = 'Time';
          financeDetailHour.user = timeSheet[timeSheetIndex].userId;
          financeDetailHour.resource =
            timeSheet[timeSheetIndex].user.contact.fullName;
          financeDetailHour.rate = timeSheet[timeSheetIndex].user.contact
            .hourlyRate
            ? timeSheet[timeSheetIndex].user.contact.hourlyRate
            : 0;
          financeDetailHour.amount = round(
            financeDetailHour.rate * financeDetailHour.hours
          );
          financeDetailHour.id = timeSheetId;
          details.push(financeDetailHour);

          await fillUserFinanceCodes(
            userFinanceCodes,
            financeDetailHour,
            timeSheet[timeSheetIndex].user.contact.id
          );
        }

        if (
          timesheetEntry[timeSheetEntryIndex].expenseAmount &&
          timesheetEntry[timeSheetEntryIndex].expenseAmount > 0
        ) {
          let financeDetailExpense = {} as IFinanceExportDetail;
          financeDetailExpense.entryDate =
            timesheetEntry[timeSheetEntryIndex].entryDate;
          financeDetailExpense.description =
            timesheetEntry[timeSheetEntryIndex].expenseComment;
          financeDetailExpense.amount = round(
            timesheetEntry[timeSheetEntryIndex].expenseAmount
          );
          financeDetailExpense.type = 'Expense';
          financeDetailExpense.user = timeSheet[timeSheetIndex].userId;
          financeDetailExpense.resource =
            timeSheet[timeSheetIndex].user.contact.fullName;
          financeDetailExpense.id = timeSheetId;
          details.push(financeDetailExpense);

          await fillUserFinanceCodes(
            userFinanceCodes,
            financeDetailExpense,
            timeSheet[timeSheetIndex].user.contact.id
          );
        }
      }
      exportData.details = details;

      let fees = round(
        exportData.details
          .filter((item) => item.type === 'Time')
          .reduce(function (prev, cur) {
            return prev + Number(cur.amount);
          }, 0)
      );

      let expenses = round(
        exportData.details
          .filter((item) => item.type === 'Expense')
          .reduce(function (prev, cur) {
            return prev + Number(cur.amount);
          }, 0)
      );

      exportData.fees = fees;
      exportData.expenses = expenses;
      exportData.totalAmount = round(fees + expenses);
      exportData.prevBillAmount = prevBills ? round(prevBills.sum) : 0;
      exportData.totalBillingToDate = round(
        exportData.prevBillAmount + exportData.totalAmount
      );
      exportData.balanceMou = round(
        exportData.mouEstimate - exportData.totalBillingToDate
      );
      exportData.dateCreated = new Date();
      model.createdUserId = userId;
      model.documentNo = documentNo;
      model.documentPath = documentPath;
      model.totalAmount = exportData.totalAmount;
      model.monthStartDate = startDate;

      let userItemEntry = userFinanceCodes.find((item) => {
        return item.type === 'Project';
      });
      if (userItemEntry) {
        userItemEntry.amount = exportData.totalAmount;
      }
      exportData.userFinanceCodes = userFinanceCodes;
      model.exportData = JSON.stringify(exportData);
      model.billingCount = billingCount;
      model.isDischarged = false;
      await createFinanceExport(model);

      timeSheet[timeSheetIndex].documentNo = documentNo;
      timeSheet[timeSheetIndex].amountBilled = round(fees + expenses);
      timeSheet[timeSheetIndex].is_locked = true;
      await timesheetRepo().save(timeSheet[timeSheetIndex]);
    }
    const repoClient = clientRepo();
    let client = await repoClient.findOne(res.client.id);
    if (client) {
      client.billingCount = billingCount;
      repoClient.save(client);
    }
  }

  // await createFinanceExport(financeExport);
  const repo = financeRepo();
  const result = await repo
    .createQueryBuilder('f')
    .where('f."documentNo" = :documentId ', { documentId: documentNo })
    .getMany();

  return result;
};

export const downloadpdf = async (obj) => {
  const repo = financeRepo();
  const result = await repo
    .createQueryBuilder('f')
    .where('f."documentNo" = :documentId', { documentId: obj.documentNo })
    .getMany();
  return result;
};
export const dischargeFinanceRecord = async (obj) => {
  const repo = financeRepo();
  const result = await repo
    .createQueryBuilder('f')
    .where('f."documentNo" = :documentId ', { documentId: obj.documentNo })
    .getMany();

  for (let index = 0; index < result.length; index++) {
    let timeSheets = await timesheetRepo()
      .createQueryBuilder('t')
      .where('t.is_locked = true and t.documentNo=:document', {
        document: obj.documentNo,
      })
      .getMany();

    for (
      let timesheetIndex = 0;
      timesheetIndex < timeSheets.length;
      timesheetIndex++
    ) {
      timeSheets[timesheetIndex].is_locked = false;
      await timesheetRepo().save(timeSheets[timesheetIndex]);
    }
    if (timeSheets) {
      result[index].isDischarged = true;
      result[index].exportData = '';
      await financeRepo().save(result[index]);
    }
  }

  return result;
};
export const reinstateFinanceRecord = async (obj) => {
  const repo = financeRepo();
  const result = await repo
    .createQueryBuilder('f')
    .where('f."documentNo" = :documentId ', { documentId: obj.documentNo })
    .getMany();

  const financeExport = result as IFinanceExport[];
  const documentNo = result[0].documentNo;
  const documentPath = result[0].documentNo;
  const userId = result[0].createdUserId;
  const startDate = result[0].monthStartDate;
  let billingCount = result[0].billingCount;

  for (let index = 0; index < result.length; index++) {
    // finance records

    let projectId = result[index].projectId;
    let model = financeExport[index];
    if (!model) {
      return [];
    }
    const exportData = {} as IFinanceJSON;
    exportData.projectId = projectId;
    const repo = projectRepo();
    const res = await repo
      .createQueryBuilder('p')
      .innerJoin('p.client', 'c')
      .innerJoin('p.mou', 'm')
      .select([
        'p.id',
        'p.projectName',
        'p.leadUserId',
        'p.teamWideProject',
        'c.responsibilityCenter',
        'p.mouAmount',
        'c.clientNo',
        'c.id',
        'c.stob',
        'c.projectCode',
        'c.serviceCenter',
        'm.name',
      ])
      .where('p.id = :projectId', { projectId: exportData.projectId })
      .getOne();

    exportData.leadUser = '';
    exportData.financeName = '';
    if (res.teamWideProject) {
      exportData.leadUser = 'Procurement and Supply Division';
    } else if (res.leadUserId) {
      const repoUser = userRepo();
      const leadUser = await repoUser
        .createQueryBuilder('u')
        .innerJoinAndSelect('u.contact', 'c')
        .where('u.id = :projectLeadId', { projectLeadId: res.leadUserId })
        .getOne();
      if (leadUser) {
        const repo = contactRepo();
        const contactRes = await repo
          .createQueryBuilder('c')
          .leftJoin('c.financeCodes', 'f')
          .select(['c.fullName', 'f.financeName'])
          .where('c."id" = :contactId', {
            contactId: leadUser.contact.id,
          })
          .getOne();

        if (contactRes) {
          exportData.leadUser = contactRes.fullName;
          if (contactRes.financeCodes)
            exportData.financeName = contactRes.financeCodes.financeName;
        }
      }
    } else {
      exportData.leadUser = 'Procurement and Supply Division';
    }

    // Get previous Bill amount
    const financeRep = financeRepo();

    const prevBills = await financeRep
      .createQueryBuilder('f')
      .select(['f.projectId'])
      .addSelect('SUM(f.totalAmount)', 'sum')
      .where(
        'f.projectId = :projectId  and (f.isDischarged = false OR f.isDischarged IS NULL)',
        {
          projectId: exportData.projectId,
        }
      )
      .groupBy('f.projectId')
      .getRawOne();

    const contactproRepo = projectContactRepo();
    const contactRes = await contactproRepo
      .createQueryBuilder('pc')
      .leftJoinAndSelect('pc.project', 'p')
      .leftJoinAndSelect('pc.contact', 'c')
      .where('c."contactType" = :contactType and pc."projectId" = :projectId', {
        contactType: 'clientfinance',
        projectId: exportData.projectId,
      })
      .getOne();
    exportData.contact = contactRes.contact.fullName;
    exportData.projectName = res.projectName;

    let details = [] as IFinanceExportDetail[];
    let userFinanceCodes = [] as IUserFinanceCodes[];
    let projectFinance = {} as IUserFinanceCodes;
    if (res.client) {
      projectFinance.responsibilityCenter = res.client.responsibilityCenter;
      projectFinance.clientNo = res.client.clientNo;
      projectFinance.stob = res.client.stob;
      projectFinance.projectCode = res.client.projectCode;
      projectFinance.serviceCenter = res.client.serviceCenter;
    }
    projectFinance.type = 'Project';
    userFinanceCodes.push(projectFinance);

    exportData.documentPath = documentPath;
    exportData.documentNo = documentNo;
    exportData.lineDesc = documentNo;
    exportData.createdUserId = userId;
    exportData.billingCount = billingCount;
    exportData.mouName = res.mou.name;
    exportData.mouEstimate = res.mouAmount;
    const timeSheet = await timesheetRepo()
      .createQueryBuilder('t')
      .leftJoinAndSelect('t.timesheetEntries', 'te')
      .innerJoinAndSelect('t.user', 'u')
      .innerJoinAndSelect('u.contact', 'c')
      .where(
        't."projectId" = :projectId and  t."documentNo" = :exportDocumentNo',
        {
          exportDocumentNo: documentNo,
          projectId: exportData.projectId,
          is_locked: false,
        }
      )
      .getMany();
    if (timeSheet.length == 0) {
      continue;
    }

    for (
      let timeSheetIndex = 0;
      timeSheetIndex < timeSheet.length;
      timeSheetIndex++
    ) {
      let timeSheetId = timeSheet[timeSheetIndex].id;
      for (
        let timeSheetEntryIndex = 0;
        timeSheetEntryIndex < timeSheet[timeSheetIndex].timesheetEntries.length;
        timeSheetEntryIndex++
      ) {
        const timesheetEntry: TimesheetEntry[] =
          timeSheet[timeSheetIndex].timesheetEntries;
        if (
          timesheetEntry[timeSheetEntryIndex].hoursBillable &&
          timesheetEntry[timeSheetEntryIndex].hoursBillable > 0
        ) {
          let financeDetailHour = {} as IFinanceExportDetail;
          financeDetailHour.entryDate =
            timesheetEntry[timeSheetEntryIndex].entryDate;
          financeDetailHour.description =
            timesheetEntry[timeSheetEntryIndex].commentsBillable;
          financeDetailHour.hours =
            timesheetEntry[timeSheetEntryIndex].hoursBillable;
          financeDetailHour.type = 'Time';
          financeDetailHour.user = timeSheet[timeSheetIndex].userId;
          financeDetailHour.resource =
            timeSheet[timeSheetIndex].user.contact.fullName;
          financeDetailHour.rate = timeSheet[timeSheetIndex].user.contact
            .hourlyRate
            ? timeSheet[timeSheetIndex].user.contact.hourlyRate
            : 0;
          financeDetailHour.amount = round(
            financeDetailHour.rate * financeDetailHour.hours
          );
          financeDetailHour.id = timeSheetId;
          details.push(financeDetailHour);

          await fillUserFinanceCodes(
            userFinanceCodes,
            financeDetailHour,
            timeSheet[timeSheetIndex].user.contact.id
          );
        }

        if (
          timesheetEntry[timeSheetEntryIndex].expenseAmount &&
          timesheetEntry[timeSheetEntryIndex].expenseAmount > 0
        ) {
          let financeDetailExpense = {} as IFinanceExportDetail;
          financeDetailExpense.entryDate =
            timesheetEntry[timeSheetEntryIndex].entryDate;
          financeDetailExpense.description =
            timesheetEntry[timeSheetEntryIndex].expenseComment;
          financeDetailExpense.amount = round(
            timesheetEntry[timeSheetEntryIndex].expenseAmount
          );
          financeDetailExpense.type = 'Expense';
          financeDetailExpense.user = timeSheet[timeSheetIndex].userId;
          financeDetailExpense.resource =
            timeSheet[timeSheetIndex].user.contact.fullName;
          financeDetailExpense.id = timeSheetId;
          details.push(financeDetailExpense);

          await fillUserFinanceCodes(
            userFinanceCodes,
            financeDetailExpense,
            timeSheet[timeSheetIndex].user.contact.id
          );
        }
      }
      exportData.details = details;

      let fees = round(
        exportData.details
          .filter((item) => item.type === 'Time')
          .reduce(function (prev, cur) {
            return prev + Number(cur.amount);
          }, 0)
      );

      let expenses = round(
        exportData.details
          .filter((item) => item.type === 'Expense')
          .reduce(function (prev, cur) {
            return prev + Number(cur.amount);
          }, 0)
      );

      exportData.fees = fees;
      exportData.expenses = expenses;
      exportData.totalAmount = round(fees + expenses);
      exportData.prevBillAmount = prevBills ? round(prevBills.sum) : 0;
      exportData.totalBillingToDate = round(
        exportData.prevBillAmount + exportData.totalAmount
      );
      exportData.balanceMou = round(
        exportData.mouEstimate - exportData.totalBillingToDate
      );
      exportData.dateCreated = new Date();
      model.createdUserId = userId;
      model.documentNo = documentNo;
      model.documentPath = documentPath;
      model.totalAmount = exportData.totalAmount;
      model.monthStartDate = startDate;

      let userItemEntry = userFinanceCodes.find((item) => {
        return item.type === 'Project';
      });
      if (userItemEntry) {
        userItemEntry.amount = exportData.totalAmount;
      }
      exportData.userFinanceCodes = userFinanceCodes;
      model.exportData = JSON.stringify(exportData);
      model.billingCount = billingCount;
      model.isDischarged = false;
      await financeRepo().save(model);

      timeSheet[timeSheetIndex].documentNo = documentNo;
      timeSheet[timeSheetIndex].amountBilled = round(fees + expenses);
      timeSheet[timeSheetIndex].is_locked = true;
      await timesheetRepo().save(timeSheet[timeSheetIndex]);
    }
    const repoClient = clientRepo();
    let client = await repoClient.findOne(res.client.id);
    if (client) {
      client.billingCount = billingCount;
      repoClient.save(client);
    }
  }

  return result;
};

export const createFinanceExport = async (obj: IFinanceExport) => {
  obj.dateCreated = new Date();
  await financeRepo().save(obj);
  return obj;
};

export const retrieveArchivedProjects = async () => {
  const repo = projectRepo();
  return await repo
    .createQueryBuilder('p')
    .innerJoin('p.client', 'c')
    .innerJoin('c.ministry', 'm')
    .leftJoinAndSelect('p.mou', 'o')
    .innerJoin('p.projectSector', 'ps')
    .orderBy('p.dateModified', 'DESC')
    .select([
      'p.id',
      'p.projectName',
      'ps',
      'p.dateModified',
      'p.completionDate',
      'c.orgDivision',
      'm.ministryName',
      'p.leadUserId',
      'p.backupUserId',
      'p.mouAmount',
      'p.isReprocurement',
      'p.isMinistry',
      'p.dateOfReprocurement',
      'p.previousContractBackground',
      'p.projectFailImpact',
      'p.projectSuccess',
      'p.otherProjectSectorName',
      'o.name',
      'p.teamWideProject',
    ])
    .where('p.is_archived = :is_archived', { is_archived: true })
    .getMany();
};

export const retrieveTimesheetProjects = async (obj) => {
  const repo = timesheetRepo();

  const selectedDate = obj.selectedDate.split('-');

  const year = parseInt(selectedDate[0], 10);
  const month = parseInt(selectedDate[1], 10);

  const startDate = new Date(year, month - 1, 1);
  const endDate = new Date(year, month, 0);

  const res = await repo
    .createQueryBuilder('t')
    .select('DISTINCT t.project', 'id')
    .leftJoin(FinanceExport, 'fe', 't."documentNo" = fe.documentNo')
    .where(
      '(t.startDate >= :start and t.startDate <= :end)  and (t.is_locked = :is_locked or t.is_locked IS NULL) and (fe.isDischarged IS NULL or fe.isDischarged = false)',
      {
        start: startDate,
        end: endDate,
        is_locked: false,
      }
    )
    .getRawMany();

  return res;
};

export const retrieveDischargedPdfs = async (obj) => {
  const repo = financeRepo();

  const selectedDate = obj.selectedDate.split('-');

  const year = parseInt(selectedDate[0], 10);
  const month = parseInt(selectedDate[1], 10);

  const startDate = new Date(year, month - 1, 1);
  const endDate = new Date(year, month, 0);

  const res = await repo
    .createQueryBuilder('t')
    .select(['t.documentNo', 't.documentPath'])
    .addSelect('SUM(t.totalAmount)', 'sum')
    .where(
      '(t.monthStartDate >= :start and t.monthStartDate <= :end) and t.isDischarged = :discharged ',
      {
        start: startDate,
        end: endDate,
        discharged: true,
      }
    )
    .groupBy('t.documentNo')
    .addGroupBy('t.documentPath')
    .getRawMany();

  return res;
};

export const retrieveExportedPdfs = async (obj) => {
  const repo = financeRepo();

  const selectedDate = obj.selectedDate.split('-');

  const year = parseInt(selectedDate[0], 10);
  const month = parseInt(selectedDate[1], 10);

  const startDate = new Date(year, month - 1, 1);
  const endDate = new Date(year, month, 0);

  const res = await repo
    .createQueryBuilder('t')
    .select(['t.documentNo', 't.documentPath'])
    .addSelect('SUM(t.totalAmount)', 'sum')
    .where(
      '(t.monthStartDate >= :start and t.monthStartDate <= :end) and (t.isDischarged = :discharged  OR t.isDischarged IS NULL)',
      {
        start: startDate,
        end: endDate,
        discharged: false,
      }
    )
    .groupBy('t.documentNo')
    .addGroupBy('t.documentPath')
    .getRawMany();

  return res;
};

export const retrieveMouProjectsByUserId = async (userId: string) => {
  const repo = projectRepo();
  const res = await repo
    .createQueryBuilder('p')
    .innerJoin('p.mou', 'o')
    .orderBy('p.projectName', 'ASC')
    .select([
      'p.id AS "id"',
      'p.projectName AS "projectName"',
      'p.mouAmount AS "mouAmount"',
      'o.name AS "mouName"',
      'o.id  AS "mouId"',
    ])
    .where(
      '(p.is_archived IS NULL OR p.is_archived = :is_archived) AND (p."leadUserId" = :userId OR p."backupUserId" = :userId OR p.teamWideProject=true)',
      {
        is_archived: false,
        userId,
      }
    )
    .getRawMany();

  for (let index = 0; index < res.length; index++) {
    res[index].rfxList = await retrieveRFXByProjectId(res[index].id);
  }

  return res;
};
export const retrieveRFXByProjectId = async (id: string) => {
  const repo = projectRFXRepo();
  const res = await repo
    .createQueryBuilder('pr')
    .select(['pr.id as "id"', 'pr.rfxName as "rfxName"'])
    .where('pr."projectId" = :id', { id: id })
    .orderBy('pr.rfxName', 'ASC')
    .getRawMany();
  return res;
};
export const retrieveAllProjects = async () => {
  const repo = projectRepo();
  return await repo
    .createQueryBuilder('p')
    .innerJoin('p.client', 'c')
    .leftJoin('c.ministry', 'm')
    .leftJoinAndSelect('p.mou', 'o')
    .innerJoin('p.projectSector', 'ps')
    .orderBy('p.dateModified', 'DESC')
    .select([
      'p.id',
      'p.projectName',
      'ps',
      'p.dateModified',
      'p.completionDate',
      'c.orgDivision',
      'm.ministryName',
      'p.leadUserId',
      'p.backupUserId',
      'o.name',
      'o.id',
      'p.isReprocurement',
      'c.isNonMinistry',
      'p.dateOfReprocurement',
      'p.previousContractBackground',
      'p.projectFailImpact',
      'p.projectSuccess',
      'p.otherProjectSectorName',
      'c.nonMinistryName',
      'p.mouAmount',
      'p.teamWideProject',
    ])
    .where('(p.is_archived IS NULL OR p.is_archived = :is_archived)', {
      is_archived: false,
    })
    .getMany();
};
export const retrieveProjectsByUserId = async (userId: string) => {
  const repo = projectRepo();
  return await repo
    .createQueryBuilder('p')
    .innerJoin('p.client', 'c')
    .leftJoin('c.ministry', 'm')
    .leftJoinAndSelect('p.mou', 'o')
    .innerJoin('p.projectSector', 'ps')
    .orderBy('p.dateModified', 'DESC')
    .select([
      'p.id',
      'p.projectName',
      'ps',
      'p.dateModified',
      'p.completionDate',
      'c.orgDivision',
      'm.ministryName',
      'p.leadUserId',
      'p.backupUserId',
      'o.name',
      'o.id',
      'p.isReprocurement',
      'c.isNonMinistry',
      'p.dateOfReprocurement',
      'p.previousContractBackground',
      'p.projectFailImpact',
      'p.projectSuccess',
      'p.otherProjectSectorName',
      'c.nonMinistryName',
      'p.teamWideProject',
    ])
    .where(
      '(p.is_archived IS NULL OR p.is_archived = :is_archived) AND (p."leadUserId" = :userId OR p."backupUserId" = :userId OR p.teamWideProject=true)',
      {
        is_archived: false,
        userId,
      }
    )
    .getMany();
};

export const retrieveArchivedProjectsByUserId = async (userId: string) => {
  const repo = projectRepo();
  return await repo
    .createQueryBuilder('p')
    .innerJoin('p.client', 'c')
    .innerJoin('c.ministry', 'm')
    .innerJoin('p.projectSector', 'ps')
    .select([
      'p.id',
      'p.projectName',
      'ps',
      'p.dateModified',
      'p.completionDate',
      'c.orgDivision',
      'm.ministryName',
      'p.leadUserId',
      'p.backupUserId',
      'p.mouAmount',
      'p.isReprocurement',
      'p.isMinistry',
      'p.dateOfReprocurement',
      'p.previousContractBackground',
      'p.projectFailImpact',
      'p.projectSuccess',
      'p.otherProjectSectorName',
      'p.teamWideProject',
    ])

    //   From merge conflict, this line replaced below
    //     .where('p."leadUserId" = :userId OR p."backupUserId" = :userId', {
    //       userId: userId
    //     })
    .where(
      'p."is_archived" = :is_archived, {is_archived : true}) AND p."leadUserId" = :userId OR p."backupUserId" = :userId OR p.teamWideProject=true',
      { userId: userId }
    )
    .getMany();
};
