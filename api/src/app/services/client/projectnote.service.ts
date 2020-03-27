import { getRepository, Repository } from 'typeorm';
import { ProjectNote } from '../../models/entities/project_note.entity';

const projectNoteRepo = (): Repository<ProjectNote> => {
  return getRepository(ProjectNote);
};

export const createProjectNotes = async (obj: ProjectNote) => {
  const projectnotes: ProjectNote = projectNoteRepo().create(obj);
  await projectNoteRepo().save(projectnotes);
  return projectnotes;
};

export const retrieveAllProjectNotes = async (projId: string) => {
  const repo = projectNoteRepo();
  return await repo
    .createQueryBuilder('p')
    .leftJoinAndSelect('p.user', 'u')
    .leftJoinAndSelect('u.contact', 'c')
    .where(`p.projectId = '` + projId + `'`)
    .getMany();
};

// export const updateProcLog = async (id: string, fields: any) => {
//   const repo = procurementLogRepo();
//   const proclog: ProcurementLog = await repo.findOne(id);

//   if (!proclog) {
//     throw Error('procurement log not found');
//   }
//   const updatedIntake = await repo.merge(proclog, fields);
//   // updatedIntake.dateModified = new Date();

//   await repo.save(updatedIntake);
//   return updatedIntake;
// };

// export const retrieveProcurementLogsByProjectId = async (id: string) => {
//   const repo = procurementLogRepo();
//   const res = await repo
//     .createQueryBuilder('pl')
//     .leftJoinAndSelect(Project, 'p', 'p."id" = pl.projectId')
//     .where('pl."projectId" = :id', { id: id })
//     .getMany();
//   if (!res) {
//     throw Error(`contact not found for the id specified: ${id}`);
//   }
//   return res;
// };

