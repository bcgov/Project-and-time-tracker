import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { RiskQuestions } from './riskQuestions.entity';
import { ProjectIntake } from './projectIntake.entity';
import { RiskAnswers } from './riskAnswers.entity';

@Entity()
export class ProjectRiskAnalysis {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(type => RiskQuestions)
  question: RiskQuestions;

  @ManyToOne(type => RiskAnswers)
  Answer: RiskAnswers;

  @ManyToOne(type => ProjectIntake)
  Intake: ProjectIntake;

  @Column({ type: 'uuid', nullable: true })
  projectId: string;

  @Column({ type: 'int', nullable: false })
  score: number;

  @Column({ type: 'timestamp', nullable: true })
  dateCreated: Date;

  @Column({ type: "timestamp", nullable: true })
  dateModified: Date;
}
