import 'package:sqflite/sqflite.dart';

import '../db_service.dart';
import '../models/user_profile_model.dart';

class UserDao {
  UserDao({DbService? dbService})
    : _dbService = dbService ?? DbService.instance;

  final DbService _dbService;

  static const String tableName = 'user_profile';

  Future<UserProfileModel?> getProfile() async {
    final db = await _dbService.database;
    final rows = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: const [1],
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return UserProfileModel.fromMap(rows.first);
  }

  Future<void> upsertName(String name) async {
    await _upsert({'name': name.trim()});
  }

  Future<void> upsertAge(int age) async {
    await _upsert({'age': age});
  }

  Future<void> upsertGender(String gender) async {
    await _upsert({'gender': gender});
  }

  Future<void> upsertBodyMetrics({
    required double heightCm,
    required double weightKg,
  }) async {
    await _upsert({'height_cm': heightCm, 'weight_kg': weightKg});
  }

  Future<void> upsertActivityLevel(String activityLevel) async {
    await _upsert({'activity_level': activityLevel});
  }

  Future<void> upsertMacroGoals({
    required int calories,
    required int proteinG,
    required int carbsG,
    required int fatG,
  }) async {
    await _upsert({
      'calorie_goal': calories,
      'protein_goal_g': proteinG,
      'carbs_goal_g': carbsG,
      'fat_goal_g': fatG,
    });
  }

  Future<void> upsertProfile(UserProfileModel profile) async {
    await _upsert(
      profile.toMap()
        ..remove('id')
        ..remove('created_at')
        ..remove('updated_at'),
    );
  }

  Future<void> _upsert(Map<String, Object?> values) async {
    final db = await _dbService.database;
    final now = DateTime.now().toIso8601String();
    final existingProfile = await getProfile();

    if (existingProfile == null) {
      await db.insert(tableName, {
        'id': 1,
        'created_at': now,
        'updated_at': now,
        ...values,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      return;
    }

    await db.update(
      tableName,
      {...values, 'updated_at': now},
      where: 'id = ?',
      whereArgs: const [1],
    );
  }
}
