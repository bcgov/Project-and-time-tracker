import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class RfxPhase {

  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'text', nullable: true })
  rfxPhaseName: string;
}
