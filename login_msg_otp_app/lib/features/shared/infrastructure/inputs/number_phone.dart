import 'package:formz/formz.dart';

enum PhoneNumberError { empty, invalidFormat }

class PhoneNumber extends FormzInput<String, PhoneNumberError> {

  const PhoneNumber.pure() : super.pure('+51');

  const PhoneNumber.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    
    if (displayError == PhoneNumberError.empty) return 'El campo es requerido';
    if (displayError == PhoneNumberError.invalidFormat) return 'El número de teléfono debe tener 9 dígitos';

    return null;
  }

  
  @override
  PhoneNumberError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return PhoneNumberError.empty;
    
    final phoneNumberDigits = value.replaceAll(RegExp(r'\D'), '');
    
    if (phoneNumberDigits.length != 9) return PhoneNumberError.invalidFormat;

    return null;
  }
}