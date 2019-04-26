import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { Client } from './client.entity';
import { ProjectSector } from './projectSector.entity';

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
}
