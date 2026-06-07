import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nourish_app/main.dart';
import 'package:nourish_app/providers/shared_preferences_provider.dart';

void main() {
  testWidgets('App landing screen smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = SharedPreferencesProvider();
    await prefs.loadSettings();

    await tester.pumpWidget(MyApp(prefs: prefs));

    expect(find.text('Go to Home'), findsOneWidget);
  });
}
