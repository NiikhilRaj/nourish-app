import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../backend/daos/saved_recipe_dao.dart';

class SavedRecipesViewModel extends ChangeNotifier {
  List<Recipe> _allRecipes = [];
  List<Recipe> _filteredRecipes = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Recipe> get savedRecipes => _filteredRecipes;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  // Load all recipes from database
  Future<void> loadSavedRecipes(Database db) async {
    _isLoading = true;
    notifyListeners();

    try {
      _allRecipes = await SavedRecipeDao.getSavedRecipes(db);
      _filterRecipes();
    } catch (e) {
      print('Error loading saved recipes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter recipes based on search query
  void search(String query) {
    _searchQuery = query;
    _filterRecipes();
    notifyListeners();
  }

  void _filterRecipes() {
    if (_searchQuery.trim().isEmpty) {
      _filteredRecipes = List.from(_allRecipes);
    } else {
      final query = _searchQuery.toLowerCase();
      _filteredRecipes = _allRecipes.where((recipe) {
        return recipe.title.toLowerCase().contains(query) ||
            recipe.ingredients.any((ing) => ing.toLowerCase().contains(query));
      }).toList();
    }
  }

  // Delete recipe from database
  Future<void> deleteRecipe(Database db, String id) async {
    try {
      await SavedRecipeDao.deleteRecipe(db, id);
      _allRecipes.removeWhere((r) => r.id == id);
      _filterRecipes();
      notifyListeners();
    } catch (e) {
      print('Error deleting recipe: $e');
    }
  }

  // Check if a recipe is saved
  bool isRecipeSaved(String id) {
    return _allRecipes.any((r) => r.id == id);
  }
}
