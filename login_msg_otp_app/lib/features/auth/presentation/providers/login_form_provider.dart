import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import 'auth_provider.dart';
import 'package:login_msg_otp_app/features/shared/shared.dart';

//! 3 - StateNotifierProvider - consume afuera
final loginFormProvider =StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;
  return LoginFormNotifier(loginUserCallback: loginUserCallback);
});

//! 2 - Como implementamos un notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Function(String, String) loginUserCallback;

  LoginFormNotifier({
    required this.loginUserCallback,
  }) : super(LoginFormState());

  onNumberPhoneChange(String value) {
    final phoneNumber = PhoneNumber.dirty(value);
    state = state.copyWith(
      phoneNumber: phoneNumber,
      isValid: Formz.validate([phoneNumber, state.password]));
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([state.phoneNumber, newPassword]));
  }

  onFormSubmit() async {
    _touchEveryField();
    
    if (!state.isValid) return;
    state = state.copyWith(isPosting: true);
    await loginUserCallback(state.phoneNumber.value, state.password.value);
    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final phoneNumber = PhoneNumber.dirty(state.phoneNumber.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
        isFormPosted: true,
        phoneNumber: phoneNumber,
        password: password,
        isValid: Formz.validate([phoneNumber, password]));
  }
}

//! 1 - State del provider
class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final PhoneNumber phoneNumber;
  final Password password;

  LoginFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.phoneNumber = const PhoneNumber.pure(),
      this.password = const Password.pure()});

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    PhoneNumber? phoneNumber,
    Password? password,
  }) =>
      LoginFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        password: password ?? this.password,
      );

  @override
  String toString() {
    return '''
  LoginFormState:
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    phoneNumber: $phoneNumber
    password: $password
''';
  }
}
