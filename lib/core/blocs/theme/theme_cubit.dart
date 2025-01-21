import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<bool> {
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(_prefs.getBool('isDarkMode') ?? false);

  void toggleTheme() {
    final newValue = !state;
    _prefs.setBool('isDarkMode', newValue);
    emit(newValue);
  }

  void setDarkMode(bool isDark) {
    _prefs.setBool('isDarkMode', isDark);
    emit(isDark);
  }
}
