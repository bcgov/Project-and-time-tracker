import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';

@Entity()
export class RiskQuestions {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'text', nullable: false })
  question: string;

  @Column({ type: 'int', nullable: true })
  category: number;

  @Column({ type: 'int', nullable: true })
  riskLevel: number;

  @Column({ type: 'int', nullable: false })
  questionNo: number;
}
