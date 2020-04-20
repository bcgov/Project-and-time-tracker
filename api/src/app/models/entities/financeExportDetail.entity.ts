import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { FinanceExport } from './financeExport.entity';

@Entity()
export class FinanceExportDetail {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(type => FinanceExport)
  financeExport: FinanceExport;

  @Column({ type: 'date', nullable: false })
  entryDate: Date;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ type: 'text', nullable: false })
  type: string;

  @Column({ type: 'text', nullable: false })
  resource: string;

  @Column({ type: 'uuid', nullable: false })
  user: string;

  @Column({ type: 'double precision', nullable: true })
  hours: number;

  @Column({ type: 'double precision', nullable: true })
  rate: number;

  @Column({ type: 'double precision', nullable: false })
  amount: number;

  @Column({ type: 'timestamp', nullable: true })
  dateCreated: Date;
}
