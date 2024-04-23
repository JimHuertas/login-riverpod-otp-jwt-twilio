import 'package:formz/formz.dart';

enum CodeVerificatorError { empty, invalidFormat }

class CodeVerificator extends FormzInput<String, CodeVerificatorError> {

  const CodeVerificator.pure() : super.pure('');

  const CodeVerificator.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    
    if (displayError == CodeVerificatorError.empty) return 'El campo es requerido';
    if (displayError == CodeVerificatorError.invalidFormat) return 'El código de verificación debe ser de 6 dígitos';

    return null;
  }

  
  @override
  CodeVerificatorError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return CodeVerificatorError.empty;
    
    final phoneNumberDigits = value.replaceAll(RegExp(r'\D'), '');
    
    if (phoneNumberDigits.length != 6) return CodeVerificatorError.invalidFormat;

    return null;
  }
}