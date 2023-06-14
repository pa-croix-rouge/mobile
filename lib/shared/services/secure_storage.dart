import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  factory SecureStorage() => _instance;

  SecureStorage._internal();

  static final SecureStorage _instance = SecureStorage._internal();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  static Future<String?> get(String key) async {
    return _storage.read(key: key, aOptions: _getAndroidOptions());
  }

  static Future<void> set(String key, String value) async {
    await _storage.write(
        key: key, value: value, aOptions: _getAndroidOptions());
  }

  static Future<void> delete(String key) async {
    await _storage.delete(key: key, aOptions: _getAndroidOptions());
  }
}
