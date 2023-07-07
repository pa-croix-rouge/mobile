import 'package:pa_mobile/core/model/authentication/login_request_dto.dart';
import 'package:pa_mobile/core/model/authentication/login_response_dto.dart';

import 'package:pa_mobile/shared/services/request/http_requests.dart';
import 'package:pa_mobile/shared/services/storage/jwt_secure_storage.dart';

class Authentication {
  static String get route => '/login/beneficiary';

  static Future<String> login(LoginRequestDto loginDto) async {
    final response = await HttpRequests.post(
      route,
      loginDto.encode(),
    );
    print('Login response: ${response.statusCode}');
    switch (response.statusCode) {
      case 200:
        final loginResponse = LoginResponseDto.decode(response.body);
        await JwtSecureStorage().writeJwtToken(loginResponse.jwtToken);
        return "success";
      case 490:
        return "Veuillez valider votre compte via le lien envoyé par mail";
      case 491:
        return "Votre compte n'a pas encore été validé par un administrateur";
      default:
        return "Mauvais identifiants";
    }
  }
}
