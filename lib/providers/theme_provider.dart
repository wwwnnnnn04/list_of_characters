import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeProvider() {
    _loadTheme();
  }
  void toggleTheme() {
    _isDark = !_isDark;
    _saveTheme();
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    var box = await Hive.openBox('settings');
    _isDark = box.get('isDark', defaultValue: false);
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    var box = await Hive.openBox('settings');
    await box.put('isDark', _isDark);
  }
}
