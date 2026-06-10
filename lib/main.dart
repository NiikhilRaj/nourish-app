import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import 'router.dart';
import 'providers.dart';
import 'providers/theme_provider.dart';
import 'providers/shared_preferences_provider.dart';
import 'theme/app_colors.dart';

// === UNIFIED IMPORTS ===
import 'backend/db_service.dart';
import 'backend/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // === UNIFIED DATABASE INITIALIZATION ===
  // We run both initialization setups so your profile features
  // AND the team's tracking features are fully prepared on startup.
  await DbService.instance.init();
  await HiveService.init();
  // -------------------------------------

  // Preload SharedPreferencesProvider to avoid flicker and ensure availability
  final sharedPrefsProvider = SharedPreferencesProvider();
  await sharedPrefsProvider.loadSettings();

  runApp(MyApp(prefs: sharedPrefsProvider));
}

class MyApp extends StatelessWidget {
  final SharedPreferencesProvider prefs;
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      config: const ToastificationConfig(
        alignment: Alignment.bottomCenter,
        maxToastLimit: 1,
      ),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<SharedPreferencesProvider>.value(value: prefs),
          ...providers, // Auth, Db, Theme (proxy)
        ],
        child: Consumer2<SharedPreferencesProvider, ThemeProvider>(
          builder: (context, sp, theme, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false, // removed the DEBUG banner
              title: 'Nourish App',
              themeMode: theme.themeMode,
              theme: ThemeData.light().copyWith(
                colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
              ),
              darkTheme: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: AppColors.primary,
                  brightness: Brightness.dark,
                ),
              ),

              locale: Locale(
                ['en'].contains(sp.preferredLanguage)
                    ? sp.preferredLanguage
                    : 'en',
              ),
              supportedLocales: const [Locale('en')],

              routerConfig: router,
              builder: (context, child) => child!,
            );
          },
        ),
      ),
    );
  }
}
