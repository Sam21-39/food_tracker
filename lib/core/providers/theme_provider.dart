import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateProvider<bool>((ref) {
  // Default to system theme (false = light mode)
  return false;
});

// Initialize theme from SharedPreferences
Future<void> initializeTheme(WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  ref.read(themeProvider.notifier).state = isDarkMode;
}

// Save theme preference when it changes
Future<void> saveThemePreference(bool isDarkMode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isDarkMode', isDarkMode);
}
