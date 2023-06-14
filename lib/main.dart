import 'package:pa_mobile/app.dart';
import 'package:pa_mobile/bootstrap.dart';
import 'package:pa_mobile/shared/sevices/secure_storage.dart';

void main() {
  bootstrap(
    () => const MyApp(
      isLogged: false,
    ),
  );
}

Future<bool> isLogged() async {
  final jwtToken = await SecureStorage().readJwtToken();
  return jwtToken != null;
}
