import 'package:hive/hive.dart';
import '../hive_service.dart';
import '../models.dart';

class MealPreferencesDao {
  static Box<MealPreferencesModel> get _box => Hive.box<MealPreferencesModel>(HiveService.preferencesBoxName);

  static MealPreferencesModel getPreferences() {
    return _box.get('current_preferences') ?? MealPreferencesModel(
      targetCalories: 2000,
      targetProtein: 150,
      targetCarbs: 200,
      targetFat: 70,
    );
  }

  static Future<void> savePreferences(MealPreferencesModel preferences) async {
    await _box.put('current_preferences', preferences);
  }

  static Future<void> deletePreferences() async {
    await _box.delete('current_preferences');
  }
}