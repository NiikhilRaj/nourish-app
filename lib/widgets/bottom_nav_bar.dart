import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/food_log');
        break;
      case 2:
        context.go('/ai_recipes');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF1A1A1E) : const Color(0xFFF7F6F9);
    const activePillColor = Color(0xFFE8E7FF);
    final inactiveColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;

    Widget buildNavItem(int index, IconData icon, String label) {
      final isSelected = index == currentIndex;
      return Expanded(
        child: GestureDetector(
          onTap: () => _onTap(context, index),
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? activePillColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: isSelected ? const Color(0xFF1C1C1E) : inactiveColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? const Color(0xFF1C1C1E) : inactiveColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 75,
      padding: const EdgeInsets.only(bottom: 8, top: 6),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildNavItem(0, Icons.home_filled, 'Home'),
          buildNavItem(1, Icons.restaurant_menu, 'Food Log'),
          buildNavItem(2, FontAwesomeIcons.carrot, 'Recipes'),
        ],
      ),
    );
  }
}
