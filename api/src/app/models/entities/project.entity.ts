import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { Client } from './client.entity';
import { ProjectSector } from './projectSector.entity';
import { MOU } from './mou.entity';

@Entity()
export class Project {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'text' })
  projectName: string;

  @ManyToOne(type => Client)
  client: Client;

  @ManyToOne(type => ProjectSector)
  projectSector: ProjectSector;

  @Column({ type: 'text', nullable: true })
  commodityCode: string;

  @Column({ type: 'date', nullable: true })
  dueDate: Date;

  @Column({ type: 'date', nullable: true })
  completionDate: Date;

  @Column({ type: 'double precision', nullable: true })
  contractValue: number;

  @Column({ type: 'double precision', nullable: true })
  mouAmount: number;

  @Column({ type: 'uuid', nullable: true })
  leadUserId: string;
  @Column({ type: 'uuid', nullable: true })
  backupUserId: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ type: 'timestamp', nullable: true })
  dateCreated: Date;

  @Column({ type: 'timestamp', nullable: true })
  dateModified: Date;

  @Column({ type: 'uuid', nullable: true })
  createdUserId: string;

  @Column({ type: 'uuid', nullable: true })
  modifiedUserId: string;

  @Column({ type: 'boolean', nullable: true })
  is_archived: boolean;

  @Column({ type: 'boolean', nullable: true })
  isReprocurement: boolean;

  @Column({ type: 'boolean', nullable: true })
  isMinistry: boolean;

  @Column({ type: 'date', nullable: true })
  dateOfReprocurement: Date;

  @Column({ type: 'text', nullable: true })
  previousContractBackground: string;

  @Column({ type: 'text', nullable: true })
  projectFailImpact: string;

  @Column({ type: 'text', nullable: true })
  projectSuccess: string;

  @Column({ type: 'boolean', nullable: true })
  teamWideProject: boolean;

  @Column({ type: 'text', nullable: true })
  otherProjectSectorName: string;

  @ManyToOne(type => MOU)
  mou: MOU;

  @Column({ type: 'int', nullable: true })
  categoryId: ProjectCategory
}

export enum ProjectCategory {
  CSA = 1,
  ITQ = 2,
  CostRecoverable = 3,
  NonRecoverable = 4
}
