import 'package:flutter/material.dart';

class AppColors {
  static const black = Colors.black;
  static const white = Colors.white;
  static const teal = Colors.teal;
  static const red = Colors.red;
  static const grey = Colors.grey;
  static final darkGrey = Colors.grey.shade900;
}

class AppSizes {
  static const xs = 5.0;
  static const s = 10.0;
  static const m = 20.0;
  static const l = 40.0;
  static const xl = 80.0;
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

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.teal,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.s),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.all(AppSizes.s),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.s),
          ),
        ),
      ),

      // Elevated Button Theme
      textButtonTheme: TextButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.all(AppSizes.s),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.s),
          ),
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkGrey,
        padding: const EdgeInsets.all(AppSizes.s),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.m),
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
        foregroundColor: AppColors.white,
        surfaceTintColor: AppColors.teal,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.white,
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
