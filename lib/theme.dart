import 'package:flutter/material.dart';

class AppColors {
  static const black = Colors.black;
  static const white = Colors.white;
  static const teal = Colors.teal;
  static const red = Colors.red;
  static const darkGrey = Color(0xFF1A1A1A);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.teal,
        onPrimary: AppColors.black,
        secondary: AppColors.white,
        onSecondary: AppColors.black,
        surface: AppColors.black,
        onSurface: AppColors.white,
        error: AppColors.red,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: AppColors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.darkGrey,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.teal,
        foregroundColor: AppColors.black,
        surfaceTintColor: AppColors.teal,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.teal,
        contentTextStyle: const TextStyle(color: AppColors.black),
        actionTextColor: AppColors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
