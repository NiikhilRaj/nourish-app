import 'package:flutter/material.dart';

import '../../providers/db_provider.dart';

class OnboardingViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  int _currentStep = 0;
  bool _isSaving = false;
  String? _selectedGender;
  String? _nameError;
  String? _ageError;
  String? _genderError;
  String? _heightError;
  String? _weightError;

  int get currentStep => _currentStep;
  bool get isSaving => _isSaving;
  String? get selectedGender => _selectedGender;
  String? get nameError => _nameError;
  String? get ageError => _ageError;
  String? get genderError => _genderError;
  String? get heightError => _heightError;
  String? get weightError => _weightError;

  Future<void> loadExistingProfile(DbProvider dbProvider) async {
    final profile = await dbProvider.loadUserProfile();
    if (profile == null) return;

    nameController.text = profile.name ?? '';
    ageController.text = profile.age?.toString() ?? '';
    _selectedGender = profile.gender;
    heightController.text = _formatMetric(profile.heightCm);
    weightController.text = _formatMetric(profile.weightKg);
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

    _heightError = heightCm == null || heightCm < 50 || heightCm > 260
        ? 'Enter a valid height'
        : null;
    _weightError = weightKg == null || weightKg < 20 || weightKg > 400
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
      return true;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void selectGender(String gender) {
    _selectedGender = gender;
    _genderError = null;
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

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }
}
