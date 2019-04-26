import { Entity, PrimaryGeneratedColumn, ManyToOne } from 'typeorm';
import { Document } from './document.entity';

@Entity()
export class ProjectDocuments {

    @PrimaryGeneratedColumn('uuid')
    id: string;  

    @ManyToOne(type => Document)
    document: Document;    
}
