import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Ambil ukuran tinggi layar asli HP (mengabaikan keyboard)
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // HARUS TRUE agar form login bisa terdorong naik saat mengetik
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.offWhite,
      body: Stack(
        children: [
          // 🔻 BACKGROUND DIKUNCI SECARA ABSOLUT 🔻
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight, // Kunci persis setinggi layar asli HP
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover, // Gambar dijamin kaku seperti batu!
            ),
          ),

          // KONTEN APLIKASI
          SafeArea(child: child),
        ],
      ),
    );
  }
}
