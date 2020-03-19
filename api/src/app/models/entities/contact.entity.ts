import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class Contact {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'text', nullable: true })
  contactType: ContactType;

  @Column({ type: 'text', nullable: true })
  fullName: string;

  @Column({ type: 'text', nullable: true })
  orgName: string;

  @Column({ type: 'text', nullable: true })
  orgPosition: string;

  @Column({ type: 'text', nullable: true })
  email: string;

  @Column({ type: 'text', nullable: true })
  phoneNumber: string;

  @Column({ type: 'text', nullable: true })
  addressLine1: string;

  @Column({ type: 'text', nullable: true })
  addressLine2: string;

  @Column({ type: 'text', nullable: true })
  city: string;

  @Column({ type: 'text', nullable: true })
  province: string;

  @Column({ type: 'text', nullable: true })
  country: string;

  @Column({ type: 'text', nullable: true })
  postalCode: string;

  @Column({ type: 'timestamp', nullable: true })
  dateCreated: Date;

  @Column({ type: 'timestamp', nullable: true })
  dateModified: Date;

  // Used only for "user" types (psb specialist, legal, etc)
  // Client contacts will not have a rate.
  @Column({ type: 'int', nullable: true })
  hourlyRate: number;
}

export type ContactType = 'clientlead' | 'clientsponsor' | 'clientcontact' | 'user';
