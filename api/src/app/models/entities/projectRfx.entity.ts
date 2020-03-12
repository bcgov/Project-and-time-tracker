import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { Project } from './project.entity';
import { RfxPhase } from './rfxPhase.entity';
import { RfxType } from './rfxType.entity';

@Entity()
export class ProjectRfx {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(type => Project)
  project: Project;

  @ManyToOne(type => RfxType)
  rfxType: RfxType;

  @ManyToOne(type => RfxPhase)
  rfxPhase: RfxPhase;

  @Column({ type: 'text', nullable: true })
  rfxName: string;

  @Column({ type: 'text', nullable: true })
  rfxOverview: string;

  @Column({ type: 'text', nullable: true })
  clientResponsibilities: string;

  @Column({ type: 'text', nullable: true })
  psdResponsibilities: string;

  @Column({ type: 'timestamp', nullable: true })
  dateCreated: Date;

  @Column({ type: 'timestamp', nullable: true })
  dateModified: Date;
}
