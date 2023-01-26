import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class MOU {
  @PrimaryGeneratedColumn()
  id: string;

  @Column({ type: 'text', nullable: false })
  name: string;

  @Column({ type: 'int', nullable: true })
  billingCount: number;
}
