import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pa_mobile/shared/services/environement/environment.dart';
import 'package:pa_mobile/shared/services/storage/jwt_secure_storage.dart';

class HttpRequests {
  static Future<Map<String, String>> _defaultHeaders(
    Map<String, String>? headers,
  ) async {
    final defaultHeaders = headers ?? {};

    final jwtToken = await JwtSecureStorage().readJwtToken();

    if (jwtToken != null) {
      defaultHeaders.putIfAbsent('Authorization', () => 'Bearer $jwtToken');
    }
    defaultHeaders.putIfAbsent('Content-Type', () => 'application/json');
    return defaultHeaders;
  }

  static Future<Response> post(String route, Object body,
      [Map<String, String>? headers]) async {
    print(Uri.parse(Environment.apiURL + route));
    print(body);
    final url = Uri.parse(Environment.apiURL + route);
    return http.Client().post(
      url,
      headers: await _defaultHeaders(headers),
      body: body,
    ).timeout(const Duration(seconds: 120));
  }

  static Future<Response> delete(
    String route,
    Object body,
    Map<String, String>? headers,
  ) async {
    print(Uri.parse(Environment.apiURL + route));
    final url = Uri.parse(Environment.apiURL + route);
    return http
        .delete(
          url,
          headers: await _defaultHeaders(headers),
          body: body,
        )
        .timeout(const Duration(seconds: 120));
  }

  static Future<Response> get(String route,
      [Map<String, String>? headers]) async {
    final url = Uri.parse(Environment.apiURL + route);
    print(url);
    return http
        .get(
          url,
          headers: await _defaultHeaders(headers),
        )
        .timeout(const Duration(seconds: 120));
  }

  static Future<Response> put(String route, Object body,
      [Map<String, String>? headers]) async {
    final url = Uri.parse(Environment.apiURL + route);
    return http
        .put(
          url,
          headers: await _defaultHeaders(headers),
          body: body,
        )
        .timeout(const Duration(seconds: 120));
  }
}
