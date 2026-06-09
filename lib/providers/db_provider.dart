import 'package:flutter/material.dart';

import '../backend/daos/user_dao.dart';
import '../backend/models/user_profile_model.dart';

class DbProvider extends ChangeNotifier {
  final UserDao _userDao = UserDao();

  UserProfileModel? _userProfile;
  bool _isLoading = false;

  UserProfileModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  Future<UserProfileModel?> loadUserProfile() async {
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
    await _userDao.upsertBodyMetrics(
      heightCm: heightCm,
      weightKg: weightKg,
    );
    _userProfile = await _userDao.getProfile();
    notifyListeners();
  }
}
