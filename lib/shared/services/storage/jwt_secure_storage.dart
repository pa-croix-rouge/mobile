import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pa_mobile/shared/services/storage/secure_storage.dart';

class JwtSecureStorage {
  factory JwtSecureStorage() => _instance;

  JwtSecureStorage._internal();

  static final JwtSecureStorage _instance = JwtSecureStorage._internal();

  final String JWT_TOKEN_KEY = 'jwt_token';

  Future<void> writeJwtToken(String value) async {
    await SecureStorage.set(JWT_TOKEN_KEY, value);
  }

  Future<String?> readJwtToken() async {
    return SecureStorage.get(JWT_TOKEN_KEY);
  }

  Future<void> deleteJwtToken() async {
    await SecureStorage.delete(JWT_TOKEN_KEY);
  }
}
