import { Controller, Get, Post, Body, Put, Delete, Param, ParseUUIDPipe, Req, BadRequestException } from '@nestjs/common';
import { AuthService } from './auth.service';
import { CreateUserDto, LoginUserDto, EditUserDto, CheckNumberDto } from './dto';
import { Auth, GetUser } from './decorators';
import { ValidRoles } from './interfaces';
import { User } from './entities/user.entity';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Get('test')
  justForTestConnection(){
    return "Conected successfuly";
  }

  @Post('register')
  createUser(@Body() createUserDto: CreateUserDto) {
    console.log(createUserDto);
    return this.authService.create(createUserDto);
  }

  @Post('login')
  loginUser(@Body() loginUserDto: LoginUserDto) {
    return this.authService.login(loginUserDto);
  }
  
  @Get('user')
  @Auth(ValidRoles.admin)
  getAllUsers(){
    return this.authService.getAllUsers();
  }

  @Get('user/:id')
  @Auth(ValidRoles.admin)
  getUserByID(@Param('id', ParseUUIDPipe) id: string){
    return this.authService.getUserById(id);
  }

  @Put('user/:id')
  @Auth(ValidRoles.admin)
  editUser(@Param('id', ParseUUIDPipe) id: string, @Body() editUserDto: EditUserDto){
    return this.authService.editUserById(id, editUserDto)
  }

  @Delete('user/:id')
  @Auth(ValidRoles.admin)
  deleteUser(@Param('id', ParseUUIDPipe) id: string){
    return this.authService.removeUserById(id)
  }

  @Get('check-status')
  @Auth()
  checkAuthStatus(
    @GetUser() user: User
  ) {
    return this.authService.checkAuthStatus( user );
  }

  //Authenticator Numberphone
  @Get('number-validator')
  @Auth(ValidRoles.seller)
  async numberValidator(@Req() req: any){
    if(req.user.isPhoneActive){
      console.log(req.user.isPhoneActive);
      throw new BadRequestException('Phone is already validated');
    }

    const response = await this.authService.createNumberTokenRequest(req.user.number);

    return response;
  }

  @Post('check-number')
  @Auth(ValidRoles.seller)
  checkNumber(@Req() req: any, @Body() checkNumberDto: CheckNumberDto){
    const { number } = req.user;
    return this.authService.verifyNumber(number, checkNumberDto);
  }

}



