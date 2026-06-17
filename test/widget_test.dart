import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nourish_app/main.dart';
import 'package:nourish_app/providers/shared_preferences_provider.dart';

void main() {
  testWidgets('App loads landing view smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = SharedPreferencesProvider();
    await prefs.loadSettings();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(prefs: prefs));

    // Verify that our landing page has the button to go to Home.
    expect(find.text('Go to Home'), findsOneWidget);
  });
}

