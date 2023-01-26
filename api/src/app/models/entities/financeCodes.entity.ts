import { Entity, PrimaryGeneratedColumn, Column,OneToMany } from 'typeorm';
import { Contact } from './contact.entity';

@Entity()
export class FinanceCodes {
  @PrimaryGeneratedColumn()
  id: string;

  @Column({ type: 'text', nullable: true })
  financeName: string;

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

  @OneToMany(type => Contact, contact => contact.financeCodes)
  contacts: Contact[];

}
