import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StayLoginSecureStorage {
  factory StayLoginSecureStorage() => _instance;

  StayLoginSecureStorage._internal();

  static final StayLoginSecureStorage _instance = StayLoginSecureStorage._internal();

  final String STAY_LOGIN = 'stay_login';

  Future<void> stayLogin() async {
    await const FlutterSecureStorage().write(key: STAY_LOGIN, value: 'true');
  }

  Future<void> notStayLogin() async {
    await const FlutterSecureStorage().write(key: STAY_LOGIN, value: 'false');
  }

  Future<bool> readStayLogin() async {
    return await const FlutterSecureStorage().read(key: STAY_LOGIN) == 'true';
  }
}
