import 'package:flutter/cupertino.dart';
import 'package:pa_mobile/app.dart';
import 'package:pa_mobile/shared/services/storage/jwt_secure_storage.dart';
import 'package:pa_mobile/shared/services/storage/stay_login_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLogged = await autoLogin();
  runApp(MyApp(isLogged: isLogged));
}

Future<bool> autoLogin() async {
  if (await StayLoginSecureStorage().readStayLogin()) {
    final jwtToken = await JwtSecureStorage().readJwtToken();
    return jwtToken != null;
  }
  await JwtSecureStorage().deleteJwtToken();
  return false;
}
