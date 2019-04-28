import { Entity, PrimaryGeneratedColumn, ManyToOne } from 'typeorm';
import { Contact } from './contact.entity';
import { ProjectIntake } from './projectIntake.entity';

@Entity()
export class ProjectIntakeContacts {

  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(type => ProjectIntake)
  projectIntake: ProjectIntake;

  @ManyToOne(type => Contact)
  contact: Contact;
}
