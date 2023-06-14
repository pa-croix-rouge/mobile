import 'dart:io';

import 'package:http/http.dart';
import 'package:pa_mobile/core/model/authentication/login_request_dto.dart';
import 'package:pa_mobile/core/model/authentication/login_response_dto.dart';
import 'package:pa_mobile/core/utils/encode.dart';
import 'package:pa_mobile/shared/sevices/environment.dart';

import 'package:pa_mobile/shared/sevices/http_requests.dart';
import 'package:pa_mobile/shared/sevices/secure_storage.dart';

class Authentication {
  static String get route => '/login';

  static Future<bool> login(LoginRequestDto loginDto) async {
    final response = await HttpRequests.post(
      route,
      loginDto.encode(),
    );

    //recuperer la réponse pour la transformé en login response dto


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
