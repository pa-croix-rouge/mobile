import 'package:pa_mobile/core/model/authentication/login_request_dto.dart';
import 'package:pa_mobile/core/model/authentication/login_response_dto.dart';

import 'package:pa_mobile/shared/services/http_requests.dart';
import 'package:pa_mobile/shared/services/secure_storage.dart';

class Authentication {
  static String get route => '/login';

  static Future<bool> login(LoginRequestDto loginDto) async {
    final response = await HttpRequests.post(
      route,
      loginDto.encode(),
    );

    switch (response.statusCode) {
      case 200:
        final loginResponse = LoginResponseDto.decode(response.body);
        await SecureStorage().writeJwtToken(loginResponse.jwtToken);
        return true;
      default:
        return false;
    }
  }
}
