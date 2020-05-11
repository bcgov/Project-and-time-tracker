import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class FinanceCodes {
  @PrimaryGeneratedColumn()
  id: string;

  @Column({ type: 'text', nullable: true })
  financeName: string;

  @Column({ type: 'text', nullable: true })
  clientNo: string;

  @Column({ type: 'text', nullable: true })
  responsibilityCenter: string;

  @Column({ type: 'text', nullable: true })
  serviceCenter: string;

  @Column({ type: 'text', nullable: true })
  stob: string;

  @Column({ type: 'text', nullable: true })
  projectCode: string;
}
