import 'package:flutter_test/flutter_test.dart';
import 'package:pa_mobile/app.dart';
import 'package:pa_mobile/flows/home/ui/home_screen.dart';

void main() {
  group('App', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(
        const MyApp(
          isLogged: false,
        ),
      );
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
