import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'profile_model.dart';
import '../../widgets/bottom_nav_bar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: Consumer<ProfileViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
            ),
            bottomNavigationBar: const AppBottomNavBar(currentIndex: 4),
            body: Center(
              child: ElevatedButton(
                onPressed: () => context.go('/about_us'),
                child: const Text('Go to About Us'),
              ),
            ),
          );
        },
      ),
    );
  }
}

