import 'package:flutter/material.dart';

import '../../providers/db_provider.dart';

class OnboardingViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController carbsController = TextEditingController();
  final TextEditingController fatController = TextEditingController();

  int _currentStep = 0;
  bool _isSaving = false;
  String? _selectedGender;
  String? _selectedActivity;
  String? _nameError;
  String? _ageError;
  String? _genderError;
  String? _heightError;
  String? _weightError;
  String? _activityError;
  String? _macroError;

  int get currentStep => _currentStep;
  bool get isSaving => _isSaving;
  String? get selectedGender => _selectedGender;
  String? get selectedActivity => _selectedActivity;
  String? get nameError => _nameError;
  String? get ageError => _ageError;
  String? get genderError => _genderError;
  String? get heightError => _heightError;
  String? get weightError => _weightError;
  String? get activityError => _activityError;
  String? get macroError => _macroError;

  Future<void> loadExistingProfile(DbProvider dbProvider) async {
    final profile = await dbProvider.loadUserProfile();
    if (profile == null) return;

    nameController.text = profile.name ?? '';
    ageController.text = profile.age?.toString() ?? '';
    _selectedGender = profile.gender;
    _selectedActivity = profile.activityLevel;
    heightController.text = _formatMetric(profile.heightCm);
    weightController.text = _formatMetric(profile.weightKg);
    caloriesController.text = profile.calorieGoal?.toString() ?? '';
    proteinController.text = profile.proteinGoalG?.toString() ?? '';
    carbsController.text = profile.carbsGoalG?.toString() ?? '';
    fatController.text = profile.fatGoalG?.toString() ?? '';
    notifyListeners();
  }

  Future<bool> saveName(DbProvider dbProvider) async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      _nameError = 'Please enter your name';
      notifyListeners();
      return false;
    }

    _nameError = null;
    _isSaving = true;
    notifyListeners();

    try {
      await dbProvider.saveUserName(name);
      _currentStep = 1;
      return true;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> saveAge(DbProvider dbProvider) async {
    final age = int.tryParse(ageController.text.trim());
    if (age == null || age < 1 || age > 120) {
      _ageError = 'Please enter a valid age';
      notifyListeners();
      return false;
    }

    _ageError = null;
    _isSaving = true;
    notifyListeners();

    try {
      await dbProvider.saveUserAge(age);
      _currentStep = 2;
      return true;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> saveGender(DbProvider dbProvider) async {
    final gender = _selectedGender;
    if (gender == null) {
      _genderError = 'Please select your gender';
      notifyListeners();
      return false;
    }

    _genderError = null;
    _isSaving = true;
    notifyListeners();

    try {
      await dbProvider.saveUserGender(gender);
      _currentStep = 3;
      return true;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> saveBodyMetrics(DbProvider dbProvider) async {
    final heightCm = double.tryParse(heightController.text.trim());
    final weightKg = double.tryParse(weightController.text.trim());

    _heightError =
        heightCm == null || heightCm < 50 || heightCm > 260
            ? 'Enter a valid height'
            : null;
    _weightError =
        weightKg == null || weightKg < 20 || weightKg > 400
            ? 'Enter a valid weight'
            : null;

    if (_heightError != null || _weightError != null) {
      notifyListeners();
      return false;
    }

    _isSaving = true;
    notifyListeners();

    try {
      await dbProvider.saveUserBodyMetrics(
        heightCm: heightCm!,
        weightKg: weightKg!,
      );
      _currentStep = 4;
      return true;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> saveActivity(DbProvider dbProvider) async {
    final activity = _selectedActivity;

    if (activity == null) {
      _activityError = 'Please select an activity level';
      notifyListeners();
      return false;
    }

    _activityError = null;
    _isSaving = true;
    notifyListeners();

    try {
      await dbProvider.saveUserActivityLevel(activity);
      _ensureMacroDefaults();
      _currentStep = 5;
      return true;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> saveMacroGoals(DbProvider dbProvider) async {
    final calories = int.tryParse(caloriesController.text.trim());
    final protein = int.tryParse(proteinController.text.trim());
    final carbs = int.tryParse(carbsController.text.trim());
    final fat = int.tryParse(fatController.text.trim());

    if (calories == null ||
        protein == null ||
        carbs == null ||
        fat == null ||
        calories < 800 ||
        calories > 6000 ||
        protein < 0 ||
        protein > 500 ||
        carbs < 0 ||
        carbs > 1000 ||
        fat < 0 ||
        fat > 500) {
      _macroError = 'Please enter valid macro goals';
      notifyListeners();
      return false;
    }

    _macroError = null;
    _isSaving = true;
    notifyListeners();

    try {
      await dbProvider.saveUserMacroGoals(
        calories: calories,
        proteinG: protein,
        carbsG: carbs,
        fatG: fat,
      );
      return true;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void selectActivity(String activity) {
    _selectedActivity = activity;
    _activityError = null;
    notifyListeners();
  }

  void selectGender(String gender) {
    _selectedGender = gender;
    _genderError = null;
    notifyListeners();
  }

  void nextStep() {
    _currentStep += 1;
    notifyListeners();
  }

  void previousStep() {
    if (_currentStep == 0) return;
    _currentStep -= 1;
    notifyListeners();
  }

  String _formatMetric(double? value) {
    if (value == null) return '';
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toString();
  }

  void _ensureMacroDefaults() {
    if (caloriesController.text.isNotEmpty &&
        proteinController.text.isNotEmpty &&
        carbsController.text.isNotEmpty &&
        fatController.text.isNotEmpty) {
      return;
    }

    final age = int.tryParse(ageController.text.trim());
    final heightCm = double.tryParse(heightController.text.trim());
    final weightKg = double.tryParse(weightController.text.trim());
    final activity = _selectedActivity;

    if (age == null || heightCm == null || weightKg == null || activity == null) {
      caloriesController.text = '2000';
      proteinController.text = '110';
      carbsController.text = '110';
      fatController.text = '60';
      return;
    }

    final genderOffset = switch (_selectedGender) {
      'male' => 5,
      'female' => -161,
      _ => -78,
    };
    final activityFactor = switch (activity) {
      'sedentary' => 1.2,
      'light' => 1.375,
      'moderate' => 1.55,
      'intense' => 1.725,
      'very_intense' => 1.9,
      _ => 1.2,
    };

    final bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) + genderOffset;
    final calories = ((bmr * activityFactor) / 10).round() * 10;
    final protein = (weightKg * 1.8).round();
    final fat = ((calories * 0.25) / 9).round();
    final carbs = ((calories - (protein * 4) - (fat * 9)) / 4).round().clamp(0, 1000);

    caloriesController.text = calories.toString();
    proteinController.text = protein.toString();
    carbsController.text = carbs.toString();
    fatController.text = fat.toString();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    caloriesController.dispose();
    proteinController.dispose();
    carbsController.dispose();
    fatController.dispose();
    super.dispose();
  }
}
