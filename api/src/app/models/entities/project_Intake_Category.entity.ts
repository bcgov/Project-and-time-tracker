import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class ProjectIntakeCategory {

    @PrimaryGeneratedColumn('uuid')
    id: string;
    
    @Column({ type: 'text' })
    projectIntakeCategoryName: string;
}
