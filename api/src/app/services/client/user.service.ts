import { Repository, getRepository } from 'typeorm';
import { User } from '../../models/entities/user.entity';
import { IUser } from '../../models/interfaces/i-user';
import { IKeycloakUserByRole } from '../../models/interfaces/i-keycloak-user-fetch-by-role';
import { retrieveKeycloakAdminToken, retrieveKeycloakUsersByRole } from '../common/auth-verification.service';

const userRepo = (): Repository<User> => {
  return getRepository(User);
};

export const retrieveUsers = async () => {
  const repo = userRepo();
  return await repo.find();
};

export const retrieveUserById = async (id: string) => {
  const repo = userRepo();
  const res = await repo.findOne(id);
  if (!res) { throw Error(`user not found for the id specified: ${id}`); }
  return res;
};

export const retrieveUserByReferenceId = async (id: string) => {
  const repo = userRepo();
  return await repo
    .createQueryBuilder('u')
    .select([
      'u.id',
      'u.referenceId',
      'u.role',
    ])
    .where('u."referenceId" = :referenceId', { referenceId: id })
    .getOne();
};

export const retrieveUsersNameAndIdByRole = async (roles: string[]) => {

  // console.log('retrieveUsersNameAndIdByRole start - ', roles)

  const repo = userRepo();
  const users = await repo
    .createQueryBuilder('u')
    .innerJoin('u.contact', 'c')
    .select([
      'u.id',
      'u.referenceId',
      'u.role',
      'c.fullName',
      'c.hourlyRate',
      'c.id'
    ])
    .getMany();
  
  // console.log('retrieveUsersNameAndIdByRole B -', { repo, users })
  // console.log('retrieveUsersNameAndIdByRole B -')
                      
  const kcAdminToken = await retrieveKeycloakAdminToken();
  // ARC - ERROR OCCURS ABOVE
  // console.log('retrieveUsersNameAndIdByRole C - after adminToken', { kcAdminToken })
  const keycloakUsers: IKeycloakUserByRole[] = [];
  for (let index = 0; index < roles.length; index++) {
    keycloakUsers.push(...await retrieveKeycloakUsersByRole(roles[index], kcAdminToken));      
  }

  // console.log('retrieveUsersNameAndIdByRole D - have users', { keycloakUsers })

  const filteredUsers = users.filter((element, index, array) => {
    return keycloakUsers.find((value, i, arr) => {
      return value.id === element.referenceId;
    });
  });

  // console.log('retrieveUsersNameAndIdByRole E - filtered users', { filteredUsers })

  return filteredUsers;
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
