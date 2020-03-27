import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { User } from './user.entity';

@Entity()
export class ProjectNote {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(type => User)
  user: User;

  @Column({ type: 'text', nullable: true })
  note: string;

  @Column({ type: 'text', nullable: true })
  projectId: string;

  @Column({ type: 'uuid', nullable: true })
  userId: string;

  @Column({ type: 'text', nullable: true })
  parentId: string;
  
  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP'})
  noteTime: string;



}
