import 'package:pa_mobile/core/model/authentication/login_request_dto.dart';
import 'package:pa_mobile/core/model/authentication/login_response_dto.dart';

import 'package:pa_mobile/shared/services/request/http_requests.dart';
import 'package:pa_mobile/shared/services/storage/jwt_secure_storage.dart';

class Authentication {
  static String get route => '/login';

  static Future<bool> login(LoginRequestDto loginDto) async {
    final response = await HttpRequests.post(
      route,
      loginDto.encode(),
      null,
    );

    switch (response.statusCode) {
      case 200:
        final loginResponse = LoginResponseDto.decode(response.body);
        await JwtSecureStorage().writeJwtToken(loginResponse.jwtToken);
        return true;
      default:
        return false;
    }
  }
}
