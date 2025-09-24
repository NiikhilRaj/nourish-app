// lib/models/recipe.dart
import 'package:hive/hive.dart';

part 'recipe.g.dart';

@HiveType(typeId: 0)
class Recipe extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
  });

  @override
  String toString() => 'Recipe(id:$id, title:$title)';
}
