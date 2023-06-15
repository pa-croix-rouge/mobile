import 'package:form_field_validator/form_field_validator.dart';

class FieldValidators {
  static TextFieldValidator get usernameValidator => RequiredValidator(errorText: 'Username is required');

  static FieldValidator<dynamic> get emailValidator => MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Email is not valid')
  ]);

  static TextFieldValidator get passwordValidator => RequiredValidator(errorText: 'Password is required');
}