import 'package:hive/hive.dart';
import '../hive_service.dart';
import '../models.dart';

class SavedRecipeDao {
  static Box<SavedRecipeModel> get _box => Hive.box<SavedRecipeModel>(HiveService.recipeBoxName);

  static List<SavedRecipeModel> getSavedRecipes() {
    return _box.values.toList();
  }

  static Future<void> saveRecipe(SavedRecipeModel recipe) async {
    await _box.put(recipe.id, recipe);
  }

  static Future<void> deleteRecipe(String id) async {
    await _box.delete(id);
  }

  static bool isRecipeSaved(String id) {
    return _box.containsKey(id);
  }

  static Future<void> clearAll() async {
    await _box.clear();
  }
}