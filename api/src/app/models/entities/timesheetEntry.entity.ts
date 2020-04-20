import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { Timesheet } from './timesheet.entity';

@Entity()
export class TimesheetEntry {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(type => Timesheet)
  timesheet: Timesheet;

  @Column({ type: 'double precision', nullable: true })
  hoursBillable: number;

  @Column({ type: 'text', nullable: true })
  commentsBillable: string;

  @Column({ type: 'double precision', nullable: true })
  hoursUnBillable: number;

  @Column({ type: 'text', nullable: true })
  commentsUnBillable: string;

  @Column({ type: 'text', nullable: true })
  expenseCategory: string;

  @Column({ type: 'double precision', nullable: true })
  expenseAmount: number;

  @Column({ type: 'text', nullable: true })
  expenseComment: string;

  @Column({ type: 'double precision', nullable: true })
  revenueAmount: number;

  @Column({ type: 'text', nullable: true })
  revenueComment: string;

  @Column({ type: 'date', nullable: true })
  entryDate: Date;

  @Column({ type: 'uuid', nullable: true })
  timeSheetEntryId: string;

  @Column({ type: 'timestamp', nullable: true })
  dateCreated: Date;

  @Column({ type: 'timestamp', nullable: true })
  dateModified: Date;
}
