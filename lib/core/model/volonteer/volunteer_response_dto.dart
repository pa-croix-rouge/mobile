import 'dart:ffi';

import 'package:pa_mobile/core/utils/encode.dart';

class VolunteerResponseDto {
  VolunteerResponseDto(this.id, this.username, this.firstName, this.lastName,
      this.phoneNumber, this.isValidated, this.localUnitId);

  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final bool isValidated;
  final int localUnitId;

  static VolunteerResponseDto decode(String jsonObject) {
    final id = EncodeTools.decodeInt(jsonObject, 'id');
    final username = EncodeTools.decodeString(jsonObject, 'username');
    final firstName = EncodeTools.decodeString(jsonObject, 'firstName');
    final lastName = EncodeTools.decodeString(jsonObject, 'lastName');
    final phoneNumber = EncodeTools.decodeString(jsonObject, 'phoneNumber');
    final isValidated = EncodeTools.decodeBool(jsonObject, 'isValidated');
    final localUnitId = EncodeTools.decodeInt(jsonObject, 'localUnitId');
    return VolunteerResponseDto(
      id,
      username,
      firstName,
      lastName,
      phoneNumber,
      isValidated,
      localUnitId,
    );
  }
}
