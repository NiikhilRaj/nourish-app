import 'package:hive/hive.dart';
import '../hive_service.dart';
import '../models.dart';

class MealPreferencesDao {
  static Box<MealPreferencesModel> get _box => Hive.box<MealPreferencesModel>(HiveService.preferencesBoxName);

  static MealPreferencesModel getPreferences() {
    return _box.get('current_preferences') ?? MealPreferencesModel(
      targetCalories: 0,
      targetProtein: 0,
      targetCarbs: 0,
      targetFat: 0,
    );
  }

  static Future<void> savePreferences(MealPreferencesModel preferences) async {
    await _box.put('current_preferences', preferences);
  }

  static Future<void> deletePreferences() async {
    await _box.delete('current_preferences');
  }
}