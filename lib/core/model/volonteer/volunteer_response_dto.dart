import 'dart:convert';
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
    final username = utf8.decode(EncodeTools.decodeString(jsonObject, 'username').runes.toList());
    final firstName = utf8.decode(EncodeTools.decodeString(jsonObject, 'firstName').runes.toList());
    final lastName = utf8.decode(EncodeTools.decodeString(jsonObject, 'lastName').runes.toList());
    final phoneNumber = utf8.decode(EncodeTools.decodeString(jsonObject, 'phoneNumber').runes.toList());
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
