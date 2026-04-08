import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_pack.dart';
import 'app_theme.dart';

class ThemeController extends ChangeNotifier {

  ThemePack _currentPack = ThemePack.flowers;
  bool _isDarkMode = false;

  ThemePack get currentPack => _currentPack;
  bool get isDarkMode => _isDarkMode;

  ThemeController() {
    _loadTheme();
  }

  ThemeData get currentTheme {
    switch (_currentPack) {
      case ThemePack.flowers:
        return _isDarkMode ? AppTheme.flowersDark : AppTheme.flowersLight;
      case ThemePack.forest:
        return _isDarkMode ? AppTheme.forestDark : AppTheme.forestLight;
      case ThemePack.butterfly:
        return _isDarkMode ? AppTheme.butterflyDark : AppTheme.butterflyLight;
      case ThemePack.home:
        return _isDarkMode ? AppTheme.homeDark : AppTheme.homeLight;
    }
  }

  // ======================
  // CHANGE THEME PACK
  // ======================
  void setThemePack(ThemePack pack) async {
    _currentPack = pack;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString("themePack", pack.name);
  }

  // ======================
  // DARK MODE
  // ======================
  void toggleDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("darkMode", value);
  }

  // ======================
  // LOAD SAVED THEME
  // ======================
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final savedPack = prefs.getString("themePack");
    final savedDark = prefs.getBool("darkMode");

    if (savedPack != null) {
      _currentPack = ThemePack.values.firstWhere(
            (e) => e.name == savedPack,
        orElse: () => ThemePack.flowers,
      );
    }

    if (savedDark != null) {
      _isDarkMode = savedDark;
    }

    notifyListeners();
  }
}