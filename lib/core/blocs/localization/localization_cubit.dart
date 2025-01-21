import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationCubit extends Cubit<Locale> {
  final SharedPreferences _prefs;
  static const String _localeKey = 'locale';
  static const List<Locale> _supportedLocales = [
    Locale('en'),
    Locale('es'),
    // Add more supported locales here
  ];

  LocalizationCubit(this._prefs)
      : super(Locale(_prefs.getString(_localeKey) ?? 'en'));

  List<Locale> get supportedLocales => _supportedLocales;

  void setLocale(Locale locale) {
    if (_supportedLocales.contains(locale)) {
      _prefs.setString(_localeKey, locale.languageCode);
      emit(locale);
    }
  }
}
