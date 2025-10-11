import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'landing_model.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LandingViewModel(),
      child: Consumer<LandingViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => context.go('/home'),
                child: Text('Go to Home'),
              ),
            ),
          );
        },
      ),
    );
  }
}