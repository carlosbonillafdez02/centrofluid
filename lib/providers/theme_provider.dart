import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  static const String _themeKey = 'theme_preference';
  late SharedPreferences _prefs; // Declare SharedPreferences variable

  // Define el constructor para aceptar SharedPreferences
  ThemeProvider({required SharedPreferences prefs}) {
    _prefs = prefs; // Initialize SharedPreferences variable
    _loadTheme();
  }

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveTheme();
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    _isDarkMode = _prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    _prefs.setBool(_themeKey, _isDarkMode);
  }
}
