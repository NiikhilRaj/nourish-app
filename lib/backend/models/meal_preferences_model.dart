import 'package:hive/hive.dart';

class MealPreferencesModel {
  final int targetCalories;
  final int targetProtein;
  final int targetCarbs;
  final int targetFat;

  MealPreferencesModel({
    required this.targetCalories,
    required this.targetProtein,
    required this.targetCarbs,
    required this.targetFat,
  });

  MealPreferencesModel copyWith({
    int? targetCalories,
    int? targetProtein,
    int? targetCarbs,
    int? targetFat,
  }) {
    return MealPreferencesModel(
      targetCalories: targetCalories ?? this.targetCalories,
      targetProtein: targetProtein ?? this.targetProtein,
      targetCarbs: targetCarbs ?? this.targetCarbs,
      targetFat: targetFat ?? this.targetFat,
    );
  }
}

class MealPreferencesAdapter extends TypeAdapter<MealPreferencesModel> {
  @override
  final int typeId = 2;

  @override
  MealPreferencesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealPreferencesModel(
      targetCalories: fields[0] as int? ?? 0,
      targetProtein: fields[1] as int? ?? 0,
      targetCarbs: fields[2] as int? ?? 0,
      targetFat: fields[3] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, MealPreferencesModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.targetCalories)
      ..writeByte(1)
      ..write(obj.targetProtein)
      ..writeByte(2)
      ..write(obj.targetCarbs)
      ..writeByte(3)
      ..write(obj.targetFat);
  }
}
