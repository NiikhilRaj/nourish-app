import 'package:hive/hive.dart';

class SavedRecipeModel {
  final String id;
  final String title;
  final List<String> ingredients;
  final List<String> instructions;
  final String imageUrl;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  SavedRecipeModel({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.imageUrl,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  SavedRecipeModel copyWith({
    String? id,
    String? title,
    List<String>? ingredients,
    List<String>? instructions,
    String? imageUrl,
    int? calories,
    int? protein,
    int? carbs,
    int? fat,
  }) {
    return SavedRecipeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      imageUrl: imageUrl ?? this.imageUrl,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
    );
  }
}

class SavedRecipeAdapter extends TypeAdapter<SavedRecipeModel> {
  @override
  final int typeId = 4;

  @override
  SavedRecipeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedRecipeModel(
      id: fields[0] as String? ?? '',
      title: fields[1] as String? ?? '',
      ingredients: (fields[2] as List?)?.cast<String>() ?? <String>[],
      instructions: (fields[3] as List?)?.cast<String>() ?? <String>[],
      imageUrl: fields[4] as String? ?? '',
      calories: fields[5] as int? ?? 0,
      protein: fields[6] as int? ?? 0,
      carbs: fields[7] as int? ?? 0,
      fat: fields[8] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, SavedRecipeModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.ingredients)
      ..writeByte(3)
      ..write(obj.instructions)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.calories)
      ..writeByte(6)
      ..write(obj.protein)
      ..writeByte(7)
      ..write(obj.carbs)
      ..writeByte(8)
      ..write(obj.fat);
  }
}
