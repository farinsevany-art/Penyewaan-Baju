import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'auth_selection_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // State untuk kontrol animasi (Opacity)
  double _logoOpacity = 0.0;
  double _textOpacity = 0.0;
  double _buttonOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    // Splash 1: Munculkan Logo
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _logoOpacity = 1.0);

    // Splash 2: Munculkan Teks Brand
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _textOpacity = 1.0);

    // Final: Munculkan Tombol "Mulai"
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _buttonOpacity = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.offWhite, // Menggunakan warna dari Design System
      body: Stack(
        children: [
          // 1. Background Pattern (Opsional, jika ada file gambarnya)
          // Opacity 0.1 agar pola bunganya halus seperti di Figma
          Opacity(
            opacity: 1,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 2. Konten Utama
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Gabungan Logo dan Teks (Row)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // LOGO
                    AnimatedOpacity(
                      duration: const Duration(seconds: 1),
                      opacity: _logoOpacity,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          // color: AppColors
                          //     .primaryNavy, // Background Navy sesuai Figma
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.asset(
                          'assets/images/Logotransparan.png', // Logo versi emas
                          width: 80,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // TEKS BRAND
                    AnimatedOpacity(
                      duration: const Duration(seconds: 1),
                      opacity: _textOpacity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'KUSUMA',
                            style: Theme.of(context).textTheme.displayMedium
                                ?.copyWith(
                                  color: AppColors.primaryNavy,
                                  letterSpacing: 2,
                                ),
                          ),
                          Text(
                            'CANTIKA',
                            style: Theme.of(context).textTheme.displayMedium
                                ?.copyWith(
                                  color: AppColors.primaryNavy,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const Text(
                            'COLLECTIONS',
                            style: TextStyle(
                              color: AppColors.mediumGrey,
                              letterSpacing: 4,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 100),

                // 3. TOMBOL MULAI
                AnimatedOpacity(
                  duration: const Duration(seconds: 1),
                  opacity: _buttonOpacity,
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryGold, AppColors.lightGold],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGold.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthSelectionPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        'Mulai',
                        style: TextStyle(
                          color: AppColors.primaryNavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
