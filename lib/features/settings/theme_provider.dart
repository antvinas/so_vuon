import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _themeModeKey = 'themeMode';

// Provider for managing the theme mode of the app
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  // Load the saved theme from shared preferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeModeKey) ?? ThemeMode.system.index;
    state = ThemeMode.values[themeIndex];
  }

  // Change and save the theme
  Future<void> changeTheme(ThemeMode themeMode) async {
    if (state == themeMode) return;

    state = themeMode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeModeKey, themeMode.index);
    } catch (e) {
      // Handle errors, e.g., by logging them
      debugPrint("Failed to save theme: $e");
    }
  }
}
