import 'dart:convert';

import 'package:pa_mobile/core/utils/encode.dart';

class FamilyMemberCreationRequest extends Encodable {
  FamilyMemberCreationRequest({
    required this.firstName,
    required this.lastName,
    required this.birthDate,
  });

  String firstName;
  String lastName;
  DateTime birthDate;

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
    };
  }

  @override
  String encode() {
    return jsonEncode(toJson());
  }
}
