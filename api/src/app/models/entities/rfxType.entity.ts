import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class RfxType {

  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'text', nullable: true })
  rfxTypeName: string;
}
