import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pa_mobile/flows/authentication/logic/authentication.dart';

class HttpRequests {
  static Future<Response> login(String endPoint, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final url = Uri.https(Authentication.baseEndPoint);
    return http.post(url, headers: headers, body: body, encoding: encoding);
  }
}