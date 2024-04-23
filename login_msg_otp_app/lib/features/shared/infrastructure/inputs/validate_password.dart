import 'package:formz/formz.dart';

// Define input validation errors
enum ValidPasswordError { empty, length, format }

// Extend FormzInput and provide the input type and error type.
class ValidatePassword extends FormzInput<String, ValidPasswordError> {


  static final RegExp passwordRegExp = RegExp(
    r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$',
  );

  // Call super.pure to represent an unmodified form input.
  const ValidatePassword.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const ValidatePassword.dirty( String value ) : super.dirty(value);


  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == ValidPasswordError.empty ) return 'El campo es requerido';
    if ( displayError == ValidPasswordError.length ) return 'Mínimo 6 caracteres';
    if ( displayError == ValidPasswordError.format ) return 'Debe de tener Mayúscula, letras y un número';

    return null;
  }


  // Override validator to handle validating a given input value.
  @override
  ValidPasswordError? validator(String value) {

    if ( value.isEmpty || value.trim().isEmpty ) return ValidPasswordError.empty;
    if ( value.length < 6 ) return ValidPasswordError.length;
    if ( !passwordRegExp.hasMatch(value) ) return ValidPasswordError.format;

    return null;
  }
}