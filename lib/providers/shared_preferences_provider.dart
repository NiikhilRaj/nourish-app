import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider extends ChangeNotifier {
  static const String _kIsDarkMode = 'isDarkMode';
  static const String _kPreferredLanguage = 'preferredLanguage';

  SharedPreferences? _prefs;

  bool _initialized = false;
  bool _isDarkMode = false;
  String _preferredLanguage = 'en';

  bool get initialized => _initialized;
  bool get isDarkMode => _isDarkMode;
  String get preferredLanguage => _preferredLanguage;

  Future<void> loadSettings() async {
    _prefs ??= await SharedPreferences.getInstance();

    // Read current bool flag if present; otherwise migrate legacy 'themeMode' string
    final persistedIsDark = _prefs?.getBool(_kIsDarkMode);
    if (persistedIsDark != null) {
      _isDarkMode = persistedIsDark;
    } else {
      final legacyTheme = _prefs?.getString('themeMode'); // 'dark' | 'light'
      if (legacyTheme != null) {
        _isDarkMode = legacyTheme == 'dark';
        await _prefs!.setBool(_kIsDarkMode, _isDarkMode);
        await _prefs!.remove('themeMode');
      } else {
        _isDarkMode = false;
      }
    }

    _preferredLanguage = _prefs?.getString(_kPreferredLanguage) ?? 'en';

    _initialized = true;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = _prefs ??= await SharedPreferences.getInstance();
    final success = await prefs.setBool(_kIsDarkMode, value);
    if (success) {
      _isDarkMode = value;
      notifyListeners();
    }
  }

  Future<void> toggleDarkMode() => setDarkMode(!_isDarkMode);

  Future<void> setPreferredLanguage(String language) async {
    _preferredLanguage = language;
    final prefs = _prefs ??= await SharedPreferences.getInstance();
    await prefs.setString(_kPreferredLanguage, language);
    notifyListeners();
  }

  Future<void> reset() async {
    final prefs = _prefs ??= await SharedPreferences.getInstance();
    final darkModeRemoved = await prefs.remove(_kIsDarkMode);
    final languageRemoved = await prefs.remove(_kPreferredLanguage);

    if (darkModeRemoved && languageRemoved) {
      _isDarkMode = false;
      _preferredLanguage = 'en';
      notifyListeners();
    } else {
      // Optionally handle the error, e.g., log or throw
      // debugPrint('Failed to reset SharedPreferences');
    }
  }
}