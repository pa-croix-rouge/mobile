import 'dart:convert';

import 'package:pa_mobile/core/model/authentication/family_member_creation_request.dart';
import 'package:pa_mobile/core/utils/encode.dart';

class BeneficiaryCreationRequest extends Encodable {

  BeneficiaryCreationRequest({
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.localUnitCode,
    required this.birthDate,
    required this.socialWorkerNumber,
    required this.familyMembers,
  });

  String username;
  String? password;
  String firstName;
  String lastName;
  String phoneNumber;
  String localUnitCode;
  String birthDate;
  String socialWorkerNumber;
  List<FamilyMemberCreationRequest>? familyMembers;

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      if (password != null)
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'localUnitCode': localUnitCode,
      'birthDate': '${birthDate}T00:00:00.000Z',
      'socialWorkerNumber': socialWorkerNumber,
      if (familyMembers != null) 'familyMembers': familyMembers!.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String encode() {
    return jsonEncode(toJson());
  }
}
