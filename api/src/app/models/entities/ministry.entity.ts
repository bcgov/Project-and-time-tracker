import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class Ministry {

  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'text', nullable: true })
  ministryName: string;

  @Column({ type: 'boolean', nullable: true })
  is_archived: Boolean;
}
