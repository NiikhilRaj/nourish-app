import 'package:hive/hive.dart';

class FoodLogModel {
  final String id;
  final DateTime date;
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String mealType;

  FoodLogModel({
    required this.id,
    required this.date,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.mealType,
  });

  FoodLogModel copyWith({
    String? id,
    DateTime? date,
    String? name,
    int? calories,
    int? protein,
    int? carbs,
    int? fat,
    String? mealType,
  }) {
    return FoodLogModel(
      id: id ?? this.id,
      date: date ?? this.date,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      mealType: mealType ?? this.mealType,
    );
  }
}

class FoodLogAdapter extends TypeAdapter<FoodLogModel> {
  @override
  final int typeId = 3;

  @override
  FoodLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodLogModel(
      id: fields[0] as String? ?? '',
      date: fields[1] as DateTime? ?? DateTime.fromMillisecondsSinceEpoch(0),
      name: fields[2] as String? ?? '',
      calories: fields[3] as int? ?? 0,
      protein: fields[4] as int? ?? 0,
      carbs: fields[5] as int? ?? 0,
      fat: fields[6] as int? ?? 0,
      mealType: fields[7] as String? ?? 'breakfast',
    );
  }

  @override
  void write(BinaryWriter writer, FoodLogModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.calories)
      ..writeByte(4)
      ..write(obj.protein)
      ..writeByte(5)
      ..write(obj.carbs)
      ..writeByte(6)
      ..write(obj.fat)
      ..writeByte(7)
      ..write(obj.mealType);
  }
}
