import 'package:pa_mobile/app.dart';
import 'package:pa_mobile/bootstrap.dart';

void main() {
  bootstrap(
    () => const MyApp(
      //todo faire un service pour le token jwt
      isLogged: false,
    ),
  );
}
