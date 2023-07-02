import 'package:form_field_validator/form_field_validator.dart';

class FieldValidators {
  static FieldValidator<dynamic> get usernameValidator => MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Email is not valid'),
  ]);

  static FieldValidator<dynamic> get emailValidator => MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Email is not valid'),

  ]);

  static TextFieldValidator get passwordValidator => RequiredValidator(errorText: 'Password is required');

  static FieldValidator<dynamic> get phoneNumberValidator => MultiValidator([
    RequiredValidator(errorText: 'Phone number is required'),
    MinLengthValidator(10, errorText: 'Phone number must be at least 10 digits long'),
    MaxLengthValidator(10, errorText: 'Phone number must be at most 10 digits long'),
  ]);

  static FieldValidator<dynamic> get socialWorkerNumberValidator => MultiValidator([
    RequiredValidator(errorText: 'Social worker number is required'),
    MinLengthValidator(15, errorText: 'Social worker number must be at least 15 digits long'),
    MaxLengthValidator(15, errorText: 'Social worker number must be at most 15 digits long'),
  ]);
}