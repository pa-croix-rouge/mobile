import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  factory SecureStorage() => _instance;

  SecureStorage._internal();

  static final SecureStorage _instance = SecureStorage._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String JWT_TOKEN_KEY = 'jwt_token';

  Future<void> writeJwtToken(String value) async {
    await _storage.write(key: JWT_TOKEN_KEY, value: value);
  }

  Future<String?> readJwtToken() async {
    return _storage.read(key: JWT_TOKEN_KEY);
  }

  Future<void> deleteJwtToken() async {
    await _storage.delete(key: JWT_TOKEN_KEY);
  }
}
