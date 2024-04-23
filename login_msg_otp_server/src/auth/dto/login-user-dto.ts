import { IsNumber, IsString, MaxLength, MinLength } from "class-validator";

export class LoginUserDto {
    
    @IsNumber()
    number: number;

    @IsString()
    @MinLength(6)
    @MaxLength(50)
    password:string;
}
