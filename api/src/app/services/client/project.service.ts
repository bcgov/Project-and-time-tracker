import { getRepository, Repository, getConnection } from "typeorm";
import {
  Project,
  ProjectContacts,
  Contact,
  ProjectRfx,
  ProjectCategory,
} from "../../models/entities";
import { Client } from "../../models/entities";
import { IProject } from "../../models/interfaces/i-project";
import { Timesheet } from "./../../models/entities/timesheet.entity";
import { TimesheetEntry } from "./../../models/entities/timesheetEntry.entity";
import { IClient } from "../../models/interfaces/i-client";
import { type } from "os";
import { ReplaceSource } from "webpack-sources";
import { MOU } from "../../models/entities/mou.entity";
import { User } from "../../models/entities/user.entity";
import { FinanceExport } from "../../models/entities";
import { IFinanceExport } from "../../models/interfaces/i-finance-export";
import { IFinanceExportDetail } from "../../models/interfaces/i-finance-export-detail";
import {
  IFinanceJSON,
  IUserFinanceCodes,
} from "../../models/interfaces/i-finance-json";
import { validateFinanceCodes } from "./client.service";

const userRepo = (): Repository<User> => {
  return getRepository(User);
};
const mouRepo = (): Repository<MOU> => {
  return getRepository(MOU);
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
const timesheetEntryRepo = (): Repository<TimesheetEntry> => {
  return getRepository(TimesheetEntry);
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
    throw Error("project not found");
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
      throw Error("client not found");
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
    throw Error("project not found");
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
    .createQueryBuilder("p")
    .innerJoinAndSelect("p.client", "c")
    .leftJoinAndSelect("c.ministry", "m")
    .leftJoinAndSelect("p.mou", "o")
    .where("p.id = :id", { id: id })
    .getOne();
  if (!res) {
    throw Error(`project not found for the id specified: ${id}`);
  }
  return res;
};

export const retrieveProjects = async () => {
  const repo = projectRepo();
  return await repo
    .createQueryBuilder("p")
    .innerJoin("p.client", "c")
    .leftJoin("c.ministry", "m")
    .leftJoinAndSelect("p.mou", "o")
    .innerJoin("p.projectSector", "ps")
    .orderBy("p.dateModified", "DESC")
    .select([
      "p.id",
      "p.projectName",
      "ps",
      "p.dateModified",
      "p.completionDate",
      "c.orgDivision",
      "m.ministryName",
      "p.leadUserId",
      "p.backupUserId",
      "o.name",
      "o.id",
      "p.isReprocurement",
      "c.isNonMinistry",
      "p.dateOfReprocurement",
      "p.previousContractBackground",
      "p.projectFailImpact",
      "p.projectSuccess",
      "p.otherProjectSectorName",
      "c.nonMinistryName",
      "p.mouAmount",
      "p.teamWideProject",
    ])
    .where("p.is_archived IS NULL OR p.is_archived = :is_archived", {
      is_archived: false,
    })
    .getMany();
};

function uuidv4() {
  return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, function (c) {
    var r = (Math.random() * 16) | 0,
      v = c == "x" ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}
function getPDFName(date, count) {
  return createPDFName(date,count,0);
}
function createPDFName(date,count,type) {
  var month = new Array();
  month[0] = "Janu";
  month[1] = "Feb";
  month[2] = "Mar";
  month[3] = "Apr";
  month[4] = "May";
  month[5] = "Jun";
  month[6] = "Jul";
  month[7] = "Aug";
  month[8] = "Sep";
  month[9] = "Oct";
  month[10] = "Nov";
  month[11] = "Dec";

  var newDate = new Date(date);
  if (count === 1 && type) {
    return (
      month[newDate.getMonth()] +
      " - " +
      newDate.getFullYear() +
      " - NonMinistry - " +
      count.toString() +
      " Project.pdf"
    );
  }
  if (count === 1 && !type) {
    return (
      month[newDate.getMonth()] +
      " - " +
      newDate.getFullYear() +
      " - " +
      count.toString() +
      " Project.pdf"
    );
  }
  if(type)
  return (
    month[newDate.getMonth()] +
    " - " +
    newDate.getFullYear() +
    " - NonMinistry - " +
    count.toString() +
    " Projects.pdf"
  );
  else
  return (
    month[newDate.getMonth()] +
    " - " +
    newDate.getFullYear() +
    " - " +
    count.toString() +
    " Projects.pdf"
  );
}
function getPDFNameNonMinistry(date, count) {
 return createPDFName(date, count,1);
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
      .createQueryBuilder("c")
      .innerJoinAndSelect("c.financeCodes", "f")
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

async function generateExportEntries(
  timeSheet,
  timesheetEntry,
  timeSheetId,
  details,
  userFinanceCodes
) {
  if (timesheetEntry.hoursBillable && timesheetEntry.hoursBillable > 0) {
    let financeDetailHour = {} as IFinanceExportDetail;
    financeDetailHour.entryDate = timesheetEntry.entryDate;
    financeDetailHour.description = timesheetEntry.commentsBillable;
    financeDetailHour.hours = timesheetEntry.hoursBillable;
    financeDetailHour.type = "Time";
    financeDetailHour.user = timeSheet.userId;
    financeDetailHour.resource = timeSheet.user.contact.fullName;
    financeDetailHour.rate = timeSheet.user.contact.hourlyRate
      ? timeSheet.user.contact.hourlyRate
      : 0;
    financeDetailHour.amount = round(
      financeDetailHour.rate * financeDetailHour.hours
    );
    financeDetailHour.id = timeSheetId;
    details.push(financeDetailHour);

    await fillUserFinanceCodes(
      userFinanceCodes,
      financeDetailHour,
      timeSheet.user.contact.id
    );
  }

  if (timesheetEntry.hoursUnBillable && timesheetEntry.hoursUnBillable > 0) {
    let financeDetailHour = {} as IFinanceExportDetail;
    financeDetailHour.entryDate = timesheetEntry.entryDate;
    financeDetailHour.description = timesheetEntry.commentsUnBillable;
    financeDetailHour.hours = timesheetEntry.hoursUnBillable;
    financeDetailHour.type = "Time";
    financeDetailHour.user = timeSheet.userId;
    financeDetailHour.resource = timeSheet.user.contact.fullName;
    financeDetailHour.rate = 0;
    financeDetailHour.amount = 0;
    financeDetailHour.id = timeSheetId;
    details.push(financeDetailHour);

    await fillUserFinanceCodes(
      userFinanceCodes,
      financeDetailHour,
      timeSheet.user.contact.id
    );
  }
  if (timesheetEntry.revenueHours && timesheetEntry.revenueHours > 0) {
    let financeDetailRevenue = {} as IFinanceExportDetail;
    financeDetailRevenue.entryDate = timesheetEntry.entryDate;
    financeDetailRevenue.description = timesheetEntry.revenueComment;
    financeDetailRevenue.hours = timesheetEntry.revenueHours;
    financeDetailRevenue.rate = timeSheet.user.contact.revenueRate
      ? timeSheet.user.contact.revenueRate
      : 0;
    financeDetailRevenue.amount = round(
      financeDetailRevenue.rate * financeDetailRevenue.hours
    );
    financeDetailRevenue.type = "Revenue";
    financeDetailRevenue.user = timeSheet.userId;
    financeDetailRevenue.resource = timeSheet.user.contact.fullName;
    financeDetailRevenue.id = timeSheetId;
    details.push(financeDetailRevenue);

    await fillUserFinanceCodes(
      userFinanceCodes,
      financeDetailRevenue,
      timeSheet.user.contact.id
    );
  }

  if (timesheetEntry.expenseAmount && timesheetEntry.expenseAmount > 0) {
    let financeDetailExpense = {} as IFinanceExportDetail;
    financeDetailExpense.entryDate = timesheetEntry.entryDate;
    financeDetailExpense.description = timesheetEntry.expenseComment;
    financeDetailExpense.amount = round(timesheetEntry.expenseAmount);
    financeDetailExpense.type = "Expense";
    financeDetailExpense.user = timeSheet.userId;
    financeDetailExpense.resource = timeSheet.user.contact.fullName;
    financeDetailExpense.id = timeSheetId;
    details.push(financeDetailExpense);

    await fillUserFinanceCodes(
      userFinanceCodes,
      financeDetailExpense,
      timeSheet.user.contact.id
    );
  }
}
function mergeMous(mouList) {
  let jointArray = "";

  const uniqueArray = mouList.reduce(function (a, b) {
    if (a.indexOf(b) < 0) a.push(b);
    return a;
  }, []);

  uniqueArray.forEach((item) => {
    if (jointArray === "") jointArray = item;
    else jointArray = jointArray + ", " + item;
  });

  return jointArray;
}

export const retrieveFinanceData = async (obj, userId) => {
  const splitupProjects = await getMinistryNonMinistrySplitUp(obj);
  const ministryProjects = splitupProjects[0];
  const nonMinistryProjects = splitupProjects[1];
  const financeExport = ministryProjects as IFinanceExport[];
  const financeExportNonMinistry = nonMinistryProjects as IFinanceExport[];
  const finalResult=[];
  if(financeExport.length>0){
    const documentNo: string = uuidv4();

    const selectedDate = obj.selectedDate.split('-');
  
    const year = parseInt(selectedDate[0], 10);
    const month = parseInt(selectedDate[1], 10);
  
    const startDate = new Date(year, month - 1, 1);
    const endDate = new Date(year, month, 0);
  
    const documentPath: string = getPDFName(startDate, financeExport.length);
    let mousSelected = [];
    for (let index = 0; index < financeExport.length; index++) {
      let model = financeExport[index];
      if (!model) {
        return [];
      }
      let billingCount = 1;
      const exportData = {} as IFinanceJSON;
      exportData.projectId = financeExport[index].projectId;
      exportData.projectCreated = financeExport[index].projectCreated;
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
          'm.id',
          'm.name',
          'm.billingCount',
          'p.dateCreated'
        ])
        .where('p.id = :projectId', { projectId: exportData.projectId })
        .getOne();
  
      exportData.leadUser = '';
      exportData.financeName = '';
      exportData.projectCreated = res.dateCreated;
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
      }
      if (res.mou) {
        billingCount = res.mou.billingCount ? res.mou.billingCount + 1 : 1;
      }
      projectFinance.type = 'Project';
      userFinanceCodes.push(projectFinance);
  
      exportData.documentPath = documentPath;
      exportData.documentNo = documentNo;
      exportData.lineDesc = documentNo;
      exportData.createdUserId = userId;
      exportData.billingCount = billingCount;
      exportData.mouName = res.mou.name;
      mousSelected.push(exportData.mouName);
      exportData.mouEstimate = res.mouAmount;
      const timeSheet = await timesheetRepo()
        .createQueryBuilder('t')
        .innerJoinAndSelect('t.timesheetEntries', 'te')
        .innerJoinAndSelect('t.user', 'u')
        .innerJoinAndSelect('u.contact', 'c')
        .where(
          't."projectId" = :projectId and (t.is_locked = :is_locked or t.is_locked IS NULL) and (t.startDate >= :start and t.startDate <= :end) and t.documentNo is NULL',
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
        const timesheetEntry: TimesheetEntry[] =
          timeSheet[timeSheetIndex].timesheetEntries;
        for (
          let timeSheetEntryIndex = 0;
          timeSheetEntryIndex < timeSheet[timeSheetIndex].timesheetEntries.length;
          timeSheetEntryIndex++
        ) {
          await generateExportEntries(
            timeSheet[timeSheetIndex],
            timesheetEntry[timeSheetEntryIndex],
            timeSheetId,
            details,
            userFinanceCodes
          );
        }
        exportData.details = details;
  
        let fees = round(
          exportData.details
            .filter(
              (item) =>
                (item.type === 'Time' || item.type === 'Revenue') &&
                item.id == timeSheetId
            )
            .reduce(function (prev, cur) {
              return prev + Number(cur.amount);
            }, 0)
        );
  
        let expenses = round(
          exportData.details
            .filter((item) => item.type === 'Expense' && item.id == timeSheetId)
            .reduce(function (prev, cur) {
              return prev + Number(cur.amount);
            }, 0)
        );
  
        timeSheet[timeSheetIndex].documentNo = documentNo;
        timeSheet[timeSheetIndex].amountBilled = round(fees + expenses);
        timeSheet[timeSheetIndex].is_locked = true;
        await timesheetRepo().save(timeSheet[timeSheetIndex]);
      }
  
      let fees = round(
        exportData.details
          .filter((item) => item.type === 'Time' || item.type === 'Revenue')
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
      model.mouId = res.mou.id;
      await createFinanceExport(model);
  
      const repoMou = mouRepo();
      let mou = await repoMou.findOne(res.mou.id);
      if (mou) {
        mou.billingCount = billingCount;
        await repoMou.save(mou);
      }
    }
  
    await getConnection()
      .createQueryBuilder()
      .update(FinanceExport)
      .set({ selectedMous: mergeMous(mousSelected) })
      .where('documentNo = :document', { document: documentNo })
      .execute();
    // await createFinanceExport(financeExport);
    const repo = financeRepo();
    const result = await repo
      .createQueryBuilder('f')
      .where('f."documentNo" = :documentId ', { documentId: documentNo })
      .getMany();
      finalResult[0] = result;
  } else {
    finalResult[0] = [];
  }
  if(financeExportNonMinistry.length>0){
    const documentNo: string = uuidv4();

    const selectedDate = obj.selectedDate.split('-');
  
    const year = parseInt(selectedDate[0], 10);
    const month = parseInt(selectedDate[1], 10);
  
    const startDate = new Date(year, month - 1, 1);
    const endDate = new Date(year, month, 0);
  
    const documentPath: string = getPDFNameNonMinistry(startDate, financeExportNonMinistry.length);
    let mousSelected = [];
    for (let index = 0; index < financeExportNonMinistry.length; index++) {
      let model = financeExportNonMinistry[index];
      if (!model) {
        return [];
      }
      let billingCount = 1;
      const exportData = {} as IFinanceJSON;
      exportData.projectId = financeExportNonMinistry[index].projectId;
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
          'm.id',
          'm.name',
          'm.billingCount',
          'p.dateCreated'
        ])
        .where('p.id = :projectId', { projectId: exportData.projectId })
        .getOne();
  
      exportData.leadUser = '';
      exportData.financeName = '';
      exportData.projectCreated = res.dateCreated;
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
      }
      if (res.mou) {
        billingCount = res.mou.billingCount ? res.mou.billingCount + 1 : 1;
      }
      projectFinance.type = 'Project';
      userFinanceCodes.push(projectFinance);
  
      exportData.documentPath = documentPath;
      exportData.documentNo = documentNo;
      exportData.lineDesc = documentNo;
      exportData.createdUserId = userId;
      exportData.billingCount = billingCount;
      exportData.mouName = res.mou.name;
      mousSelected.push(exportData.mouName);
      exportData.mouEstimate = res.mouAmount;
      const timeSheet = await timesheetRepo()
        .createQueryBuilder('t')
        .innerJoinAndSelect('t.timesheetEntries', 'te')
        .innerJoinAndSelect('t.user', 'u')
        .innerJoinAndSelect('u.contact', 'c')
        .where(
          't."projectId" = :projectId and (t.is_locked = :is_locked or t.is_locked IS NULL) and (t.startDate >= :start and t.startDate <= :end) and t.documentNo is NULL',
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
        const timesheetEntry: TimesheetEntry[] =
          timeSheet[timeSheetIndex].timesheetEntries;
        for (
          let timeSheetEntryIndex = 0;
          timeSheetEntryIndex < timeSheet[timeSheetIndex].timesheetEntries.length;
          timeSheetEntryIndex++
        ) {
          await generateExportEntries(
            timeSheet[timeSheetIndex],
            timesheetEntry[timeSheetEntryIndex],
            timeSheetId,
            details,
            userFinanceCodes
          );
        }
        exportData.details = details;
  
        let fees = round(
          exportData.details
            .filter(
              (item) =>
                (item.type === 'Time' || item.type === 'Revenue') &&
                item.id == timeSheetId
            )
            .reduce(function (prev, cur) {
              return prev + Number(cur.amount);
            }, 0)
        );
  
        let expenses = round(
          exportData.details
            .filter((item) => item.type === 'Expense' && item.id == timeSheetId)
            .reduce(function (prev, cur) {
              return prev + Number(cur.amount);
            }, 0)
        );
  
        timeSheet[timeSheetIndex].documentNo = documentNo;
        timeSheet[timeSheetIndex].amountBilled = round(fees + expenses);
        timeSheet[timeSheetIndex].is_locked = true;
        await timesheetRepo().save(timeSheet[timeSheetIndex]);
      }
  
      let fees = round(
        exportData.details
          .filter((item) => item.type === 'Time' || item.type === 'Revenue')
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
      model.mouId = res.mou.id;
      model.isNonMinistry = true;
      await createFinanceExport(model);
  
      const repoMou = mouRepo();
      let mou = await repoMou.findOne(res.mou.id);
      if (mou) {
        mou.billingCount = billingCount;
        await repoMou.save(mou);
      }
    }
  
    await getConnection()
      .createQueryBuilder()
      .update(FinanceExport)
      .set({ selectedMous: mergeMous(mousSelected) })
      .where('documentNo = :document', { document: documentNo })
      .execute();
    // await createFinanceExport(financeExport);
    const repo = financeRepo();
    const result = await repo
      .createQueryBuilder('f')
      .where('f."documentNo" = :documentId ', { documentId: documentNo })
      .getMany();
    finalResult[1]= result;
  }else {
    finalResult[1] = [];
  }
  return finalResult;
};

