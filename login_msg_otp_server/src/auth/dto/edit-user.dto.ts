import { IsArray, IsBoolean, IsEmail, IsNumber, IsOptional, IsString} from "class-validator";

export class EditUserDto {
    
    @IsOptional()
    @IsString()
    id?: string;

    @IsOptional()
    @IsNumber()
    number: number

    @IsOptional()
    @IsEmail()
    email?: string;

    @IsOptional()
    @IsString()
    fullName?: string;

    @IsOptional()
    @IsString()
    password?: string;

    @IsOptional()
    @IsBoolean()
    isActive?: boolean;

    @IsOptional()
    @IsArray()
    @IsString({ each: true })
    roles?: string[];
}