import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'food_log_model.dart';
import '../../widgets/bottom_nav_bar.dart';

class FoodLogView extends StatelessWidget {
  const FoodLogView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FoodLogViewModel(),
      child: Consumer<FoodLogViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Food Log'),
            ),
            bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
            body: Center(
              child: ElevatedButton(
                onPressed: () => context.go('/add_meal'),
                child: const Text('Go to Add Meal'),
              ),
            ),
          );
        },
      ),
    );
  }
}

