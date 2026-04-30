import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/splash_page.dart';
import 'features/customer/screens/home_page.dart'; 

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
      theme: AppTheme.lightTheme,
      
      // Halaman awal aplikasi
      home: const SplashPage(),

      // Daftar rute navigasi
      routes: {
        '/home': (context) => const CustomerHomePage(),
      },
    );
  }
}