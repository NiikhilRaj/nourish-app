import 'package:hive/hive.dart';

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
