import 'package:dio/dio.dart';

import 'package:login_msg_otp_app/config/constants/environment.dart';
import 'package:login_msg_otp_app/features/auth/domain/domain.dart';
import 'package:login_msg_otp_app/features/auth/infrastructure/infrastructure.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiAuth,
  ));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/auth/check-status',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ));

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('No Autorizado');
      }
      throw Exception('ERROR? $e');
    } catch (e) {
      throw Exception('Error Desconocido: $e');
    }
  }

  @override
  Future<User> login(String numberPhone, String password) async {
    try {
      final passwordInt = int.parse(numberPhone);

      final response = await dio.post('/auth/login',
          data: {'number': passwordInt, 'password': password});
      final user = UserMapper.userJsonToEntity(response.data);
      
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales incorrectas');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception('ERROR? $e');
    } catch (e) {
      throw Exception('Error Desconocido: $e');
    }
  }

  @override
  Future<User> register(
      String email, int numberPhone, String password, String fullName) async {
    try {
      final response = await dio.post('/auth/register', data: {
        'number': numberPhone,
        'email': email,
        'password': password,
        'fullName': fullName,
      });
      print(response);
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales incorrectas');
      }
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales incorrectas');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception('ERROR? $e');
    } catch (e) {
      throw Exception('Error Desconocido: $e');
    }
  }

  @override
  Future<String> sendSmsCode(String token) async {
    try {
      final response = await dio.get('/auth/number-validator',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ));
      final tokenSms = response.data["token"];
      return tokenSms;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales incorrectas');
      }
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales incorrectas');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception('ERROR? $e');
    } catch (e) {
      throw Exception('Error Desconocido: $e');
    }
  }

  @override
  Future<User> validateToken(String token, String code, String tokenSMS) async {
    try {
      final response = await dio.post('/auth/check-number',
          data: {'code': code, 'token': tokenSMS},
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ));
      final user = UserMapper.userJsonToEntity(response.data["user"]);
      print(response);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw CustomError('Codigos No Coinciden');
      }
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales incorrectas');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception('ERROR? $e');
    } catch (e) {
      throw Exception('Error Desconocido: $e');
    }
  }
}
