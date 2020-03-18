import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { Ministry } from './ministry.entity';

@Entity()
export class Client {
  @PrimaryGeneratedColumn('uuid')
  id: string;

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

  @ManyToOne(type => Ministry)
  ministry: Ministry;

  @Column({ type: 'text', nullable: true })
  orgDivision: string;

  @Column({ type: 'text', nullable: true })
  email: string;

  @Column({ type: 'text' })
  addressLine1: string;

  @Column({ type: 'text', nullable: true })
  addressLine2: string;

  @Column({ type: 'text' })
  city: string;

  @Column({ type: 'text', nullable: true })
  province: string;

  @Column({ type: 'text', nullable: true })
  country: string;

  @Column({ type: 'text' })
  postalCode: string;

  @Column({ type: 'timestamp', nullable: true })
  dateCreated: Date;

  @Column({ type: 'timestamp', nullable: true })
  dateModified: Date;

  @Column({ type: 'boolean', nullable: true })
  isNonMinistry: boolean;

  @Column({ type: 'text', nullable: true })
  nonMinistryName: string;
}
