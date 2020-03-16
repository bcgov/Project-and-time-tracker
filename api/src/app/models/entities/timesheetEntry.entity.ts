import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { Timesheet } from './timesheet.entity';

@Entity()
export class TimesheetEntry {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(type => Timesheet)
  timesheet: Timesheet;

  @Column({ type: 'double precision', nullable: true })
  hours: number;

  @Column({ type: 'date', nullable: true })
  entryDate: Date;

  @Column({ type: 'text', nullable: true })
  comments: string;

  @Column({ type: 'timestamp', nullable: true })
  dateCreated: Date;

  @Column({ type: 'timestamp', nullable: true })
  dateModified: Date;
}
