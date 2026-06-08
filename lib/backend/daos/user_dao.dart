import 'package:hive/hive.dart';
import '../hive_service.dart';
import '../models.dart';

class UserDao {
  static Box<UserModel> get _box => Hive.box<UserModel>(HiveService.userBoxName);

  static UserModel? getUser() {
    return _box.get('current_user');
  }

  static Future<void> saveUser(UserModel user) async {
    await _box.put('current_user', user);
  }

  static Future<void> deleteUser() async {
    await _box.delete('current_user');
  }
}