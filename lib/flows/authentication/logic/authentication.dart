import 'package:http/http.dart';
import 'package:pa_mobile/shared/sevices/environment.dart';

import 'package:pa_mobile/shared/sevices/http_requests.dart';

class Authentication {
  static String get baseEndPoint => '$Environment/login';

  Future<bool> login(String email, String password) async {
    final endPoint = '$baseEndPoint/beneficiary';

    final response = await HttpRequests.login(endPoint, body: {
      'email': email,
      'password': password,
    });

    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }
}
