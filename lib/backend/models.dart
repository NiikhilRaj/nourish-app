import 'package:hive/hive.dart';

// ==========================================
// 1. UserModel & Adapter
// ==========================================
class UserModel {
  final String name;
  final int age;
  final String gender;
  final double weight;
  final double height;
  final String activityLevel;
  final String? profilePhotoBase64;
  final String? dob;

  UserModel({
    required this.name,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.activityLevel,
    this.profilePhotoBase64,
    this.dob,
  });

  UserModel copyWith({
    String? name,
    int? age,
    String? gender,
    double? weight,
    double? height,
    String? activityLevel,
    String? profilePhotoBase64,
    String? dob,
  }) {
    return UserModel(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      activityLevel: activityLevel ?? this.activityLevel,
      profilePhotoBase64: profilePhotoBase64 ?? this.profilePhotoBase64,
      dob: dob ?? this.dob,
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
      name: fields[0] as String? ?? '',
      age: fields[1] as int? ?? 0,
      gender: fields[2] as String? ?? '',
      weight: (fields[3] as num? ?? 0.0).toDouble(),
      height: (fields[4] as num? ?? 0.0).toDouble(),
      activityLevel: fields[5] as String? ?? '',
      profilePhotoBase64: fields[6] as String?,
      dob: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.age)
      ..writeByte(2)
      ..write(obj.gender)
      ..writeByte(3)
      ..write(obj.weight)
      ..writeByte(4)
      ..write(obj.height)
      ..writeByte(5)
      ..write(obj.activityLevel)
      ..writeByte(6)
      ..write(obj.profilePhotoBase64)
      ..writeByte(7)
      ..write(obj.dob);
  }
}

// ==========================================
// 2. MealPreferencesModel & Adapter
// ==========================================
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
      targetCalories: fields[0] as int? ?? 2000,
      targetProtein: fields[1] as int? ?? 150,
      targetCarbs: fields[2] as int? ?? 200,
      targetFat: fields[3] as int? ?? 70,
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

// ==========================================
// 3. FoodLogModel & Adapter
// ==========================================
class FoodLogModel {
  final String id;
  final DateTime date;
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String mealType; // breakfast, lunch, dinner, snack

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
      date: fields[1] as DateTime? ?? DateTime.now(),
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

// ==========================================
// 4. SavedRecipeModel & Adapter
// ==========================================
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
