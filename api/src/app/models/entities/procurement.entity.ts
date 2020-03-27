import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { Project } from './project.entity';

@Entity()
export class ProcurementLog {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'text', nullable: true })
  riskOwner: string;

  @Column({ type: 'text', nullable: true })
  descriptionOfIssue: string;

  @Column({ type: 'text', nullable: true })
  logType: string;

  @Column({ type: 'text', nullable: true })
  notificationMethod: string;

  @Column({ type: 'text', nullable: true })
  phaseImpactName: string;

  @Column({ type: 'text', nullable: true })
  projectId: string;

  @Column({ type: 'text', nullable: true })
  clientDecision: string;

  @Column({ type: 'timestamp', nullable: true })
  dateToClient: Date;

  @Column({ type: 'timestamp', nullable: true })
  followUpDate: Date;

  @Column({ type: 'boolean', nullable: true })
  isResolved: boolean;

  @Column({ type: 'text', nullable: true })
  userId: string;

}
