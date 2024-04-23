import 'package:login_msg_otp_app/features/auth/domain/domain.dart';

class UserMapper {

  static User userJsonToEntity( Map<String,dynamic> json ) => User(
    id: json['id'],
    numberPhone: json['number'],
    email: json['email'],
    fullName: json['fullName'],
    isPhoneActive: json['isPhoneActive'],
    isActive: json['isActive'],
    roles: List<String>.from(json['roles'].map( (role) => role )),
    token: json['token']
  );

}