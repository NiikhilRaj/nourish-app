import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_model.dart';
import '../../widgets/bottom_nav_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Nourish Home'),
            ),
            bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),


            body: Center(
              child: Text(
                'Welcome to Nourish!\nTrack your daily nutrition and explore AI Recipes below.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}




