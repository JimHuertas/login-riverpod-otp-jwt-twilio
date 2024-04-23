import { Column, Entity, PrimaryGeneratedColumn } from "typeorm";

@Entity()
export class User {
    
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column('integer', {
        unique: true
    })
    number: number;

    @Column('text', {})
    email: string

    @Column('text', {
        select: false
    })
    password: string;

    @Column('text')
    fullName: string;

    @Column('bool', {
        default: true
    })
    isActive: boolean;

    @Column('bool', {
        default: false
    })
    isPhoneActive: boolean;

    @Column('text', {
        array: true,
        default: ['seller']
    })
    roles: string[];

}
