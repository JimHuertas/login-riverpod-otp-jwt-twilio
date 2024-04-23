import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import 'auth_provider.dart';
import 'package:login_msg_otp_app/features/shared/shared.dart';

//! 3 - StateNotifierProvider - consume afuera
final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;

  return RegisterFormNotifier(registerUserCallback: registerUserCallback);
});

//! 2 - Como implementamos un notifier
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String, int, String, String) registerUserCallback;

  RegisterFormNotifier({
    required this.registerUserCallback,
  }) : super(RegisterFormState());

  onFullNameChange(String fullName) {
    state = state.copyWith(fullName: fullName);
  }

  onNumberPhoneChange(String value) {
    final newPhoneNumber = PhoneNumber.dirty(value);
    state = state.copyWith(
        phoneNumber: newPhoneNumber,
        isValid: Formz.validate([
          newPhoneNumber,
          state.password,
          state.email,
          state.rewritedPassword
        ]));
  }

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail,
        isValid: Formz.validate([
          newEmail,
          state.password,
          state.phoneNumber,
          state.rewritedPassword
        ]));
  }

  onPasswordChange(String value) {
    final newPassword = ValidatePassword.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([
          newPassword,
          state.phoneNumber,
          state.email,
          state.rewritedPassword
        ]));
  }

  onConfirmPasswordChange(String value) {
    final newConfirmPassword = ValidatePassword.dirty(value);
    state = state.copyWith(
        rewritedPassword: newConfirmPassword,
        isValid: Formz.validate([
          newConfirmPassword,
          state.phoneNumber,
          state.email,
          state.password
        ]));
  }

  onConfirmPassword(String value) {
    final newConfirmPassword = value;
    if (state.password.value == newConfirmPassword) {
      state = state.copyWith(isPasswordsEquals: true);
    } else {
      state = state.copyWith(isPasswordsEquals: false);
    }
  }

  confirmPhone() {
    state = state.copyWith(confirmedPhone: true);
  }

  onFormSubmit() async {
    _touchEveryField();

    if (!state.isValid) return;
    if (!state.confirmedPhone) return;
    state = state.copyWith(
      isPosting: true
    );

    final response = await registerUserCallback(
        state.email.value,
        int.parse(state.phoneNumber.value),
        state.password.value,
        state.fullName);
        
    if (response == "error") {
      state = state.copyWith(
        confirmedPhone: false,
        isPosting: false
      );
    }
  }

  _touchEveryField() {
    final phoneNumber = PhoneNumber.dirty(state.phoneNumber.value);
    final email = Email.dirty(state.email.value);
    final password = ValidatePassword.dirty(state.password.value);
    final rewritedPassword =
        ValidatePassword.dirty(state.rewritedPassword.value);

    state = state.copyWith(
        isFormPosted: true,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
        rewritedPassword: rewritedPassword,
        isPasswordsEquals: (password == rewritedPassword),
        isValid:
            Formz.validate([phoneNumber, password, email, rewritedPassword]));
  }
}

//! 1 - State del provider
class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final bool isPasswordsEquals;
  final bool confirmedPhone;
  final String fullName;
  final PhoneNumber phoneNumber;
  final Email email;
  final ValidatePassword password;
  final ValidatePassword rewritedPassword;

  RegisterFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.confirmedPhone = false,
      this.isValid = false,
      this.isPasswordsEquals = false,
      this.fullName = '',
      this.email = const Email.pure(),
      this.phoneNumber = const PhoneNumber.pure(),
      this.password = const ValidatePassword.pure(),
      this.rewritedPassword = const ValidatePassword.pure()});

  RegisterFormState copyWith(
          {bool? isPosting,
          bool? isFormPosted,
          bool? isValid,
          bool? isPasswordsEquals,
          bool? confirmedPhone,
          String? fullName,
          Email? email,
          PhoneNumber? phoneNumber,
          ValidatePassword? password,
          ValidatePassword? rewritedPassword}) =>
      RegisterFormState(
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isValid: isValid ?? this.isValid,
          confirmedPhone: confirmedPhone ?? this.confirmedPhone,
          isPasswordsEquals: isPasswordsEquals ?? this.isPasswordsEquals,
          fullName: fullName ?? this.fullName,
          email: email ?? this.email,
          phoneNumber: phoneNumber ?? this.phoneNumber,
          password: password ?? this.password,
          rewritedPassword: rewritedPassword ?? this.rewritedPassword);

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
