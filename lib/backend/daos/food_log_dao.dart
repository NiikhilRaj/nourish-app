import 'package:hive/hive.dart';
import '../hive_service.dart';
import '../models.dart';

class FoodLogDao {
  static Box<FoodLogModel> get _box => Hive.box<FoodLogModel>(HiveService.foodLogBoxName);

  static List<FoodLogModel> getAllLogs() {
    return _box.values.toList();
  }

  static List<FoodLogModel> getLogsByDate(DateTime date) {
    return _box.values.where((log) {
      return log.date.year == date.year &&
             log.date.month == date.month &&
             log.date.day == date.day;
    }).toList();
  }

  static Future<void> saveLog(FoodLogModel log) async {
    await _box.put(log.id, log);
  }

  static Future<void> deleteLog(String id) async {
    await _box.delete(id);
  }

  static Future<void> clearAll() async {
    await _box.clear();
  }
}