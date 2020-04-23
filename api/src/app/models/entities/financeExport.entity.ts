import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';

@Entity()
export class FinanceExport {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'text', nullable: false })
  documentNo: string;

  @Column({ type: 'json', nullable: false })
  exportData: string;

  @Column({ type: 'uuid', nullable: true })
  projectId: string;

  @Column({ type: 'text', nullable: true })
  documentPath: string;

  @Column({ type: 'timestamp', nullable: true })
  dateCreated: Date;

  @Column({ type: 'uuid', nullable: true })
  createdUserId: string;

  @Column({ type: 'double precision', nullable: true })
  totalAmount: number;

  @Column({ type: 'date', nullable: true })
  monthStartDate: Date;
}
