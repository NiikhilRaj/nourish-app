import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// A custom widget that displays meal cards for different meal types.
///
/// This widget shows breakfast, lunch, dinner, and snack meals with their
/// respective calories and quantities in an organized card layout.
/// Any particular meal type is optional
///
/// Example usage:
/// ```dart
/// CustomMealCard(
///   breakfastMeals: {'Oatmeal': {'quantity': '1 bowl', 'calories': 150}},
///   lunchMeals: {'Sandwich': {'quantity': '1 piece', 'calories': 300}},
///   dinnerMeals: {'Rice': {'quantity': '1 cup', 'calories': 200}},
///   snackMeals: {'Apple': {'quantity': '1 piece', 'calories': 80}},
///   onTap : (mealType, meals) {
///     print('Tapped on $mealType: $meals');
///   },
/// )

class CustomMealCard extends StatelessWidget {
  /// Map containing breakfast, lunch, dinner or snack meal data with food names as keys and
  /// quantity/calories as values. Can be null if no meals.
  final Map<String, dynamic>? breakfastMeals,
      lunchMeals,
      dinnerMeals,
      snackMeals;
  final Function(String mealType, Map<String, dynamic> meals)? onTap;

  /// All meal type parameters are optional. Only provided meal types will be displayed.
  /// The [onTap] callback is optional and provides interaction functionality.
  const CustomMealCard({
    super.key,
    this.breakfastMeals,
    this.lunchMeals,
    this.dinnerMeals,
    this.snackMeals,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // This widget is used to display a list of meal cards.
    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        MealCardItem(
          icon: FontAwesomeIcons.breadSlice,
          mealType: "Breakfast",
          meals: breakfastMeals,
          onTap: onTap,
        ),
        SizedBox(height: size.height * 0.02),
        MealCardItem(
          icon: FontAwesomeIcons.bowlFood,
          mealType: "Lunch",
          meals: lunchMeals,
          onTap: onTap,
        ),
        SizedBox(height: size.height * 0.02),
        MealCardItem(
          icon: FontAwesomeIcons.utensils,
          mealType: "Dinner",
          meals: dinnerMeals,
          onTap: onTap,
        ),
        SizedBox(height: size.height * 0.02),
        MealCardItem(
          icon: FontAwesomeIcons.pizzaSlice,
          mealType: "Snacks",
          meals: snackMeals,
          onTap: onTap,
        ),
      ],
    );
  }
}

/// Builds a single meal card item with icon, title, and calorie information.
///
/// This widget represents one meal type (breakfast, lunch, dinner, or snacks)
/// and displays:
/// - An icon representing the meal type
/// - The meal type name
/// - Total calories for all items in this meal type
/// - A divider line
/// - Individual food items with their quantities and calories
///
/// If [meals] is null or empty, the widget returns an empty SizedBox to
/// hide the meal type entirely.
///

class MealCardItem extends StatelessWidget {
  final IconData icon;
  final String mealType;
  final Map<String, dynamic>? meals;
  final Function(String mealType, Map<String, dynamic> meals)? onTap;

  /// Creates a MealCardItem widget.
  ///
  /// [icon] and [mealType] are required to display the meal type properly.
  /// [meals] is optional - if null or empty, the widget won't be displayed.
  /// [onTap] is optional and provides tap interaction functionality.

  const MealCardItem({
    super.key,
    required this.mealType,
    this.meals,
    this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Hide the entire meal card if no meals are provided
    if (meals == null || meals!.isEmpty) return const SizedBox.shrink();

    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 22, color: Colors.black),
            SizedBox(width: size.width * 0.03),
            Text(mealType, style: const TextStyle(fontSize: 24)),
            const Spacer(),
            Text(
              _getTotalCalories(meals!),
              style: const TextStyle(color: Color(0xff6F60EF)),
            ),
          ],
        ),
        const Divider(thickness: 1, color: Colors.black),
        Padding(
          padding: EdgeInsets.only(left: size.width * 0.02),
          child: MealTypeItems(
            meals: meals!,
            onTap: onTap != null ? () => onTap!(mealType, meals!) : null,
          ),
        ),
      ],
    );
  }

  /// Calculates and returns the total calories for all meals in this meal type.
  ///
  /// Iterates through all meals in the provided [meals] map and sums up
  /// the 'calories' value for each meal item.
  ///
  /// Returns a formatted string with the total calories and "kcal" suffix.
  ///
  /// Example: "450 kcal" for meals totaling 450 calories.

  String _getTotalCalories(Map<String, dynamic> meals) {
    num totalCalories = 0;
    meals.forEach((key, value) {
      totalCalories += value['calories'];
    });
    return "$totalCalories kcal";
  }
}

/// A widget that displays individual meal items within a meal type.
///
/// This widget creates a scrollable list of individual food items for a
/// specific meal type. Each item displays:
/// - Food name
/// - Quantity (e.g., "1 bowl", "2 slices")
/// - Individual calorie count
///
/// The entire list is tappable and triggers the provided [onTap] callback
/// when any item is tapped.
///
/// Uses ListView.builder for efficient rendering of meal items and
/// NeverScrollableScrollPhysics to prevent independent scrolling within
/// the parent scrollable widget.

class MealTypeItems extends StatelessWidget {
  final Map<String, dynamic> meals;
  final VoidCallback? onTap;

  const MealTypeItems({super.key, required this.meals, this.onTap});

  @override
  Widget build(BuildContext context) {
    final mealName = meals.keys.toList();
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: meals.length,
      itemBuilder: (context, index) {
        final mealData = meals[mealName[index]];

        return InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(mealName[index], style: const TextStyle(fontSize: 16)),
                  Text(
                    "Qty : ${mealData['quantity']}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const Spacer(),
              Text("${mealData['calories']} kcal"),
            ],
          ),
        );
      },
    );
  }
}
