import { IsString, Length } from "class-validator";

export class CheckNumberDto {
    
    @IsString()
    @Length(6, 6, { message: 'El código debe tener exactamente 6 dígitos' })
    code: string;

    @IsString()
    token: string;
    
}
