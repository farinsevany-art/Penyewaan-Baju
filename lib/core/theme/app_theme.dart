import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.offWhite,
      primaryColor: AppColors.primaryNavy,

      //default font
      fontFamily: 'Poppins',

      textTheme: const TextTheme(
        // displayLarge (H1)
        displayLarge: TextStyle(
          color: AppColors.darkGrey,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'PlayfairDisplay',
        ),

        // displayMedium (H2) menggunakan Playfair Display
        displayMedium: TextStyle(
          color: AppColors.darkGrey,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'PlayfairDisplay',
        ),

        // titleLarge (Judul Kecil/AppBar) menggunakan Playfair Display
        titleLarge: TextStyle(
          color: AppColors.darkGrey,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'PlayfairDisplay',
        ),

        // bodyLarge & bodySmall otomatis menggunakan Poppins dari root fontFamily
        bodyLarge: TextStyle(
          color: AppColors.darkGrey,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(color: AppColors.mediumGrey, fontSize: 12),
      ),

      // 2. Mengatur Tema Tombol agar konsisten pakai Poppins
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGold,
          foregroundColor: AppColors.primaryNavy,
          textStyle: const TextStyle(
            fontFamily: 'Poppins', // Memastikan tombol pakai Poppins
            fontWeight: FontWeight.bold,
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
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}
