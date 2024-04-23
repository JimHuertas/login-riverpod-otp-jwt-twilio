import { BadRequestException, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

import * as jwt from 'jsonwebtoken';
import * as randToken from 'rand-token';
import { CheckNumberDto } from '../dto';

@Injectable()
export class NumberTokenService {
  constructor(private readonly configService: ConfigService) {}

  generateToken(): string {
    const secretKey = this.configService.get('JWT_SECRET');
    const numericToken = randToken.generate(6, '123456789');
    return jwt.sign({ token: numericToken }, secretKey, { expiresIn: '1m' });//1m
  }

  verifyToken(checkNumberDto: CheckNumberDto){
    const secretKey = this.configService.get('JWT_SECRET');

    //verify if token expired
    try {
      jwt.verify(checkNumberDto.token, secretKey, { ignoreExpiration: false });
    } catch (e) {
      if (e instanceof jwt.TokenExpiredError) {
        throw new BadRequestException('Token expired (out of time)');
      }
    }

    const codeProvidedByUser = checkNumberDto.code;
    const { token } = jwt.verify(checkNumberDto.token, secretKey) as any;
    console.log("Codigo del usuario: ", codeProvidedByUser, "\nCodigo real: ", token);
    
    if(codeProvidedByUser === token){
      return true;
    }
    
    throw new BadRequestException('Token inválido');
  }

  getCodePhone(token: string): number{
    const secretKey = this.configService.get('JWT_SECRET');
    const decodedToken = jwt.verify(token, secretKey) as { token: string };
    return +decodedToken.token;
  }

}