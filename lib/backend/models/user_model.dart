import 'package:hive/hive.dart';

class UserModel {
  final int id;
  final String name;
  final int age;
  final String gender;
  final double heightCm;
  final double weightKg;
  final String activityLevel;
  final int? calorieGoal;
  final int? proteinGoalG;
  final int? carbsGoalG;
  final int? fatGoalG;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? dob;
  final String? profilePhotoBase64;

  UserModel({
    this.id = 1,
    required this.name,
    required this.age,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
    required this.activityLevel,
    this.calorieGoal,
    this.proteinGoalG,
    this.carbsGoalG,
    this.fatGoalG,
    this.createdAt,
    this.updatedAt,
    this.dob,
    this.profilePhotoBase64,
  });

  UserModel copyWith({
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
    String? dob,
    String? profilePhotoBase64,
  }) {
    return UserModel(
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
      dob: dob ?? this.dob,
      profilePhotoBase64: profilePhotoBase64 ?? this.profilePhotoBase64,
    );
  }
}

class UserAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as int? ?? 1,
      name: fields[1] as String? ?? '',
      age: fields[2] as int? ?? 0,
      gender: fields[3] as String? ?? '',
      heightCm: (fields[4] as num? ?? 0.0).toDouble(),
      weightKg: (fields[5] as num? ?? 0.0).toDouble(),
      activityLevel: fields[6] as String? ?? '',
      calorieGoal: fields[7] as int?,
      proteinGoalG: fields[8] as int?,
      carbsGoalG: fields[9] as int?,
      fatGoalG: fields[10] as int?,
      createdAt: fields[11] as DateTime?,
      updatedAt: fields[12] as DateTime?,
      dob: fields[13] as String?,
      profilePhotoBase64: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.heightCm)
      ..writeByte(5)
      ..write(obj.weightKg)
      ..writeByte(6)
      ..write(obj.activityLevel)
      ..writeByte(7)
      ..write(obj.calorieGoal)
      ..writeByte(8)
      ..write(obj.proteinGoalG)
      ..writeByte(9)
      ..write(obj.carbsGoalG)
      ..writeByte(10)
      ..write(obj.fatGoalG)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.dob)
      ..writeByte(14)
      ..write(obj.profilePhotoBase64);
  }
}
