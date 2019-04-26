import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class ProjectSector {

    @PrimaryGeneratedColumn('uuid')
    id: string;
    
    @Column({ type: 'text' })
    projectSectorName: string;
}
