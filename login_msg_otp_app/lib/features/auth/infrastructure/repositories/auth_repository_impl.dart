import 'package:login_msg_otp_app/features/auth/domain/domain.dart';
import 'package:login_msg_otp_app/features/auth/infrastructure/infrastructure.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl({AuthDataSource? dataSource})
      : dataSource = dataSource ?? AuthDataSourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<String> sendSmsCode(String token) {
    return dataSource.sendSmsCode(token);
  }

  @override
  Future<User> login(String numberPhone, String password) {
    return dataSource.login(numberPhone, password);
  }

  @override
  Future<User> register(
      String email, int numberPhone, String password, String fullName) {
    return dataSource.register(email, numberPhone, password, fullName);
  }

  @override
  Future<User> validateToken(String token, String code, String tokenSMS) {
    return dataSource.validateToken(token, code, tokenSMS);
  }
}
