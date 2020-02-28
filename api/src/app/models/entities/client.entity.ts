import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { Ministry } from './ministry.entity';

@Entity()
export class Client {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'int', nullable: true })
  clientNo: number;

  @Column({ type: 'int', nullable: true })
  responsibilityCenter: number;

  @Column({ type: 'int', nullable: true })
  serviceCenter: number;

  @Column({ type: 'int', nullable: true })
  stob: number;

  @Column({ type: 'int', nullable: true })
  projectCode: number;

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
  isMinistry: boolean;
}
