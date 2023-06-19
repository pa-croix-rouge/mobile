import 'dart:ffi';

import 'package:pa_mobile/core/utils/encode.dart';

class BeneficiaryResponseDto {
  BeneficiaryResponseDto(this.username, this.firstName, this.lastName,
      this.phoneNumber, this.isValidated, this.localUnitId);

  final String username;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final bool isValidated;
  final int localUnitId;

  static BeneficiaryResponseDto decode(String jsonObject) {
    final username = EncodeTools.decodeString(jsonObject, 'username');
    final firstName = EncodeTools.decodeString(jsonObject, 'firstName');
    final lastName = EncodeTools.decodeString(jsonObject, 'lastName');
    final phoneNumber = EncodeTools.decodeString(jsonObject, 'phoneNumber');
    final isValidated = EncodeTools.decodeBool(jsonObject, 'isValidated');
    final localUnitId = EncodeTools.decodeInt(jsonObject, 'localUnitId');
    return BeneficiaryResponseDto(
      username,
      firstName,
      lastName,
      phoneNumber,
      isValidated,
      localUnitId,
    );
  }
}
