import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'router.dart';
import 'providers.dart';
import 'models/recipe.dart'; // test model

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive
  await Hive.initFlutter();

  
  Hive.registerAdapter(RecipeAdapter());

  
  await Hive.openBox('userBox');
  await Hive.openBox('settingsBox');
  await Hive.openBox<Recipe>('recipesBox'); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      config: const ToastificationConfig(
        alignment: Alignment.bottomCenter,
        maxToastLimit: 1,
      ),
      child: MultiProvider(
        providers: providers,
        child: MaterialApp.router(
          title: 'Nourish App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          routerConfig: router,
          builder: (context, child) => child!,
        ),
      ),
    );
  }
}
