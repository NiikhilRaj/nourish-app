import 'package:hive_flutter/hive_flutter.dart';
import 'models.dart';

class HiveService {
  static const String userBoxName = 'user_box';
  static const String preferencesBoxName = 'preferences_box';
  static const String foodLogBoxName = 'food_log_box';
  static const String recipeBoxName = 'recipe_box';

  static Future<void> init() async {
    // 1. Initialize Hive with Flutter path
    await Hive.initFlutter();

    // 2. Register manual Adapters
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(MealPreferencesAdapter());
    Hive.registerAdapter(FoodLogAdapter());
    Hive.registerAdapter(SavedRecipeAdapter());

    // 3. Open Boxes asynchronously
    await Hive.openBox<UserModel>(userBoxName);
    await Hive.openBox<MealPreferencesModel>(preferencesBoxName);
    await Hive.openBox<FoodLogModel>(foodLogBoxName);
    await Hive.openBox<SavedRecipeModel>(recipeBoxName);
  }
}
