import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { RiskQuestions } from './riskQuestions.entity';

@Entity()
export class RiskAnswers {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(type => RiskQuestions)
  question: RiskQuestions;

  @Column({ type: 'text', nullable: false })
  answer: string;

  @Column({ type: 'int', nullable: false })
  score: number;
}
