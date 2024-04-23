import { BadRequestException, Injectable, InternalServerErrorException, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import * as bcrypt from 'bcrypt';

import { User } from './entities/user.entity';
import { CheckNumberDto, CreateUserDto, EditUserDto, LoginUserDto } from './dto';
import { NumberTokenService } from './providers/numberToken.service';

import { JwtPayload } from './interfaces/jwt-payload.interface';
import { JwtService } from '@nestjs/jwt';
import { isUUID } from 'class-validator';
import { TwilioService } from './providers/twilio.service';

@Injectable()
export class AuthService {

  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    private readonly jwtService: JwtService,
    private readonly numberJwtService: NumberTokenService,
    private readonly twilioService: TwilioService,
  ){}

  async checkAuthStatus( user: User ){

    return {
      ...user,
      token: this.getJwtToken({ id: user.id})
    };

  }

  async create(createUserDto: CreateUserDto) {

    try {
      const {password, ...userData} = createUserDto;

      if (userData.email) {
        const email = userData.email;
        const existingUser = await this.userRepository.findOne({ where: {email}  });
        if (existingUser) {
          throw new Error('El correo electrónico ya está registrado');
        }
      }

      const user = this.userRepository.create({
        ...userData,
        password: bcrypt.hashSync(password, 10)
      });
      await this.userRepository.save( user );

      return {
        ...user,
        token: this.getJwtToken({ 
          id: user.id
        })
      };
    } catch (e) {
      this.handleDBErrors(e);
    }
  }

  async login(loginUserDto : LoginUserDto){
    const {number, password} = loginUserDto;
    const user = await this.userRepository.findOne({
      where: {number},
      select: {number:true, email: true, password:true, fullName: true, id:true, roles:true, isActive:true, isPhoneActive: true}
    });
    
    if( !user ){
      throw new UnauthorizedException('Credentials are not valid (email)');
    }
    if (!bcrypt.compareSync(password, user.password))
      throw new UnauthorizedException('Credentials are not valid (password)')

    // if(!user.isPhoneActive){
    //   throw new UnauthorizedException('Phone number needs to be verified! :C');
    // }

    
    return {
      id: user.id,
      number: user.number,
      email: user.email,
      fullName: user.fullName,
      isPhoneActive: user.isPhoneActive,
      isActive: user.isActive,
      roles: user.roles,
      token: this.getJwtToken({ 
        id: user.id,
      })
    };
  }

  async getAllUsers(){
    return await this.userRepository.find();
  }

  async getUserById(id: string){
    let user: User

    if( isUUID(id) ){
      const user = await this.userRepository.findOneBy({id: id})
      return user;
    }
    if(!user){
      throw new NotFoundException(`User with id: ${id} not found`)
    }
  }

  async editUserById(id:string, editUserDto: EditUserDto){
    if(id === 'ddc6c9d7-2124-4c26-a8bc-208192a9552e'){
      throw new UnauthorizedException('This user can\'t be modified');
    }

    const userData = editUserDto;
    
    let user = await this.userRepository.findOne({
      where: {id},
      select: { number: true, email: true, fullName: true, password: true, id:true, roles:true}
    });

    if( !user ){
      throw new NotFoundException(`User with id: ${id} not found`)
    }

    Object.assign(user, userData);

    user = await this.userRepository.save(user);

    return user;
  }

  async removeUserById(id:string){
    if(id === '92bec9bb-c6d3-442b-84fc-3aedf50bfd3e'){
      throw new UnauthorizedException('This user can\'t be deleted');
    }
    const user: User = await this.getUserById(id)
    if(!user){
      throw new NotFoundException(`User with id: ${id} not found`)
    }
    
    await this.userRepository.remove(user);
    return {
      messsage: `User with id: ${id} removed`
    }
    
  }

  async createNumberTokenRequest( numberPhone: number ) {
    const numberToken = this.numberJwtService.generateToken();
    
    const code = this.numberJwtService.getCodePhone(numberToken);
    
    const msg = await this.twilioService.sendMSM(numberPhone, code);

    return {token: numberToken, message: msg};
  }

  async verifyNumber(numberPhone: number, checkNumberDto: CheckNumberDto){
    console.log("Entro al request :c ");
    //validate if phone is already activated
    const isInactivePhone = await this.existsInactiveUserByNumber(numberPhone);
    if(!isInactivePhone){
      throw new BadRequestException('This phone number is already valiated');
    }
    
    //validated if phone is registered with the user provided
    const validInactiveUserNumber = await this.existsInactiveUserByNumber(numberPhone);
    if(!validInactiveUserNumber){
      throw new BadRequestException('Number provided is not user\'s phone');
    }
    
    //validate the code provided by user and compare with the real code
    const isValid = this.numberJwtService.verifyToken( checkNumberDto );
    if(isValid){
      console.log("Verificado");
      const user = await this.activatePhoneByNumber( numberPhone );
      console.log(user);
      return {
        user: user,
        status: "OK",
        msg: "Success! The provided code matches the expected value."
      }
    }
  }

  private async existsInactiveUserByNumber(number: number){
    const user = await this.userRepository.findOne({ where: { number, isPhoneActive: false } });
    return !!user;
  }

  private async activatePhoneByNumber(number: number){
    const user = await this.userRepository.findOne({ where: { number } });
    if (!user) {
        throw new NotFoundException(`None user found with number ${number}`);
    }
    user.isPhoneActive = true;
    const newUser = await this.userRepository.save(user);
    return {
      ...newUser,
      token: this.getJwtToken({id: newUser.id})
    }
}

  private getJwtToken(payload: JwtPayload){
    const token = this.jwtService.sign( payload );
    return token;
  }

  private handleDBErrors(e: any): never{
    if (e.code === '23505')
      throw new BadRequestException(e.detail);
    throw new InternalServerErrorException('Please check server logs');
  }
}
