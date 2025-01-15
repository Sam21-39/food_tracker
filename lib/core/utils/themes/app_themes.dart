import 'package:flutter/material.dart';
import 'package:food_tracker/core/utils/colors/app_colors.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    error: AppColors.accent,
    inversePrimary: AppColors.secondaryText,
  ),
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.background,
  useMaterial3: true,
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryDark,
    primary: AppColors.primaryDark,
    secondary: AppColors.secondaryDark,
    error: AppColors.accentDark,
    inversePrimary: AppColors.secondaryTextDark,
  ),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.backgroundDark,
  useMaterial3: true,
);
