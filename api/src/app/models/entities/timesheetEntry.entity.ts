import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { Timesheet } from './timesheet.entity';

@Entity()
export class TimesheetEntry {

  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(type => Timesheet)
  timesheet: Timesheet;

  @Column({ type: 'text', nullable: true })
  projectRfxId: string;

  @Column({ type: 'text', nullable: true })
  projectId: string;
  
  @Column({ type: 'text', nullable: true })
  rfxPhaseId: string;
  
  @Column({ type: 'uuid', nullable: true })
  userId: string;

  @Column({ type: 'double precision', nullable: true })
  hoursBilled: number;

  @Column({ type: 'date', nullable: true })
  entryDate: Date;
  
  @Column({ type: 'time', nullable: true })
  startTime: string;
  
  @Column({ type: 'time', nullable: true })
  endTime: string;
  
  @Column({ type: 'text', nullable: true })
  comments: string;

  @Column({ type: 'timestamp', nullable: true })
  dateCreated: Date;
  
  @Column({ type: 'timestamp', nullable: true })
  dateModified: Date;
}
