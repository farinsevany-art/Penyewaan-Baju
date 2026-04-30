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
      
      // Halaman awal tetap SplashPage
      home: const SplashPage(),

      // TAMBAHKAN INI: Daftar alamat halaman
      routes: {
        '/home': (context) => const CustomerHomePage(),
        
      },
    );
  }
}