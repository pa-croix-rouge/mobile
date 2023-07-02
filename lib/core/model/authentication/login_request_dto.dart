import 'dart:convert';

import 'package:pa_mobile/core/utils/encode.dart';

class LoginRequestDto extends Encodable {

  LoginRequestDto({required this.username, required this.password});

  String username;
  String password;

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }

  @override
  String encode() {
    return jsonEncode(toJson());
  }
}
