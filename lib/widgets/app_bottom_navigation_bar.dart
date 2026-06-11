import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFFF3EFEF),
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomBarItem(context, 0, Icons.home_outlined, Icons.home, 'Home', currentIndex == 0),
          _buildBottomBarItem(context, 1, Icons.restaurant_menu_outlined, Icons.restaurant_menu, 'Food Log', currentIndex == 1),
          _buildBottomBarItem(context, 2, Icons.cookie_outlined, Icons.cookie, 'Recipes', currentIndex == 2),
        ],
      ),
    );
  }

  Widget _buildBottomBarItem(
    BuildContext context,
    int index,
    IconData iconOutline,
    IconData iconSolid,
    String label,
    bool isActive,
  ) {
    return GestureDetector(
      onTap: () {
        if (index == 0) context.go('/home');
        if (index == 1) context.go('/food_log');
        if (index == 2) context.go('/ai_recipes');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE8DEF8) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? iconSolid : iconOutline,
              color: const Color(0xFF1D1B20),
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: const Color(0xFF1D1B20),
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
