import 'dart:convert';

import 'package:pa_mobile/core/utils/encode.dart';

class LoginResponseDto {
  LoginResponseDto({required this.jwtToken});

  String jwtToken;

  static LoginResponseDto decode(String jsonObject) {
    final token = utf8.decode(EncodeTools.decodeString(jsonObject, 'jwtToken').runes.toList());
    return LoginResponseDto(jwtToken: token);
  }
}
