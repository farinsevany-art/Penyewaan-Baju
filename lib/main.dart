import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart'; // Import tema yang kita buat
import 'features/auth/screens/splash_page.dart'; // Import halaman splash

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kusuma Cantika Collections',
      debugShowCheckedModeBanner: false,

      // 1. Terapkan Tema Global yang sudah kita buat di Langkah 1
      theme: AppTheme.lightTheme,

      // 2. Arahkan halaman pertama yang muncul ke SplashPage
      home: const SplashPage(),
    );
  }
}
