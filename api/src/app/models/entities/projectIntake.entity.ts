import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { Client } from './client.entity';
import { ProjectSector } from './projectSector.entity';
import { MOU } from './mou.entity';

@Entity()
export class ProjectIntake {
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
  estimatedCompletionDate: Date;

  @Column({ type: 'double precision', nullable: true })
  estimatedContractValue: number;

  @Column({ type: 'double precision', nullable: true })
  mouAmount: number;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ type: 'text', nullable: true })
  status: IntakeStatus;

  @Column({ type: 'uuid', nullable: true })
  projectId: string;

  @Column({ type: 'uuid', nullable: true })
  createdUserId: string;

  @Column({ type: 'uuid', nullable: true })
  approverUserId: string;

  @Column({ type: 'int', nullable: true })
  riskScore: number;

  @Column({ type: 'int', nullable: true })
  psbRiskScore: number;

  @Column({ type: 'int', nullable: true })
  IntakeriskScore: number;

  @Column({ type: 'boolean', nullable: true })
  isSPOEngagement: boolean;

  @Column({ type: 'int', nullable: true })
  intakeRiskLevel: string;

  @Column({ type: 'timestamp', nullable: true })
  dateCreated: Date;

  @Column({ type: 'timestamp', nullable: true })
  dateModified: Date;

  @Column({ type: 'boolean', nullable: true })
  isReprocurement: boolean;

  @Column({ type: 'boolean', nullable: true })
  isMinistry: boolean;

  @Column({ type: 'date', nullable: true })
  dateOfReprocurement: Date;

  @Column({ type: 'uuid', nullable: true })
  serviceId: string;

  @Column({ type: 'uuid', nullable: true })
  categoryId: string;

  @Column({ type: 'text', nullable: true })
  previousContractBackground: string;

  @Column({ type: 'text', nullable: true })
  projectFailImpact: string;

  @Column({ type: 'text', nullable: true })
  projectSuccess: string;

  @Column({ type: 'text', nullable: true })
  otherProjectSectorName: string;

  @ManyToOne(type => MOU)
  mou: MOU;
}

export type IntakeStatus = 'submitted' | 'approved' | 'rejected';
