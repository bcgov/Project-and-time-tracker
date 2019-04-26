import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class Document {

    @PrimaryGeneratedColumn('uuid')
    id: string;  

    @Column({ type: 'text', nullable: true })
    fileName: string;
    
    @Column({ type: 'text', nullable: true })
    mimeType: string;
    
    @Column({ type: 'bytea', nullable: true })
    data?: Buffer;
    
    @Column({ type: 'int', nullable: true })
    version: number;
    
    @Column({ type: 'timestamp', nullable: true })
    dateCreated: Date;
    
    @Column({ type: 'timestamp', nullable: true })
    dateModified: Date;
}
