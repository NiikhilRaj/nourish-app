import 'package:hive_flutter/hive_flutter.dart';
import 'models.dart';

class HiveService {
  static const String userBoxName = 'user_box';
  static const String preferencesBoxName = 'preferences_box';
  static const String foodLogBoxName = 'food_log_box';
  static const String recipeBoxName = 'recipe_box';

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(UserAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(MealPreferencesAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(FoodLogAdapter());
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(SavedRecipeAdapter());

    if (!Hive.isBoxOpen(userBoxName)) await Hive.openBox<UserModel>(userBoxName);
    if (!Hive.isBoxOpen(preferencesBoxName)) await Hive.openBox<MealPreferencesModel>(preferencesBoxName);
    if (!Hive.isBoxOpen(foodLogBoxName)) await Hive.openBox<FoodLogModel>(foodLogBoxName);
    if (!Hive.isBoxOpen(recipeBoxName)) await Hive.openBox<SavedRecipeModel>(recipeBoxName);
  }
}
