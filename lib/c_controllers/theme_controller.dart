import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController with ChangeNotifier {
  static const _themePrefKey = 'themeMode';
  ThemeMode _themeMode = ThemeMode.light; // Inicia com o tema claro como padrão

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeController() {
    _loadThemeMode();
  }

  // Carrega a preferência de tema do usuário
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    // Lê a preferência salva. Se for 'dark', usa o tema escuro, senão, o claro.
    final themeString = prefs.getString(_themePrefKey);
    _themeMode = themeString == 'dark' ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Alterna entre os temas claro e escuro
  Future<void> toggleTheme() async {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePrefKey, _themeMode.name);
    notifyListeners();
  }
}
