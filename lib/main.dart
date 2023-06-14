import 'package:flutter/cupertino.dart';
import 'package:pa_mobile/app.dart';
import 'package:pa_mobile/bootstrap.dart';
import 'package:pa_mobile/shared/services/secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLogged = await autoLogin();
  runApp(MyApp(isLogged: isLogged));
}

Future<bool> autoLogin() async {
  final jwtToken = await SecureStorage().readJwtToken();
  return jwtToken != null;
}
