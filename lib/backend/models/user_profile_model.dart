import 'package:hive/hive.dart';

// This part directive is crucial for the generator!
part 'user_profile_model.g.dart';

@HiveType(typeId: 0)
class UserProfileModel {
  const UserProfileModel({
    this.id = 1,
    this.name,
    this.age,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.activityLevel,
    this.calorieGoal,
    this.proteinGoalG,
    this.carbsGoalG,
    this.fatGoalG,
    this.createdAt,
    this.updatedAt,
  });

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final int? age;

  @HiveField(3)
  final String? gender;

  @HiveField(4)
  final double? heightCm;

  @HiveField(5)
  final double? weightKg;

  @HiveField(6)
  final String? activityLevel;

  @HiveField(7)
  final int? calorieGoal;

  @HiveField(8)
  final int? proteinGoalG;

  @HiveField(9)
  final int? carbsGoalG;

  @HiveField(10)
  final int? fatGoalG;

  @HiveField(11)
  final DateTime? createdAt;

  @HiveField(12)
  final DateTime? updatedAt;

  UserProfileModel copyWith({
    int? id,
    String? name,
    int? age,
    String? gender,
    double? heightCm,
    double? weightKg,
    String? activityLevel,
    int? calorieGoal,
    int? proteinGoalG,
    int? carbsGoalG,
    int? fatGoalG,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      calorieGoal: calorieGoal ?? this.calorieGoal,
      proteinGoalG: proteinGoalG ?? this.proteinGoalG,
      carbsGoalG: carbsGoalG ?? this.carbsGoalG,
      fatGoalG: fatGoalG ?? this.fatGoalG,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}