import 'package:sqflite/sqflite.dart';

class Recipe {
  final String id;
  final String title;
  final String duration;
  final List<String> ingredients;
  final List<String> instructions;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  Recipe({
    required this.id,
    required this.title,
    required this.duration,
    required this.ingredients,
    required this.instructions,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'ingredients': ingredients.join('||'),
      'instructions': instructions.join('||'),
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      title: map['title'],
      duration: map['duration'],
      ingredients: (map['ingredients'] as String).split('||').where((s) => s.isNotEmpty).toList(),
      instructions: (map['instructions'] as String).split('||').where((s) => s.isNotEmpty).toList(),
      calories: map['calories'] as int,
      protein: (map['protein'] as num).toDouble(),
      carbs: (map['carbs'] as num).toDouble(),
      fat: (map['fat'] as num).toDouble(),
    );
  }
}

class SavedRecipeDao {
  static Future<void> saveRecipe(Database db, Recipe recipe) async {
    await db.insert(
      'saved_recipes',
      recipe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Recipe>> getSavedRecipes(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'saved_recipes',
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) {
      return Recipe.fromMap(maps[i]);
    });
  }

  static Future<void> deleteRecipe(Database db, String id) async {
    await db.delete(
      'saved_recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<bool> isSaved(Database db, String id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'saved_recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }
}