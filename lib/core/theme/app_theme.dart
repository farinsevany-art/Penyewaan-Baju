import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.offWhite,
      primaryColor: AppColors.primaryNavy,

      // default font untuk seluruh aplikasi
      fontFamily: 'Poppins',

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.darkGrey,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'PlayfairDisplay',
        ),
        displayMedium: TextStyle(
          color: AppColors.darkGrey,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          fontFamily: 'PlayfairDisplay',
        ),
        displaySmall: TextStyle(
          color: AppColors.darkGrey,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'PlayfairDisplay',
        ),
        titleLarge: TextStyle(
          color: AppColors.darkGrey,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'PlayfairDisplay',
        ),
        titleMedium: TextStyle(
          color: AppColors.darkGrey,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: AppColors.darkGrey,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.darkGrey,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: AppColors.darkGrey,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: AppColors.mediumGrey,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          color: AppColors.primaryNavy,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: TextStyle(
          color: AppColors.mediumGrey,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGold,
          foregroundColor: AppColors.primaryNavy,
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // 3. Mengatur AppBar agar default pakai Playfair Display
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'PlayfairDisplay',
          color: AppColors.primaryGold,
          fontSize: 20,
          // fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}
