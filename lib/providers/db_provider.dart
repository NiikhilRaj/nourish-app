import 'package:flutter/material.dart';
import '../backend/daos/user_dao.dart';
import '../backend/daos/meal_preferences_dao.dart';
import '../backend/daos/food_log_dao.dart';
import '../backend/daos/saved_recipe_dao.dart';
import '../backend/models.dart';

class DbProvider extends ChangeNotifier {
  UserModel? _currentUser;
  MealPreferencesModel? _mealPreferences;
  List<FoodLogModel> _foodLogs = [];
  List<SavedRecipeModel> _savedRecipes = [];

  DbProvider() {
    _loadInitialData();
  }

  UserModel? get currentUser => _currentUser;
  MealPreferencesModel? get mealPreferences => _mealPreferences;
  List<FoodLogModel> get foodLogs => _foodLogs;
  List<SavedRecipeModel> get savedRecipes => _savedRecipes;

  void _loadInitialData() {
    _currentUser = UserDao.getUser();
    _mealPreferences = MealPreferencesDao.getPreferences();
    _foodLogs = FoodLogDao.getAllLogs();
    _savedRecipes = SavedRecipeDao.getSavedRecipes();
  }

  // ==========================================
  // User Management
  // ==========================================
  Future<void> saveUser(UserModel user) async {
    await UserDao.saveUser(user);
    _currentUser = user;
    notifyListeners();
  }

  Future<void> deleteUser() async {
    await UserDao.deleteUser();
    _currentUser = null;
    notifyListeners();
  }

  // ==========================================
  // Meal Preferences
  // ==========================================
  Future<void> saveMealPreferences(MealPreferencesModel preferences) async {
    await MealPreferencesDao.savePreferences(preferences);
    _mealPreferences = preferences;
    notifyListeners();
  }

  // ==========================================
  // Food Logs
  // ==========================================
  List<FoodLogModel> getLogsForDate(DateTime date) {
    return FoodLogDao.getLogsByDate(date);
  }

  Future<void> saveFoodLog(FoodLogModel log) async {
    await FoodLogDao.saveLog(log);
    _foodLogs = FoodLogDao.getAllLogs();
    notifyListeners();
  }

  Future<void> deleteFoodLog(String id) async {
    await FoodLogDao.deleteLog(id);
    _foodLogs = FoodLogDao.getAllLogs();
    notifyListeners();
  }

  Future<void> clearAllFoodLogs() async {
    await FoodLogDao.clearAll();
    _foodLogs = [];
    notifyListeners();
  }

  // ==========================================
  // Saved Recipes
  // ==========================================
  bool isRecipeSaved(String id) {
    return SavedRecipeDao.isRecipeSaved(id);
  }

  Future<void> saveRecipe(SavedRecipeModel recipe) async {
    await SavedRecipeDao.saveRecipe(recipe);
    _savedRecipes = SavedRecipeDao.getSavedRecipes();
    notifyListeners();
  }

  Future<void> deleteRecipe(String id) async {
    await SavedRecipeDao.deleteRecipe(id);
    _savedRecipes = SavedRecipeDao.getSavedRecipes();
    notifyListeners();
  }
}
