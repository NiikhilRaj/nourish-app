import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

// 1. ADDED: Import Hive
import 'package:hive_flutter/hive_flutter.dart';

import 'router.dart';
import 'providers.dart';
import 'providers/theme_provider.dart';
import 'providers/shared_preferences_provider.dart';
import 'theme/app_colors.dart';

// 2. ADDED: Import your database service and model
// (Make sure to adjust these paths if your folders are structured differently!)
import 'backend/db_service.dart';
import 'backend/models/user_profile_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- 3. FIXED: HIVE INITIALIZATION ---
  // We removed the duplicate Hive.initFlutter() and registerAdapter()
  // because DbService.instance.init() is already handling them for us!
  await DbService.instance.init();
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
          // Provide preloaded SharedPreferencesProvider first so others can depend on it
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

              // Optional language binding (expand when you localize)
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