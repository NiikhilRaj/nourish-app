import 'package:hive_flutter/hive_flutter.dart';

// IMPORTANT: Make sure this path points to where your actual model file lives!
import 'models/user_profile_model.dart';

class DbService {
  DbService._();

  static final DbService instance = DbService._();

  // In Hive, we use "Boxes" instead of tables.
  static const String userProfileBoxName = 'user_profile';

  bool _isInitialized = false;

  /// Call this once in your main.dart before runApp()
  Future<void> init() async {
    if (_isInitialized) return;

    // Initializes Hive with the correct local directory for Flutter
    await Hive.initFlutter();

    // Register your data model adapter here
    Hive.registerAdapter(UserProfileModelAdapter());

    // Open the box so it is ready for synchronous read/write access later
    await Hive.openBox(userProfileBoxName);

    _isInitialized = true;
  }

  /// A synchronous getter to easily access your profile box anywhere
  Box get userProfileBox {
    if (!Hive.isBoxOpen(userProfileBoxName)) {
      throw Exception('Box $userProfileBoxName is not open. Call init() first.');
    }
    return Hive.box(userProfileBoxName);
  }
}