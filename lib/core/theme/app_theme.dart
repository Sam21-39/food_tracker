import 'package:flutter/material.dart';

class AppColors {
  // Primary Color - Emerald Green
  static const primaryLight = Color(0xFF58D68D);
  static const primary = Color(0xFF2ECC71);
  static const primaryDark = Color(0xFF28A745);
  static const primaryMuted = Color(0xFFA9DFBF);

  // Secondary Color - Cream White
  static const secondaryLight = Color(0xFFFFFFFF);
  static const secondary = Color(0xFFFDFEFE);
  static const secondaryDark = Color(0xFFF4F6F7);
  static const secondaryMuted = Color(0xFFE5E8E8);

  // Accent Color - Tangerine Orange
  static const accentLight = Color(0xFFF8C471);
  static const accent = Color(0xFFF39C12);
  static const accentDark = Color(0xFFD68910);
  static const accentMuted = Color(0xFFFAD7A0);

  // Neutral Color - Slate Gray
  static const neutralLight = Color(0xFF5D6D7E);
  static const neutral = Color(0xFF34495E);
  static const neutralDark = Color(0xFF2C3E50);
  static const neutralMuted = Color(0xFFBDC3C7);
}

class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryMuted,
      onPrimaryContainer: AppColors.primaryDark,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.accentMuted,
      onSecondaryContainer: AppColors.accentDark,
      surface: AppColors.secondary,
      onSurface: AppColors.neutral,
      surfaceContainer: AppColors.secondaryMuted,
      surfaceContainerHigh: AppColors.secondaryDark,
      surfaceContainerHighest: AppColors.secondary,
      surfaceContainerLow: AppColors.secondaryLight,
      surfaceContainerLowest: AppColors.secondaryLight,
      error: Colors.red,
      onError: Colors.white,
      outline: AppColors.neutralMuted,
      outlineVariant: AppColors.neutralLight,
      scrim: AppColors.neutralDark.withOpacity(0.3),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: Colors.white,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardTheme(
      color: AppColors.secondary,
      elevation: 2,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.secondaryDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.neutralMuted),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.secondaryDark,
      selectedColor: AppColors.primaryMuted,
      labelStyle: TextStyle(color: AppColors.neutral),
    ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.neutralDark,
      primaryContainer: AppColors.primary,
      onPrimaryContainer: Colors.white,
      secondary: AppColors.accentLight,
      onSecondary: AppColors.neutralDark,
      secondaryContainer: AppColors.accent,
      onSecondaryContainer: Colors.white,
      surface: AppColors.neutralDark,
      onSurface: AppColors.secondaryLight,
      surfaceContainer: AppColors.neutral,
      surfaceContainerHigh: AppColors.neutralDark,
      surfaceContainerHighest: AppColors.neutralDark,
      surfaceContainerLow: AppColors.neutralLight,
      surfaceContainerLowest: AppColors.neutralLight,
      error: Colors.redAccent,
      onError: Colors.white,
      outline: AppColors.neutralLight,
      outlineVariant: AppColors.neutralMuted,
      scrim: Colors.black.withOpacity(0.3),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.neutralDark,
      foregroundColor: Colors.white,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardTheme(
      color: AppColors.neutral,
      elevation: 2,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentLight,
      foregroundColor: AppColors.neutralDark,
      elevation: 4,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.neutral,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.neutralLight),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.neutral,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(color: AppColors.secondaryLight),
    ),
  );
}
