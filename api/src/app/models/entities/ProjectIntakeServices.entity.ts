import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class ProjectIntakeServices {

    @PrimaryGeneratedColumn('uuid')
    id: string;
    
    @Column({ type: 'text' })
    projectIntakeServiceName: string;
}
