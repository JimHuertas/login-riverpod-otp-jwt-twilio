import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:login_msg_otp_app/features/auth/domain/domain.dart';
import 'package:login_msg_otp_app/features/auth/infrastructure/infrastructure.dart';
import 'package:login_msg_otp_app/features/shared/shared.dart';


final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
      authRepository: authRepository,
      keyValueStorageService: keyValueStorageService);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageServiceImpl keyValueStorageService;

  AuthNotifier(
      {required this.authRepository, required this.keyValueStorageService})
      : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String numberPhone, String password) async {
    try {
      final user = await authRepository.login(numberPhone, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado');
    }
  }

  Future<void> registerUser(
      String email, int numberPhone, String password, String fullName) async {
    try {
      final user =
          await authRepository.register(email, numberPhone, password, fullName);
      _setRegisteredUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado $e');
    }
  }

  Future<String> sendSmsCode() async {
    final token = await keyValueStorageService.getValue<String>('token');
    try {
      final tokenSms = await authRepository.sendSmsCode(token!);
      return tokenSms;
    } on CustomError catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return 'error';
    } catch (e) {
      state = state.copyWith(errorMessage: 'error no controlado');
      return 'error';
    }
  }

  Future<void> phoneAuthenticator(String codeProvided, String tokenSMS) async {
    final token = await keyValueStorageService.getValue<String>('token');
    print("Token: $token\nCode: $codeProvided\ntokenSms: $tokenSMS");
    try {
      final user =
          await authRepository.validateToken(token!, codeProvided, tokenSMS);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    } catch (e) {
      state = state.copyWith(errorMessage: 'error no controlado $e');
    }
  }

  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    if (token == null) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  void _setRegisteredUser(User user) async {
    final bool isPhoneAuthenticated = user.isPhoneActive;
    AuthStatus authStatus = AuthStatus.authenticated;
    if (!isPhoneAuthenticated) {
      authStatus = AuthStatus.phoneNotAuthenticated;
    }
    await keyValueStorageService.setKeyValue('token', user.token);
    state = state.copyWith(
        user: user,
        authStatus: authStatus,
        errorMessage: "Registrado con exito");
  }

  void _setLoggedUser(User user) async {
    print(user);
    final bool isPhoneAuthenticated = user.isPhoneActive;
    AuthStatus authStatus = AuthStatus.authenticated;
    if (!isPhoneAuthenticated) {
      authStatus = AuthStatus.phoneNotAuthenticated;
    }
    await keyValueStorageService.setKeyValue('token', user.token);
    state = state.copyWith(
        user: user, authStatus: authStatus, errorMessage: "Logeado con exito");
  }

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorageService.removeKey('token');

    state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage);
  }
}

enum AuthStatus {
  checking,
  authenticated,
  notAuthenticated,
  phoneNotAuthenticated
}

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessage = ''});

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
          authStatus: authStatus ?? this.authStatus,
          user: user ?? this.user,
          errorMessage: errorMessage ?? this.errorMessage);
}
