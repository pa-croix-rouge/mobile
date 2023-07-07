import 'package:form_field_validator/form_field_validator.dart';

class FieldValidators {
  static FieldValidator<dynamic> get emailValidator => MultiValidator([
    RequiredValidator(errorText: 'Email est requis'),
    EmailValidator(errorText: 'Email n\'est pas valide'),
  ]);

  static FieldValidator<dynamic> get nameValidator => MultiValidator([
    RequiredValidator(errorText: 'Nom est requis'),
    MinLengthValidator(2, errorText: 'Un nom doit contenir au moins 2 caractères'),
    MaxLengthValidator(50, errorText: 'Un nom doit contenir au plus 50 caractères'),
  ]);

  static TextFieldValidator get passwordValidator => RequiredValidator(errorText: 'Mot de passe requis');


  static FieldValidator<dynamic> get phoneNumberValidator => MultiValidator([
    RequiredValidator(errorText: 'Numéro de téléphone requis'),
    MinLengthValidator(10, errorText: 'Un numéro de téléphone doit 10 chiffres'),
    MaxLengthValidator(10, errorText: 'Un numéro de téléphone doit 10 chiffres'),
  ]);

  static FieldValidator<dynamic> get socialWorkerNumberValidator => MultiValidator([
    RequiredValidator(errorText: 'Un numéro de travailleur social est requis'),
    MinLengthValidator(15, errorText: 'Un numéro de travailleur social doit contenir au moins 15 chiffres'),
    MaxLengthValidator(15, errorText: 'Un numéro de travailleur social doit contenir au plus 15 chiffres'),
  ]);
}