import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../backend/db_service.dart';

class DbProvider extends ChangeNotifier {
  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await DbService.instance.database;
    notifyListeners();
    return _db!;
  }
}