export const downloadpdf = async (obj) => {
  const repo = financeRepo();
  const result = await repo
    .createQueryBuilder("f")
    .where('f."documentNo" = :documentId', { documentId: obj.documentNo })
    .orderBy("f.mouId, f.billingCount", "ASC")
    .getMany();
  return result;
};
export const dischargeFinanceRecord = async (obj) => {
  const repo = financeRepo();
  const result = await repo
    .createQueryBuilder("f")
    .where('f."documentNo" = :documentId ', { documentId: obj.documentNo })
    .getMany();

  if (result && result.length > 0 && result[0].isDischarged == null) {
    return [];
  }
  for (let index = 0; index < result.length; index++) {
    let timeSheets = await timesheetRepo()
      .createQueryBuilder("t")
      .where("t.is_locked = true and t.documentNo=:document", {
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
      result[index].exportData = "";
      if (!result[index].mouId) {
        result[index].billingCount = 0;
      }
      await financeRepo().save(result[index]);
    }
  }

  return result;
};
export const reGenerateFinanceRecord = async (obj) => {
  const frepo = financeRepo();
  let financeResult = await frepo
    .createQueryBuilder("f")
    .where('f."documentNo" = :documentId ', { documentId: obj.documentNo })
    .getMany();
    
    const repo = timesheetRepo();
    const res = await repo
    .createQueryBuilder("t")
    .select(['p.id as key','cl.isNonMinistry as isNonMinistry'])
    .addSelect('CASE WHEN cl.nonMinistryName IS null THEN mi.ministryName ELSE cl.nonMinistryName END','client')
    .innerJoin('t.timesheetEntries', 'te')
    .leftJoin(FinanceExport, 'fe', 't."documentNo" = fe.documentNo')
    .innerJoin('t.project', 'p')
    .innerJoin('p.mou', 'mo')
    .innerJoin('p.client', 'cl')
    .leftJoin('cl.ministry', 'mi')
    .where('fe."documentNo" = :documentId ', { documentId: obj.documentNo })
    .getRawMany();
    
    for (let index = 0; index < financeResult.length; index++) {
    if(res[0].isnonministry){
    let val = "-NonMinistry";
    let position =11;
    let oldPath =financeResult[index].documentPath;
    financeResult[index].documentPath =[financeResult[index].documentPath.slice(0, position), val, financeResult[index].documentPath.slice(position)].join('');
    financeResult[index].exportData = financeResult[index].exportData.replace(oldPath,financeResult[index].documentPath);
    }
    financeResult[index].isNonMinistry =res[0].isnonministry;
    await financeRepo().save(financeResult[index]);
    }
  return financeResult;
};
export const reinstateFinanceRecord = async (obj) => {
  const repo = financeRepo();
  const result = await repo
    .createQueryBuilder("f")
    .where('f."documentNo" = :documentId ', { documentId: obj.documentNo })
    .orderBy("f.mouId, f.billingCount", "ASC")
    .getMany();

  const financeExport = result as IFinanceExport[];
  const documentNo = result[0].documentNo;
  const documentPath = result[0].documentPath;
  const userId = result[0].createdUserId;
  const startDate = result[0].monthStartDate;
  let mousSelected = [];

  for (let index = 0; index < result.length; index++) {
    // finance records
    let billingCount = result[index].billingCount;

    let projectId = result[index].projectId;
    let model = financeExport[index];
    if (!model) {
      return [];
    }
    const exportData = {} as IFinanceJSON;
    exportData.projectId = projectId;
    const repo = projectRepo();
    const res = await repo
      .createQueryBuilder("p")
      .innerJoin("p.client", "c")
      .innerJoin("p.mou", "m")
      .select([
        "p.id",
        "p.projectName",
        "p.leadUserId",
        "p.teamWideProject",
        "c.responsibilityCenter",
        "p.mouAmount",
        "c.clientNo",
        "c.id",
        "c.stob",
        "c.projectCode",
        "c.serviceCenter",
        "m.name",
        "m.id",
        "m.billingCount",
      ])
      .where("p.id = :projectId", { projectId: exportData.projectId })
      .getOne();

    exportData.leadUser = "";
    exportData.financeName = "";
    if (res.teamWideProject) {
      exportData.leadUser = "Procurement and Supply Division";
    } else if (res.leadUserId) {
      const repoUser = userRepo();
      const leadUser = await repoUser
        .createQueryBuilder("u")
        .innerJoinAndSelect("u.contact", "c")
        .where("u.id = :projectLeadId", { projectLeadId: res.leadUserId })
        .getOne();
      if (leadUser) {
        const repo = contactRepo();
        const contactRes = await repo
          .createQueryBuilder("c")
          .leftJoin("c.financeCodes", "f")
          .select(["c.fullName", "f.financeName"])
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
      exportData.leadUser = "Procurement and Supply Division";
    }

    // Get previous Bill amount
    const financeRep = financeRepo();

    const prevBills = await financeRep
      .createQueryBuilder("f")
      .select(["f.projectId"])
      .addSelect("SUM(f.totalAmount)", "sum")
      .where(
        "f.projectId = :projectId  and (f.isDischarged = false OR f.isDischarged IS NULL)",
        {
          projectId: exportData.projectId,
        }
      )
      .groupBy("f.projectId")
      .getRawOne();

    const contactproRepo = projectContactRepo();
    const contactRes = await contactproRepo
      .createQueryBuilder("pc")
      .leftJoinAndSelect("pc.project", "p")
      .leftJoinAndSelect("pc.contact", "c")
      .where('c."contactType" = :contactType and pc."projectId" = :projectId', {
        contactType: "clientfinance",
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
    if (res.mou && billingCount == 0) {
      billingCount = res.mou.billingCount ? res.mou.billingCount + 1 : 1;
      const repoMou = mouRepo();
      let mou = await repoMou.findOne(res.mou.id);
      if (mou) {
        mou.billingCount = billingCount;
        await repoMou.save(mou);
      }
    }
    projectFinance.type = "Project";
    userFinanceCodes.push(projectFinance);

    exportData.documentPath = documentPath;
    exportData.documentNo = documentNo;
    exportData.lineDesc = documentNo;
    exportData.createdUserId = userId;
    exportData.billingCount = billingCount;
    exportData.mouName = res.mou.name;
    mousSelected.push(exportData.mouName);
    exportData.mouEstimate = res.mouAmount;
    const timeSheet = await timesheetRepo()
      .createQueryBuilder("t")
      .innerJoinAndSelect("t.timesheetEntries", "te")
      .innerJoinAndSelect("t.user", "u")
      .innerJoinAndSelect("u.contact", "c")
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
      let timesheetEntry: TimesheetEntry[] =
        timeSheet[timeSheetIndex].timesheetEntries;
      for (
        let timeSheetEntryIndex = 0;
        timeSheetEntryIndex < timeSheet[timeSheetIndex].timesheetEntries.length;
        timeSheetEntryIndex++
      ) {
        await generateExportEntries(
          timeSheet[timeSheetIndex],
          timesheetEntry[timeSheetEntryIndex],
          timeSheetId,
          details,
          userFinanceCodes
        );
      }
      exportData.details = details;

      let fees = round(
        exportData.details
          .filter(
            (item) =>
              (item.type === "Time" || item.type === "Revenue") &&
              item.id == timeSheetId
          )
          .reduce(function (prev, cur) {
            return prev + Number(cur.amount);
          }, 0)
      );

      let expenses = round(
        exportData.details
          .filter((item) => item.type === "Expense" && item.id == timeSheetId)
          .reduce(function (prev, cur) {
            return prev + Number(cur.amount);
          }, 0)
      );

      timeSheet[timeSheetIndex].documentNo = documentNo;
      timeSheet[timeSheetIndex].amountBilled = round(fees + expenses);
      timeSheet[timeSheetIndex].is_locked = true;
      await timesheetRepo().save(timeSheet[timeSheetIndex]);
    }

    let fees = round(
      exportData.details
        .filter((item) => item.type === "Time" || item.type === "Revenue")
        .reduce(function (prev, cur) {
          return prev + Number(cur.amount);
        }, 0)
    );

    let expenses = round(
      exportData.details
        .filter((item) => item.type === "Expense")
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
      return item.type === "Project";
    });
    if (userItemEntry) {
      userItemEntry.amount = exportData.totalAmount;
    }
    exportData.userFinanceCodes = userFinanceCodes;
    model.exportData = JSON.stringify(exportData);
    model.billingCount = billingCount;
    model.isDischarged = false;
    model.mouId = res.mou.id;
    await financeRepo().save(model);
  }

  await getConnection()
    .createQueryBuilder()
    .update(FinanceExport)
    .set({ selectedMous: mergeMous(mousSelected) })
    .where("documentNo = :document", { document: documentNo })
    .execute();

  return result;
};

export const createFinanceExport = async (obj: IFinanceExport) => {
  obj.dateCreated = new Date();
  await financeRepo().save(obj);
  return obj;
};
export const getMinistryNonMinistrySplitUp = async (financeProjects) => {
  
  const ministryProjects = [];
  const nonMinistryProjects = [];
  const loopResult = await financeProjects.selectedProjects.forEach(async (project) => {
    if(project.isNonMinistry){
      nonMinistryProjects.push(project)
    } else {
      ministryProjects.push(project);
    }
});
  let res = [];
  res[0] =ministryProjects;
  res[1] = nonMinistryProjects;
  return res;
};
// export const getMinistryNonMinistry = async(project) => {
//   const repo = projectRepo();
//     const ministryres = await repo
//       .createQueryBuilder("p")
//       .select(["p.id"])
//       .innerJoinAndSelect("p.client", "c")
//       .where('p."id" = :id', { id: project.projectId })
//       .getOne();
//     return ministryres.client.isNonMinistry;
  
// }

export const retrieveArchivedProjects = async () => {
  const repo = projectRepo();
  return await repo
    .createQueryBuilder("p")
    .innerJoin("p.client", "c")
    .innerJoin("c.ministry", "m")
    .leftJoinAndSelect("p.mou", "o")
    .innerJoin("p.projectSector", "ps")
    .orderBy("p.dateModified", "DESC")
    .select([
      "p.id",
      "p.projectName",
      "ps",
      "p.dateModified",
      "p.completionDate",
      "c.orgDivision",
      "m.ministryName",
      "p.leadUserId",
      "p.backupUserId",
      "p.mouAmount",
      "p.isReprocurement",
      "p.isMinistry",
      "p.dateOfReprocurement",
      "p.previousContractBackground",
      "p.projectFailImpact",
      "p.projectSuccess",
      "p.otherProjectSectorName",
      "o.name",
      "p.teamWideProject",
    ])
    .where("p.is_archived = :is_archived", { is_archived: true })
    .getMany();
};

export const retrieveTimesheetProjects = async (obj) => {
  const repo = timesheetRepo();

  const selectedDate = obj.selectedDate.split("-");

  const year = parseInt(selectedDate[0], 10);
  const month = parseInt(selectedDate[1], 10);

  const startDate = new Date(year, month - 1, 1);
  const endDate = new Date(year, month, 0);

  const res = await repo
    .createQueryBuilder("t")
    .select("DISTINCT t.project", "id")
    .innerJoin("t.timesheetEntries", "te")
    .leftJoin(FinanceExport, "fe", 't."documentNo" = fe.documentNo')
    .innerJoin("t.project", "p")
    .where("t.startDate >= :startDate AND t.startDate <= :endDate", {
      startDate,
      endDate,
    })
    .andWhere("(t.is_locked = false OR t.is_locked IS NULL)")
    .andWhere("(fe.isDischarged = false OR fe.isDischarged IS NULL)")
    .andWhere("(p.categoryId = :categoryId OR p.categoryId IS NULL)", {
      categoryId: ProjectCategory.CostRecoverable,
    })
    .getRawMany();

  return res;
};

export const retrieveDischargedPdfs = async (obj) => {
  const repo = financeRepo();

  const selectedDate = obj.selectedDate.split("-");

  const year = parseInt(selectedDate[0], 10);
  const month = parseInt(selectedDate[1], 10);

  const startDate = new Date(year, month - 1, 1);
  const endDate = new Date(year, month, 0);

  const res = await repo
    .createQueryBuilder("t")
    .select(["t.documentNo", "t.documentPath", "t.selectedMous"])
    .addSelect("SUM(t.totalAmount)", "sum")
    .where(
      "(t.monthStartDate >= :start and t.monthStartDate <= :end) and t.isDischarged = :discharged ",
      {
        start: startDate,
        end: endDate,
        discharged: true,
      }
    )
    .groupBy("t.documentNo")
    .addGroupBy("t.documentPath")
    .addGroupBy("t.selectedMous")
    .getRawMany();

  return res;
};

export const retrieveExportedPdfs = async (obj) => {
  const repo = financeRepo();

  const selectedDate = obj.selectedDate.split("-");

  const year = parseInt(selectedDate[0], 10);
  const month = parseInt(selectedDate[1], 10);

  const startDate = new Date(year, month - 1, 1);
  const endDate = new Date(year, month, 0);

  const res = await repo
    .createQueryBuilder("t")
    .select(["t.documentNo", "t.documentPath", "t.selectedMous"])
    .addSelect('CASE WHEN t.isNonMinistry IS null THEN null ELSE t.isNonMinistry END','isNonMinistry')
    .addSelect("SUM(t.totalAmount)", "sum")
    .where(
      "(t.monthStartDate >= :start and t.monthStartDate <= :end) and (t.isDischarged = :discharged  OR t.isDischarged IS NULL)",
      {
        start: startDate,
        end: endDate,
        discharged: false,
      }
    )
    .groupBy("t.documentNo")
    .addGroupBy("t.documentPath")
    .addGroupBy("t.selectedMous")
    .addGroupBy("t.isNonMinistry")
    .getRawMany();
  
  return res;
};

export const retrieveMouProjectsByUserId = async (userId: string) => {
  const repo = projectRepo();
  const projects = await repo
    .createQueryBuilder("p")
    .innerJoinAndSelect("p.mou", "o")
    .innerJoinAndSelect("p.client", "c")
    .orderBy("p.projectName", "ASC")
    .where(
      '(p.is_archived IS NULL OR p.is_archived = :is_archived) AND (p."leadUserId" = :userId OR p."backupUserId" = :userId OR p.teamWideProject=true)',
      {
        is_archived: false,
        userId,
      }
    )
    .getMany();

  const results = projects.map(async (project) => {
    const [totalBillWithForecast, rfxList] = await Promise.all([
      retrieveTotalBillAmountWithForecastByProject(project.id),
      retrieveRFXByProjectId(project.id),
    ]);
    return {
      id: project.id,
      projectName: project.projectName,
      mouAmount: project.mouAmount,
      mouName: project.mou.name,
      mouId: project.mou.id,
      totalAmountBilled: round(totalBillWithForecast),
      rfxList: rfxList,
      isCostRecoverable:
        project.categoryId === ProjectCategory.CostRecoverable ||
        project.categoryId === null,
      hasValidFinanceCodes: validateFinanceCodes(project.client).length === 0,
    };
  });

  return await Promise.all(results);
};

export const retrieveRFXByProjectId = async (id: string) => {
  const repo = projectRFXRepo();
  const res = await repo
    .createQueryBuilder("pr")
    .select(['pr.id as "id"', 'pr.rfxName as "rfxName"'])
    .where('pr."projectId" = :id', { id: id })
    .orderBy("pr.rfxName", "ASC")
    .getRawMany();
  return res;
};

/**
 * Retrieve the total bill anount for the project considering the timesheets already locked
 * and calculating the forecast for the timesheets that are not locked yet.
 * @param id Project ID to be retrieved.
 */
export const retrieveTotalBillAmountWithForecastByProject = async (
  id: string
) => {
  const [totalLocked, totalUnlocked] = await Promise.all([
    retrieveTotalAmountBilledByProjectId(id),
    retrieveTotalAmountToBillByProjectId(id),
  ]);

  let totalAmountToBill = 0;
  if (totalUnlocked && totalUnlocked.length) {
    totalAmountToBill = totalUnlocked
      .map((x) => x.totalBillableTime + x.totalRevenue + x.totalExpenses)
      .reduce((prev, cur) => prev + cur);
  }

  return totalLocked + totalAmountToBill;
};

/**
 * Sum all the already billed timesheets.
 * When a report is exported for a particular period, the column amountBilled is updated
 * on the table timesheet. The process will use the current values for hourly rates and revenue
 * rates to calculate the bill amount.
 * @param id Project ID to be retrieved.
 */
export const retrieveTotalAmountBilledByProjectId = async (id: string) => {
  const repo = timesheetRepo();
  const lockedAmount = await repo
    .createQueryBuilder("t")
    .select("SUM(t.amountBilled)")
    .where('t."projectId" = :id AND t."is_locked" = :isLocked', {
      id: id,
      isLocked: true,
    })
    .getRawOne();
  return lockedAmount.sum;
};

/**
 * Sum all the expenses, revenues and timesheet hours that belongs to the project
 * and that were still not locked (lock will happen during report generation).
 * @param id Project ID to be retrieved.
 */
export const retrieveTotalAmountToBillByProjectId = async (id: string) => {
  const timeSheetEntryRepo = timesheetEntryRepo();
  const openTimeSheetsAmount = await timeSheetEntryRepo
    .createQueryBuilder("tse")
    .select('tse."timesheetId"')
    .addSelect('SUM(tse."hoursBillable") * c."hourlyRate"', "totalBillableTime")
    .addSelect(
      'SUM(tse."revenueHours") * COALESCE (c."revenueRate", 0)',
      "totalRevenue"
    )
    .addSelect('SUM(tse."expenseAmount")', "totalExpenses")
    .innerJoin("timesheet", "ts", 'tse."timesheetId" = ts.Id')
    .innerJoin("user", "u", 'ts."userId" = u.Id')
    .innerJoin("contact", "c", 'u."contactId" = c.Id')
    .where('ts."projectId" = :id AND ts."is_locked" = :isLocked', {
      id: id,
      isLocked: false,
    })
    .groupBy('tse."timesheetId"')
    .addGroupBy('c."revenueRate"')
    .addGroupBy('c."hourlyRate"')
    .getRawMany();
  return openTimeSheetsAmount;
};

export const retrieveAllProjects = async () => {
  const repo = projectRepo();
  return await repo
    .createQueryBuilder("p")
    .innerJoin("p.client", "c")
    .leftJoin("c.ministry", "m")
    .leftJoinAndSelect("p.mou", "o")
    .innerJoin("p.projectSector", "ps")
    .orderBy("p.dateModified", "DESC")
    .select([
      "p.id",
      "p.projectName",
      "ps",
      "p.dateModified",
      "p.completionDate",
      "c.orgDivision",
      "m.ministryName",
      "p.leadUserId",
      "p.backupUserId",
      "o.name",
      "o.id",
      "p.isReprocurement",
      "c.isNonMinistry",
      "p.dateOfReprocurement",
      "p.previousContractBackground",
      "p.projectFailImpact",
      "p.projectSuccess",
      "p.otherProjectSectorName",
      "c.nonMinistryName",
      "p.mouAmount",
      "p.teamWideProject",
    ])
    .where("(p.is_archived IS NULL OR p.is_archived = :is_archived)", {
      is_archived: false,
    })
    .getMany();
};
export const retrieveProjectsByUserId = async (userId: string) => {
  const repo = projectRepo();
  return await repo
    .createQueryBuilder("p")
    .innerJoin("p.client", "c")
    .leftJoin("c.ministry", "m")
    .leftJoinAndSelect("p.mou", "o")
    .innerJoin("p.projectSector", "ps")
    .orderBy("p.dateModified", "DESC")
    .select([
      "p.id",
      "p.projectName",
      "ps",
      "p.dateModified",
      "p.completionDate",
      "c.orgDivision",
      "m.ministryName",
      "p.leadUserId",
      "p.backupUserId",
      "o.name",
      "o.id",
      "p.isReprocurement",
      "c.isNonMinistry",
      "p.dateOfReprocurement",
      "p.previousContractBackground",
      "p.projectFailImpact",
      "p.projectSuccess",
      "p.otherProjectSectorName",
      "c.nonMinistryName",
      "p.teamWideProject",
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
    .createQueryBuilder("p")
    .innerJoin("p.client", "c")
    .innerJoin("c.ministry", "m")
    .innerJoin("p.projectSector", "ps")
    .select([
      "p.id",
      "p.projectName",
      "ps",
      "p.dateModified",
      "p.completionDate",
      "c.orgDivision",
      "m.ministryName",
      "p.leadUserId",
      "p.backupUserId",
      "p.mouAmount",
      "p.isReprocurement",
      "p.isMinistry",
      "p.dateOfReprocurement",
      "p.previousContractBackground",
      "p.projectFailImpact",
      "p.projectSuccess",
      "p.otherProjectSectorName",
      "p.teamWideProject",
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

export const getProjectCategories = () => {
  return [
    { id: ProjectCategory.CSA, description: "CSA" },
    { id: ProjectCategory.ITQ, description: "ITQ" },
    { id: ProjectCategory.CostRecoverable, description: "Cost Recoverable" },
    { id: ProjectCategory.NonRecoverable, description: "Non Recoverable" },
  ];
};
