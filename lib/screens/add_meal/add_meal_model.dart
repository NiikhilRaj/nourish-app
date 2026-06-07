import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import '../../providers/db_provider.dart';
import '../../widgets/utils/toast_service.dart';

class AddMealViewModel extends ChangeNotifier {
  String _selectedMealType = 'Breakfast';
  final List<String> _ingredients = [];
  final TextEditingController textController = TextEditingController();
  bool _isLoading = false;

  final List<String> mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];

  String get selectedMealType => _selectedMealType;
  List<String> get ingredients => _ingredients;
  bool get isLoading => _isLoading;

  final Map<String, Map<String, double>> _foodPresets = {};

  void selectMealType(String type) {
    _selectedMealType = type;
    notifyListeners();
  }

  double _parseDouble(dynamic value, double defaultValue) {
    if (value == null) return defaultValue;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

  Future<void> searchAndAddIngredient(String query, BuildContext context) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    final client = HttpClient();
    try {
      final uri = Uri.parse(
        'https://world.openfoodfacts.org/cgi/search.pl?search_terms=${Uri.encodeComponent(trimmedQuery)}&search_simple=1&action=process&json=1'
      );
      final request = await client.getUrl(uri);
      request.headers.set('User-Agent', 'NourishApp - Flutter - Version 1.0');
      
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = json.decode(responseBody);
        
        if (data['products'] != null && (data['products'] as List).isNotEmpty) {
          final product = data['products'][0];
          final name = product['product_name'] ?? product['product_name_en'] ?? product['generic_name'] ?? trimmedQuery;
          final nutriments = product['nutriments'] ?? {};

          final calories = _parseDouble(nutriments['energy-kcal_100g'] ?? nutriments['energy-kcal'] ?? nutriments['energy-kcal_serving'], 0.0); // TODO: fetch from open source API for food nutrition info if missing
          final protein = _parseDouble(nutriments['proteins_100g'] ?? nutriments['proteins'] ?? nutriments['proteins_serving'], 0.0); // TODO: fetch from open source API for food nutrition info if missing
          final carbs = _parseDouble(nutriments['carbohydrates_100g'] ?? nutriments['carbohydrates'] ?? nutriments['carbohydrates_serving'], 0.0); // TODO: fetch from open source API for food nutrition info if missing
          final fat = _parseDouble(nutriments['fat_100g'] ?? nutriments['fat'] ?? nutriments['fat_serving'], 0.0); // TODO: fetch from open source API for food nutrition info if missing

          addScannedFood(
            name: name,
            calories: calories,
            protein: protein,
            carbs: carbs,
            fat: fat,
          );

          if (context.mounted) {
            ToastService().showToast(
              context,
              'Added: $name',
              type: ToastificationType.success,
              description: '${calories.toStringAsFixed(0)} kcal | ${protein.toStringAsFixed(1)}g Protein',
            );
          }
          textController.clear();
          return;
        }
      }

      // If not found, add with TODO/empty values
      addIngredient(trimmedQuery);
      if (context.mounted) {
        ToastService().showToast(
          context,
          'Added: $trimmedQuery',
          type: ToastificationType.info,
          description: 'Could not find details online. TODO: fetch from open source API.',
        );
      }
      textController.clear();
    } catch (e) {
      addIngredient(trimmedQuery);
      if (context.mounted) {
        ToastService().showToast(
          context,
          'Network error, added with empty values',
          type: ToastificationType.warning,
          description: 'TODO: fetch from open source API.',
        );
      }
      textController.clear();
    } finally {
      client.close();
      _isLoading = false;
      notifyListeners();
    }
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
      double calories = 0.0; // TODO: fetch from open source API for food nutrition info if missing
      double protein = 0.0; // TODO: fetch from open source API for food nutrition info if missing
      double carbs = 0.0; // TODO: fetch from open source API for food nutrition info if missing
      double fat = 0.0; // TODO: fetch from open source API for food nutrition info if missing

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
