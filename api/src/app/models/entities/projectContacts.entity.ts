import { Entity, PrimaryGeneratedColumn, ManyToOne } from 'typeorm';
import { Contact } from './contact.entity';
import { Project } from './project.entity';

@Entity()
export class ProjectContacts {

  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(type => Project)
  project: Project;

  @ManyToOne(type => Contact)
  contact: Contact;
}
