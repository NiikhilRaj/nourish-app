import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import 'router.dart';
import 'providers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      config: ToastificationConfig(
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