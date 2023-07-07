import 'dart:ffi';

import 'package:pa_mobile/core/utils/encode.dart';

class BeneficiaryResponseDto {
  BeneficiaryResponseDto(
    this.id,
    this.birthDate,
    this.username,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.isValidated,
    this.localUnitId,
    this.solde,
  );

  final int id;
  final String birthDate;
  final String username;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final bool isValidated;
  final int localUnitId;
  final int solde;

  static BeneficiaryResponseDto decode(String jsonObject) {
    final id = EncodeTools.decodeInt(jsonObject, 'id');
    final birthDate = EncodeTools.decodeString(jsonObject, 'birthDate');
    final username = EncodeTools.decodeString(jsonObject, 'username');
    final firstName = EncodeTools.decodeString(jsonObject, 'firstName');
    final lastName = EncodeTools.decodeString(jsonObject, 'lastName');
    final phoneNumber = EncodeTools.decodeString(jsonObject, 'phoneNumber');
    final isValidated = EncodeTools.decodeBool(jsonObject, 'isValidated');
    final localUnitId = EncodeTools.decodeInt(jsonObject, 'localUnitId');
    final solde = EncodeTools.decodeInt(jsonObject, 'solde');
    return BeneficiaryResponseDto(
      id,
      birthDate,
      username,
      firstName,
      lastName,
      phoneNumber,
      isValidated,
      localUnitId,
      solde,
    );
  }
}
