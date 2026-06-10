import '../db_service.dart';
import '../models/user_profile_model.dart';

class UserDao {
  UserDao({DbService? dbService})
      : _dbService = dbService ?? DbService.instance;

  final DbService _dbService;

  // Since Hive is a key-value store, we just need a single key
  // to save and retrieve the user's profile.
  static const String profileKey = 'current_user';

  Future<UserProfileModel?> getProfile() async {
    // Hive box reads are instant (synchronous), but we keep the Future
    // return type here so we don't break your existing app architecture!
    final box = _dbService.userProfileBox;
    return box.get(profileKey) as UserProfileModel?;
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
    await _updateProfile((profile) => profile.copyWith(
      heightCm: heightCm,
      weightKg: weightKg,
    ));
  }

  Future<void> upsertActivityLevel(String activityLevel) async {
    await _updateProfile((profile) => profile.copyWith(activityLevel: activityLevel));
  }

  Future<void> upsertMacroGoals({
    required int calories,
    required int proteinG,
    required int carbsG,
    required int fatG,
  }) async {
    await _updateProfile((profile) => profile.copyWith(
      calorieGoal: calories,
      proteinGoalG: proteinG,
      carbsGoalG: carbsG,
      fatGoalG: fatG,
    ));
  }

  Future<void> upsertProfile(UserProfileModel profile) async {
    await _updateProfile((_) => profile);
  }

  /// The new heart of the DAO. Instead of raw SQL maps, it takes a function
  /// that modifies the current profile object using `copyWith`.
  Future<void> _updateProfile(UserProfileModel Function(UserProfileModel) updateFn) async {
    final box = _dbService.userProfileBox;

    // 1. Fetch the existing profile, or create a blank one if it doesn't exist yet
    final currentProfile = box.get(profileKey) as UserProfileModel? ?? const UserProfileModel();

    // 2. Apply the requested updates
    UserProfileModel updatedProfile = updateFn(currentProfile);

    // 3. Automatically handle timestamps
    final now = DateTime.now();
    updatedProfile = updatedProfile.copyWith(
      createdAt: currentProfile.createdAt ?? now,
      updatedAt: now,
    );

    // 4. Save the modified object back to Hive (this replaces the old object entirely)
    // We use put() instead of putAt() so we can retrieve it by the string key later.
    await box.put(profileKey, updatedProfile);
  }
}