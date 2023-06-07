import 'package:flutter_test/flutter_test.dart';
import 'package:pa_mobile/app.dart';
import 'package:pa_mobile/flows/authentication/ui/login_screen.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const MyApp(
        isLogged: false,
      ));
      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });
}
