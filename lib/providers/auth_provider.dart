import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String _profileImageUrl = '';
  String _userName = 'User';

  String get profileImageUrl => _profileImageUrl;
  String get userName => _userName;

  void updateProfileImage(String url) {
    _profileImageUrl = url;
    notifyListeners();
  }

  void updateUserName(String name) {
    _userName = name;
    notifyListeners();
  }
}
