import 'package:hive/hive.dart';
import '../db_service.dart';
import '../models/user_model.dart';

class UserDao {
  // === INSTANCE CONFIGURATION ===
  UserDao({DbService? dbService})
    : _dbService = dbService ?? DbService.instance;

  final DbService _dbService;
  static const String profileKey = 'current_user';

  // === UNIFIED STATIC BOX GETTER ===
  // Points the team's features to your exact Hive box layout
  static Box get _staticBox => DbService.instance.userProfileBox;

  // === REDIRECTED TEAM METHODS ===
  static UserModel? getUser() {
    return _staticBox.get(profileKey) as UserModel?;
  }

  static Future<void> saveUser(UserModel user) async {
    await _staticBox.put(profileKey, user);
  }

  static Future<void> deleteUser() async {
    await _staticBox.delete(profileKey);
  }

  // === YOUR ONBOARDING INSTANCE METHODS ===
  Future<UserModel?> getProfile() async {
    final box = _dbService.userProfileBox;
    return box.get(profileKey) as UserModel?;
  }

  Future<void> upsertName(String name) async {
    await _updateProfile((profile) => profile.copyWith(name: name.trim()));
  }

  Future<void> upsertAge(int age) async {
    await _updateProfile((profile) => profile.copyWith(age: age));
  }

  Future<void> upsertGender(String gender) async {
    await _updateProfile((profile) => profile.copyWith(gender: gender));
  }

  Future<void> upsertBodyMetrics({
    required double heightCm,
    required double weightKg,
  }) async {
    await _updateProfile(
      (profile) => profile.copyWith(heightCm: heightCm, weightKg: weightKg),
    );
  }

  Future<void> upsertActivityLevel(String activityLevel) async {
    await _updateProfile(
      (profile) => profile.copyWith(activityLevel: activityLevel),
    );
  }

  Future<void> upsertMacroGoals({
    required int calories,
    required int proteinG,
    required int carbsG,
    required int fatG,
  }) async {
    await _updateProfile(
      (profile) => profile.copyWith(
        calorieGoal: calories,
        proteinGoalG: proteinG,
        carbsGoalG: carbsG,
        fatGoalG: fatG,
      ),
    );
  }

  Future<void> upsertProfile(UserModel profile) async {
    await _updateProfile((_) => profile);
  }

  Future<void> _updateProfile(UserModel Function(UserModel) updateFn) async {
    final box = _dbService.userProfileBox;
    final currentProfile =
        box.get(profileKey) as UserModel? ??
        UserModel(
          name: '',
          age: 0,
          gender: '',
          heightCm: 0.0,
          weightKg: 0.0,
          activityLevel: '',
        );

    UserModel updatedProfile = updateFn(currentProfile);

    final now = DateTime.now();
    updatedProfile = updatedProfile.copyWith(
      createdAt: currentProfile.createdAt ?? now,
      updatedAt: now,
    );

    await box.put(profileKey, updatedProfile);
  }
}
