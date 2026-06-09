class UserProfileModel {
  const UserProfileModel({
    this.id = 1,
    this.name,
    this.age,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String? name;
  final int? age;
  final String? gender;
  final double? heightCm;
  final double? weightKg;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfileModel copyWith({
    int? id,
    String? name,
    int? age,
    String? gender,
    double? heightCm,
    double? weightKg,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory UserProfileModel.fromMap(Map<String, Object?> map) {
    return UserProfileModel(
      id: map['id'] as int? ?? 1,
      name: map['name'] as String?,
      age: map['age'] as int?,
      gender: map['gender'] as String?,
      heightCm: _parseDouble(map['height_cm']),
      weightKg: _parseDouble(map['weight_kg']),
      createdAt: _parseDate(map['created_at']),
      updatedAt: _parseDate(map['updated_at']),
    );
  }

  static DateTime? _parseDate(Object? value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  static double? _parseDouble(Object? value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
