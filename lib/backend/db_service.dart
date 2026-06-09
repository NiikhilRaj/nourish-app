import 'package:sqflite/sqflite.dart';

class DbService {
  DbService._();

  static final DbService instance = DbService._();

  static const String databaseName = 'nourish_app.db';
  static const int databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    final existingDatabase = _database;
    if (existingDatabase != null) return existingDatabase;

    final databasePath = await getDatabasesPath();
    final path = '$databasePath/$databaseName';

    _database = await openDatabase(
      path,
      version: databaseVersion,
      onCreate: _onCreate,
      onOpen: _ensureSchema,
    );

    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await _ensureSchema(db);
  }

  Future<void> _ensureSchema(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_profile (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        name TEXT,
        age INTEGER,
        gender TEXT,
        height_cm REAL,
        weight_kg REAL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    await _ensureColumn(db, 'user_profile', 'gender', 'TEXT');
    await _ensureColumn(db, 'user_profile', 'height_cm', 'REAL');
    await _ensureColumn(db, 'user_profile', 'weight_kg', 'REAL');
  }

  Future<void> _ensureColumn(
    Database db,
    String tableName,
    String columnName,
    String columnType,
  ) async {
    final columns = await db.rawQuery('PRAGMA table_info($tableName)');
    final hasColumn = columns.any((column) => column['name'] == columnName);
    if (hasColumn) return;

    await db.execute(
      'ALTER TABLE $tableName ADD COLUMN $columnName $columnType',
    );
  }
}
