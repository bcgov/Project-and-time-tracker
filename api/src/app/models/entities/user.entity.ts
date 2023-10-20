import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { Contact } from './contact.entity';

@Entity()
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'text', unique: true })
  referenceId: string;
  
  @ManyToOne(type => Contact, { nullable: true })
  contact: Contact;

  @Column({ type: 'text', nullable: true })
  role: string;

  @Column({ type: 'boolean', nullable: true })
  isActive: boolean;
}
