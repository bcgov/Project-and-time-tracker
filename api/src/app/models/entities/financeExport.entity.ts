import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';

import { FinanceExportDetail } from './financeExportDetail.entity';
@Entity()
export class FinanceExport {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'text', nullable: false })
  documentNo: string;

  @Column({ type: 'text', nullable: true })
  lineDesc: string;

  @Column({ type: 'text', nullable: true })
  sap: string;

  @Column({ type: 'text', nullable: true })
  reference: string;

  @Column({ type: 'text', nullable: true })
  contact: string;

  @Column({ type: 'text', nullable: true })
  organisation: string;

  @Column({ type: 'double precision', nullable: false })
  fees: number;

  @Column({ type: 'double precision', nullable: false })
  expenses: number;

  @Column({ type: 'double precision', nullable: false })
  totalAmount: number;

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

  @Column({ type: 'uuid', nullable: true })
  projectId: string;

  @Column({ type: 'text', nullable: true })
  projectName: string;

  @Column({ type: 'timestamp', nullable: true })
  dateCreated: Date;

  @Column({ type: 'uuid', nullable: true })
  createdUserId: string;

  @OneToMany(
    type => FinanceExportDetail,
    type => type.financeExport
  )
  exportDetails: FinanceExportDetail[];
}
