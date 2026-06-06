import 'package:flutter/material.dart';
import 'shared_preferences_provider.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  SharedPreferencesProvider? _sp;
  bool _syncedOnce = false;

  ThemeMode get themeMode => _themeMode;

  /// Integrates this provider with [SharedPreferencesProvider].
  ///
  /// This method is invoked by [ChangeNotifierProxyProvider] whenever the
  /// [SharedPreferencesProvider] instance changes. It connects this
  /// [ThemeProvider] to the shared preferences provider, synchronizes the
  /// theme mode with the value stored in shared preferences, and notifies
  /// listeners if the theme mode changes.
  void attach(SharedPreferencesProvider sp) {
    _sp = sp;
    final modeFromPrefs = sp.isDarkMode ? ThemeMode.dark : ThemeMode.light;

    if (!_syncedOnce || modeFromPrefs != _themeMode) {
      _themeMode = modeFromPrefs;
      notifyListeners();
    }
    _syncedOnce = true;
  }

  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;

    final sp = _sp;
    if (sp != null) {
      await sp.setDarkMode(mode == ThemeMode.dark);
    }
    notifyListeners();
  }
}