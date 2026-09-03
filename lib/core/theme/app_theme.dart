import 'package:flutter/material.dart';

import 'app_colors.dart';

/// App-wide ThemeData — light theme matching the design.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,

      scaffoldBackgroundColor: AppColors.scaffoldBackground,

      colorScheme: const ColorScheme.light(
        primary: AppColors.sidebarActive,
        secondary: AppColors.accentGold,
        surface: AppColors.cardBackground,
        onPrimary: AppColors.sidebarActiveText,
        onSurface: AppColors.textPrimary,
      ),

      // Use Flutter's built-in font.
      // This avoids downloading fonts at runtime.
      textTheme: const TextTheme(),

      cardTheme: const CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: 0,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: AppColors.inputBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: AppColors.inputBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: AppColors.sidebarActive,
            width: 1.5,
          ),
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.sidebarBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }
}