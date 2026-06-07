import 'package:flutter/material.dart';
import '../../providers/db_provider.dart';

class AddMealViewModel extends ChangeNotifier {
  String _selectedMealType = 'Breakfast';
  final List<String> _ingredients = [];
  final TextEditingController textController = TextEditingController();

  final List<String> mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];

  String get selectedMealType => _selectedMealType;
  List<String> get ingredients => _ingredients;

  final Map<String, Map<String, double>> _foodPresets = {
    'masala dosa': {'calories': 280.0, 'protein': 5.0, 'carbs': 45.0, 'fat': 8.0},
    'biryani': {'calories': 320.0, 'protein': 12.0, 'carbs': 40.0, 'fat': 10.0},
    'paneer tikka': {'calories': 250.0, 'protein': 18.0, 'carbs': 8.0, 'fat': 16.0},
    'samosa': {'calories': 180.0, 'protein': 3.0, 'carbs': 24.0, 'fat': 8.0},
    'boiled eggs': {'calories': 155.0, 'protein': 13.0, 'carbs': 1.0, 'fat': 11.0},
    'curd': {'calories': 98.0, 'protein': 3.0, 'carbs': 4.0, 'fat': 4.0},
    'jalebi': {'calories': 150.0, 'protein': 1.0, 'carbs': 35.0, 'fat': 4.0},
  };

  void selectMealType(String type) {
    _selectedMealType = type;
    notifyListeners();
  }

  void addIngredient(String name) {
    if (name.trim().isNotEmpty) {
      _ingredients.add(name.trim());
      notifyListeners();
    }
  }

  void addScannedFood({
    required String name,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
  }) {
    final key = name.toLowerCase().trim();
    _foodPresets[key] = {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
    addIngredient(name);
  }

  void removeIngredient(int index) {
    if (index >= 0 && index < _ingredients.length) {
      _ingredients.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> saveMeal(DbProvider dbProvider, String dateString) async {
    if (_ingredients.isEmpty) return;

    final List<MealLog> newLogs = [];
    for (final ingredient in _ingredients) {
      final key = ingredient.toLowerCase().trim();
      double calories = 150.0;
      double protein = 5.0;
      double carbs = 20.0;
      double fat = 5.0;

      if (_foodPresets.containsKey(key)) {
        final preset = _foodPresets[key]!;
        calories = preset['calories']!;
        protein = preset['protein']!;
        carbs = preset['carbs']!;
        fat = preset['fat']!;
      }

      newLogs.add(
        MealLog(
          id: "${DateTime.now().microsecondsSinceEpoch}_$ingredient",
          date: dateString,
          mealType: _selectedMealType,
          name: ingredient,
          quantity: '1',
          calories: calories,
          protein: protein,
          carbs: carbs,
          fat: fat,
        ),
      );
    }

    await dbProvider.addMealLogs(newLogs);
    _ingredients.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
