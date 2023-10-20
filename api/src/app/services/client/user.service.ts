import { Repository, getRepository } from 'typeorm';
import { User } from '../../models/entities/user.entity';
import { IUser } from '../../models/interfaces/i-user';
import { Contact } from '../../models/entities/contact.entity';

const contactRepo = (): Repository<Contact> => {
  return getRepository(Contact);
};

const userRepo = (): Repository<User> => {
  return getRepository(User);
};

export const retrieveUsers = async () => {
  const repo = userRepo();
  return await repo.find();
};

export const retrieveActiveUsers = async () => {
  const repo = userRepo();
  return await repo
  .createQueryBuilder('u')
  .innerJoin('u.contact', 'c')
  .select([
    'u.id',
    'u.referenceId',
    'u.role',
    'u.isActive',
    'c.fullName',
    'c.hourlyRate',
    'c.revenueRate',
    'c.id',
  ])
  .orderBy('c.fullName', 'ASC')
  .where('u."isActive" = :isActive:', { isActive: true })
  .getMany();
};

export const retrieveInactiveUsers = async () => {
  const repo = userRepo();
  return await repo
  .createQueryBuilder('u')
  .innerJoin('u.contact', 'c')
  .select([
    'u.id',
    'u.referenceId',
    'u.role',
    'u.isActive',
    'c.fullName',
    'c.hourlyRate',
    'c.revenueRate',
    'c.id',
  ])
  .orderBy('c.fullName', 'ASC')
  .where('u."isActive" = :isActive:', { isActive: false })
  .getMany();
};

export const retrieveUserById = async (id: string) => {
  const repo = userRepo();
  const res = await repo.findOne(id);
  if (!res) {
    throw Error(`user not found for the id specified: ${id}`);
  }
  return res;
};

export const retrieveUserByReferenceId = async (id: string) => {
  const repo = userRepo();
  return await repo
    .createQueryBuilder('u')
    .select(['u.id', 'u.referenceId', 'u.role'])
    .where('u."referenceId" = :referenceId', { referenceId: id })
    .getOne();
};


export const retrieveUsersWithFinanceCodes = async () => {
  const repo = userRepo();
  const users = await repo
    .createQueryBuilder('u')
    .innerJoin('u.contact', 'c')
    .select([
      'u.id',
      'u.referenceId',
      'u.role',
      'u.isActive',
      'c.fullName',
      'c.hourlyRate',
      'c.revenueRate',
      'c.id',
    ])
    .orderBy('c.fullName', 'ASC')
    .getMany();

  

  for (let i = 0; i < users.length; i++) {
    const contactRep = contactRepo();
    const contactRes = await contactRep
      .createQueryBuilder('c')
      .innerJoin('c.financeCodes', 'f')
      .select([
        'c.fullName',
        'c.hourlyRate',
        'c.revenueRate',
        'f.id',
        'c.id',
        'f.financeName',
      ])
      .where('c."id" = :contactId', {
        contactId: users[i].contact.id,
      })
      .getOne();
    if (contactRes) {
      users[i].contact.financeCodes = contactRes.financeCodes;
    }
  }

  return users;
};

export const createUser = async (obj: IUser) => {
  const repo = userRepo();
  const user = repo.create(obj);
  return await repo.save(user);
};

export const updateUser = async (id: string, fields: any) => {
  const repo = userRepo();
  const user: User = await repo.findOne(id);

  if (!user) {
    throw Error('user not found');
  }
  const updatedUser = await repo.merge(user, fields);

  repo.save(updatedUser);
  return updateUser;
};
