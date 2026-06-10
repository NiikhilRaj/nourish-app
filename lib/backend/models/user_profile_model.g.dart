// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileModelAdapter extends TypeAdapter<UserProfileModel> {
  @override
  final int typeId = 0;

  @override
  UserProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfileModel(
      id: fields[0] as int,
      name: fields[1] as String?,
      age: fields[2] as int?,
      gender: fields[3] as String?,
      heightCm: fields[4] as double?,
      weightKg: fields[5] as double?,
      activityLevel: fields[6] as String?,
      calorieGoal: fields[7] as int?,
      proteinGoalG: fields[8] as int?,
      carbsGoalG: fields[9] as int?,
      fatGoalG: fields[10] as int?,
      createdAt: fields[11] as DateTime?,
      updatedAt: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfileModel obj) {
    writer
      ..writeByte(13)
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
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
