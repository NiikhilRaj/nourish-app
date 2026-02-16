import 'package:provider/provider.dart';

// Global Providers
import 'providers/auth_provider.dart';
import 'providers/db_provider.dart';
import 'providers/shared_preferences_provider.dart';
import 'providers/theme_provider.dart';

final providers = [
  ChangeNotifierProvider(create: (_) => AuthProvider()),
  ChangeNotifierProvider(create: (_) => DbProvider()),
  // ThemeProvider depends on SharedPreferencesProvider (provided in main.dart)
  ChangeNotifierProxyProvider<SharedPreferencesProvider, ThemeProvider>(
    create: (_) => ThemeProvider(),
    update: (_, sp, theme) => theme!..attach(sp),
  ),
];