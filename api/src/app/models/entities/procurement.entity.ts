import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { Project } from './project.entity';

@Entity()
export class ProcurementLog {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'text', nullable: false })
  riskOwner: string;

  @Column({ type: 'text', nullable: false })
  descriptionOfIssue: string;

  @Column({ type: 'text', nullable: true })
  logTypeId: string;

  @Column({ type: 'text', nullable: true })
  notificationId: string;

  @Column({ type: 'text', nullable: true })
  phaseImpactId: string;

  @Column({ type: 'text', nullable: false })
  clientDecisionId: string;

  @Column({ type: 'timestamp', nullable: true })
  dateToClient: Date;

  @Column({ type: 'timestamp', nullable: true })
  followUpDate: Date;

  @ManyToOne(type => Project)
  project: Project;
}
