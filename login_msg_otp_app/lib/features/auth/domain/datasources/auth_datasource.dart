import '../entities/user.dart';

abstract class AuthDataSource {
  Future<User> login(String numberPhone, String password);
  Future<User> register(String email, int numberPhone, String password, String fullName);
  Future<String> sendSmsCode(String token);
  Future<User> validateToken(String token, String code, String tokenSMS);
  Future<User> checkAuthStatus(String token);
}
