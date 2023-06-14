import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pa_mobile/flows/authentication/logic/authentication.dart';
import 'package:pa_mobile/shared/sevices/environment.dart';

class HttpRequests {
  // default headers
  static Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json'
  };

  static Future<Response> post(
    String route,
    Object body,
  ) async {
    final url = Uri.parse(Environment.apiURL + route);
    print(url);
    print(body);
    return http.post(url, headers: defaultHeaders, body: body);
  }
}
