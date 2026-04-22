import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.offWhite,
      primaryColor: AppColors.primaryNavy,

      textTheme: const TextTheme(
        // Untuk H1
        displayLarge: TextStyle(
          color: AppColors.darkGrey,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Serif',
        ),
        // Untuk H2
        displayMedium: TextStyle(
          color: AppColors.darkGrey,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Serif',
        ),
        bodyLarge: TextStyle(
          color: AppColors.darkGrey,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(color: AppColors.mediumGrey, fontSize: 12),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGold,
          foregroundColor: AppColors.primaryNavy,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
