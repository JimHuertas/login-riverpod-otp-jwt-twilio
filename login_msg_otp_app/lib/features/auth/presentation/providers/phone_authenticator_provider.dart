import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import 'auth_provider.dart';
import 'package:login_msg_otp_app/features/shared/shared.dart';


//! 3 - StateNotifierProvider - consume afuera
final phoneAuthenticatorProvider = StateNotifierProvider.autoDispose<
    PhoneAuthenticatorNotifier, PhoneAuthenticatorState>((ref) {
  final phoneAuthenticatorUserCallback =
      ref.watch(authProvider.notifier).phoneAuthenticator;
  final sendSMSCallBack = ref.watch(authProvider.notifier).sendSmsCode;
  return PhoneAuthenticatorNotifier(
      phoneAuthenticatorUserCallback: phoneAuthenticatorUserCallback,
      sendSMSCallBack: sendSMSCallBack);
});

//! 2 - Como implementamos un notifier
class PhoneAuthenticatorNotifier
    extends StateNotifier<PhoneAuthenticatorState> {
  final Function(String, String) phoneAuthenticatorUserCallback;
  final Function() sendSMSCallBack;

  PhoneAuthenticatorNotifier(
      {required this.phoneAuthenticatorUserCallback,
      required this.sendSMSCallBack})
      : super(PhoneAuthenticatorState());

  get keyValueStorageService => null;

  onCodeChange(String value) {
    final newCodeProvided = CodeVerificator.dirty(value);
    print(newCodeProvided.errorMessage);
    state = state.copyWith(
        codeSMSVerificator: newCodeProvided,
        isValid: Formz.validate([newCodeProvided]));
  }

  sendMsm() async {
    print(state);
    final tokenSms = await sendSMSCallBack();
    state = state.copyWith(tokenSMS: tokenSms, isCodeSMSsended: true);
  }

  _touchEveryField() {
    final codeSMS = CodeVerificator.dirty(state.codeSMSVerificator.value);
    final tokenSms = state.tokenSMS;

    state = state.copyWith(
        isFormPosted: true,
        codeSMSVerificator: codeSMS,
        tokenSMS: tokenSms,
        isValid: Formz.validate([codeSMS]));
  }

  onFormSubmit() async {
    _touchEveryField();

    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);
    phoneAuthenticatorUserCallback(
        state.codeSMSVerificator.value, state.tokenSMS);
    state = state.copyWith(isPosting: false);
  }
}

//! 1 - State del provider
class PhoneAuthenticatorState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final bool isCodeSMSsended;
  final CodeVerificator codeSMSVerificator;
  final String tokenSMS;

  PhoneAuthenticatorState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isCodeSMSsended = false,
    this.isValid = false,
    this.codeSMSVerificator = const CodeVerificator.pure(),
    this.tokenSMS = "",
  });

  PhoneAuthenticatorState copyWith(
          {bool? isPosting,
          bool? isFormPosted,
          bool? isValid,
          bool? isCodeSMSsended,
          CodeVerificator? codeSMSVerificator,
          String? tokenSMS}) =>
      PhoneAuthenticatorState(
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isValid: isValid ?? this.isValid,
          isCodeSMSsended: isCodeSMSsended ?? this.isCodeSMSsended,
          codeSMSVerificator: codeSMSVerificator ?? this.codeSMSVerificator,
          tokenSMS: tokenSMS ?? this.tokenSMS);

  @override
  String toString() {
    return '''
      PhoneAuthenticatorState:
        isPosting: $isPosting;
        isFormPosted: $isFormPosted;
        isValid: $isValid;
        codeSMSVerificator: $codeSMSVerificator
        tokenJWT: $tokenSMS
    ''';
  }
}
