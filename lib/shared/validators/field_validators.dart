import 'package:form_field_validator/form_field_validator.dart';

class FieldValidators {
  static TextFieldValidator get pseudoValidator => RequiredValidator(errorText: 'Name is required');

  static FieldValidator<dynamic> get emailValidator => MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Email is not valid')
  ]);

  static TextFieldValidator get passwordValidator => RequiredValidator(errorText: 'Password is required');
}