import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class STOB {

  @PrimaryGeneratedColumn()
  id: string;

  @Column({ type: 'text', nullable: true })
  stobName: string;

  @Column({ type: 'text', nullable: true })
  stobValue: string;
  
}
