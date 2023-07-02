import 'package:pa_mobile/core/utils/encode.dart';

class LoginResponseDto {
  LoginResponseDto({required this.jwtToken});

  String jwtToken;

  static LoginResponseDto decode(String jsonObject) {
    final token = EncodeTools.decodeString(jsonObject, 'jwtToken');
    final loginResponseDto = LoginResponseDto(jwtToken: token);
    return loginResponseDto;
  }
}
