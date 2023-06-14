import 'package:flutter/cupertino.dart';
import 'package:pa_mobile/app.dart';
import 'package:pa_mobile/bootstrap.dart';
import 'package:pa_mobile/shared/services/jwt_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLogged = await autoLogin();
  runApp(MyApp(isLogged: isLogged));
}

Future<bool> autoLogin() async {
  //todo verifier aussi si dans le cubit le user veut rester connecter
  final jwtToken = await JwtSecureStorage().readJwtToken();
  return jwtToken != null;
}
