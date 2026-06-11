import 'package:flutter/material.dart';
import '../backend/daos/user_dao.dart';
import '../backend/daos/meal_preferences_dao.dart';
import '../backend/daos/food_log_dao.dart';
import '../backend/daos/saved_recipe_dao.dart';
import '../backend/models.dart';
import '../backend/models/user_model.dart';

class DbProvider extends ChangeNotifier {
  final UserDao _userDao = UserDao();
  bool _isLoading = false;

  // THE SINGLE SOURCE OF TRUTH STATE
  UserModel? _userProfile;

  // DEV BRANCH FEATURE STATE
  MealPreferencesModel? _mealPreferences;
  List<FoodLogModel> _foodLogs = [];
  List<SavedRecipeModel> _savedRecipes = [];

  DbProvider() {
    _loadInitialData();
  }


  UserModel? get userProfile => _userProfile;
  // This alias ensures the team's existing UI widgets don't break!
  UserModel? get currentUser => _userProfile;
  bool get isLoading => _isLoading;

  MealPreferencesModel? get mealPreferences => _mealPreferences;
  List<FoodLogModel> get foodLogs => _foodLogs;
  List<SavedRecipeModel> get savedRecipes => _savedRecipes;

  void _loadInitialData() {
    _userProfile = UserDao.getUser(); // Pulls your model from your box now
    _mealPreferences = MealPreferencesDao.getPreferences();
    _foodLogs = FoodLogDao.getAllLogs();
    _savedRecipes = SavedRecipeDao.getSavedRecipes();
  }


  Future<void> saveUser(UserModel user) async {
    await UserDao.saveUser(user);
    _userProfile = user;
    notifyListeners();
  }

  Future<void> deleteUser() async {
    await UserDao.deleteUser();
    _userProfile = null;
    notifyListeners();
  }

  // === YOUR ONBOARDING METHODS ===
  Future<UserModel?> loadUserProfile() async {
    _isLoading = true;
    notifyListeners();

    _userProfile = await _userDao.getProfile();

    _isLoading = false;
    notifyListeners();
    return _userProfile;
  }

  Future<void> saveUserName(String name) async {
    await _userDao.upsertName(name);
    _userProfile = await _userDao.getProfile();
    notifyListeners();
  }

  Future<void> saveUserAge(int age) async {
    await _userDao.upsertAge(age);
    _userProfile = await _userDao.getProfile();
    notifyListeners();
  }

  Future<void> saveUserGender(String gender) async {
    await _userDao.upsertGender(gender);
    _userProfile = await _userDao.getProfile();
    notifyListeners();
  }

  Future<void> saveUserBodyMetrics({
    required double heightCm,
    required double weightKg,
  }) async {
    await _userDao.upsertBodyMetrics(heightCm: heightCm, weightKg: weightKg);
    _userProfile = await _userDao.getProfile();
    notifyListeners();
  }

  Future<void> saveUserActivityLevel(String activityLevel) async {
    await _userDao.upsertActivityLevel(activityLevel);
    _userProfile = await _userDao.getProfile();
    notifyListeners();
  }

  Future<void> saveUserMacroGoals({
    required int calories,
    required int proteinG,
    required int carbsG,
    required int fatG,
  }) async {
    await _userDao.upsertMacroGoals(
      calories: calories,
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
    );
    _userProfile = await _userDao.getProfile();
    notifyListeners();
  }


  Future<void> saveMealPreferences(MealPreferencesModel preferences) async {
    await MealPreferencesDao.savePreferences(preferences);
    _mealPreferences = preferences;
    notifyListeners();
  }

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
