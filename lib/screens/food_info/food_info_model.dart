import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class FoodInfoViewModel extends ChangeNotifier {
  bool isLoading = false;
  bool hasData = false;
  String productName = '';
  String productQuantity = '';
  double calories = 0;
  double protein = 0;
  double carbs = 0;
  double fat = 0;
  String imageUrl = '';
  List<String> allergens = [];
  List<String> ingredients = [];
  bool isVegetarian = true;

  double _parseDouble(dynamic value, double defaultValue) {
    if (value == null) return defaultValue;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

  Future<bool> fetchProduct(String barcode) async {
    isLoading = true;
    notifyListeners();

    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse('https://world.openfoodfacts.org/api/v2/product/$barcode.json'));
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = json.decode(responseBody);
        if (data['status'] == 1 && data['product'] != null) {
          final product = data['product'];
          productName = product['product_name'] ?? product['product_name_en'] ?? product['generic_name'] ?? 'Unknown Product';
          
          final quantityVal = product['quantity'] ?? product['net_weight_value_unit'] ?? '100 g';
          productQuantity = quantityVal.toString();

          final nutriments = product['nutriments'] ?? {};
          calories = _parseDouble(nutriments['energy-kcal_100g'] ?? nutriments['energy-kcal'] ?? nutriments['energy-kcal_serving'], 0.0);
          protein = _parseDouble(nutriments['proteins_100g'] ?? nutriments['proteins'] ?? nutriments['proteins_serving'], 0.0);
          carbs = _parseDouble(nutriments['carbohydrates_100g'] ?? nutriments['carbohydrates'] ?? nutriments['carbohydrates_serving'], 0.0);
          fat = _parseDouble(nutriments['fat_100g'] ?? nutriments['fat'] ?? nutriments['fat_serving'], 0.0);

          imageUrl = product['image_url'] ?? product['image_front_url'] ?? '';

          final List<dynamic> rawAllergens = product['allergens_tags'] ?? [];
          allergens = rawAllergens.map((a) {
            String val = a.toString().replaceAll('en:', '');
            if (val.isEmpty) return '';
            return val[0].toUpperCase() + val.substring(1);
          }).where((a) => a.isNotEmpty).toList();

          final String? ingText = product['ingredients_text'] ?? product['ingredients_text_en'];
          if (ingText != null && ingText.trim().isNotEmpty) {
            ingredients = ingText
                .split(',')
                .map((i) => i.trim())
                .where((i) => i.isNotEmpty && i.length > 2)
                .take(7)
                .toList();
          } else {
            ingredients = ['No ingredient list available'];
          }

          final List<dynamic> analysisTags = product['ingredients_analysis_tags'] ?? [];
          isVegetarian = !analysisTags.contains('en:non-vegetarian');

          hasData = true;
          isLoading = false;
          notifyListeners();
          return true;
        }
      }
    } catch (_) {}

    isLoading = false;
    notifyListeners();
    return false;
  }
}
