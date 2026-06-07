import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MealLog {
  final String id;
  final String date;
  final String mealType;
  final String name;
  final String quantity;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  MealLog({
    required this.id,
    required this.date,
    required this.mealType,
    required this.name,
    required this.quantity,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'mealType': mealType,
      'name': name,
      'quantity': quantity,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }

  factory MealLog.fromMap(Map<String, dynamic> map) {
    return MealLog(
      id: map['id'] as String,
      date: map['date'] as String,
      mealType: map['mealType'] as String,
      name: map['name'] as String,
      quantity: map['quantity'] as String,
      calories: (map['calories'] as num).toDouble(),
      protein: (map['protein'] as num).toDouble(),
      carbs: (map['carbs'] as num).toDouble(),
      fat: (map['fat'] as num).toDouble(),
    );
  }
}

class DbProvider extends ChangeNotifier {
  List<MealLog> _logs = [];
  DateTime _selectedDate = DateTime.now();

  final double caloriesTarget = 2200.0;
  final double proteinTarget = 110.0;
  final double carbsTarget = 110.0;
  final double fatTarget = 60.0;

  List<MealLog> get logs => _logs;
  DateTime get selectedDate => _selectedDate;

  DbProvider() {
    _loadLogs();
  }

  String _formatDateKey(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
  }

  List<MealLog> get selectedDateLogs {
    final dateString = _formatDateKey(_selectedDate);
    return _logs.where((log) => log.date == dateString).toList();
  }

  double get totalCaloriesConsumed {
    return selectedDateLogs.fold(0.0, (sum, item) => sum + item.calories);
  }

  double get totalProteinConsumed {
    return selectedDateLogs.fold(0.0, (sum, item) => sum + item.protein);
  }

  double get totalCarbsConsumed {
    return selectedDateLogs.fold(0.0, (sum, item) => sum + item.carbs);
  }

  double get totalFatConsumed {
    return selectedDateLogs.fold(0.0, (sum, item) => sum + item.fat);
  }

  double get calorieProgressPercent {
    if (caloriesTarget <= 0) return 0.0;
    final percent = totalCaloriesConsumed / caloriesTarget;
    return percent > 1.0 ? 1.0 : percent;
  }

  void changeDate(DateTime newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }

  void incrementDate() {
    _selectedDate = _selectedDate.add(const Duration(days: 1));
    notifyListeners();
  }

  void decrementDate() {
    _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    notifyListeners();
  }

  Future<void> addMealLogs(List<MealLog> newLogs) async {
    _logs.addAll(newLogs);
    await _saveLogs();
    notifyListeners();
  }

  Future<void> deleteMealLog(String logId) async {
    _logs.removeWhere((log) => log.id == logId);
    await _saveLogs();
    notifyListeners();
  }

  Future<void> _loadLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final logsString = prefs.getString('food_logs_cache');
      if (logsString != null) {
        final List<dynamic> decoded = json.decode(logsString);
        _logs = decoded.map((item) => MealLog.fromMap(item as Map<String, dynamic>)).toList();
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> _saveLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final logsString = json.encode(_logs.map((log) => log.toMap()).toList());
      await prefs.setString('food_logs_cache', logsString);
    } catch (_) {}
  }
}
