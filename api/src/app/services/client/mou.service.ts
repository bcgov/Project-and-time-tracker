import { getRepository, Repository } from 'typeorm';
import { MOU } from '../../models/entities/mou.entity';
import { retrieveProjectById, updateProject } from './project.service';

const mouRepo = (): Repository<MOU> => {
  return getRepository(MOU);
};

export const retrieveMOUs = async () => {
  const repo = mouRepo();
  return await repo.find();
};

// TODO - CHANGE THIS!  Do a lookup first, and if so, assign.
// Otherwise, create.
// https://stackoverflow.com/questions/46745688/typeorm-upsert-create-if-not-exist
// does typeOrm have "findOrCreate'"

// Goal -> create MOU if not exist, then assign mouID to project.
//
export const createMOU = async (obj: { name: string }) => {
  const repo = mouRepo();
  if (obj && obj.name == '') return null;
  const existingMou = await repo
    .createQueryBuilder('m')
    .where('m.name = :name', { name: obj.name })
    .getOne();

  if (existingMou) return existingMou;

  const mou = repo.create(obj);
  const ret = await repo.save(mou);
  if (!ret) {
    throw Error('no object inserted');
  }
  return ret;
};

export const deleteMOU = async (id: string) => {
  const repo = mouRepo();
  const mou = await repo.findOne(id);
 
  if (!mou) {
    throw Error('MOU not Found');
  }
  return await repo.delete(mou);
};


export const assignProjectToMOU = async obj => {
  const id_todo = '1';
  // const proj = await retrieveProjectById(id_todo)
  // projs.mouID = '999'
  console.log('assignProjectToMOU, TODO TEST ME!');
  const status = await updateProject(id_todo, { mouID: 999 });
};
