import 'package:flutter_test/flutter_test.dart';
import 'package:pa_mobile/app/app.dart';
import 'package:pa_mobile/counter/counter.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
