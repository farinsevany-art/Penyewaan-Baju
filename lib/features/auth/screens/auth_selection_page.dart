import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../widgets/auth_background.dart';
import 'login_form_page.dart'; // Nanti kita buat ini
import 'success_page.dart'; // Nanti kita buat ini
import 'register_page.dart'; // Nanti kita buat ini

class AuthSelectionPage extends StatelessWidget {
  const AuthSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo & Brand
              Image.asset('assets/images/Logotransparan.png', width: 120),
              const SizedBox(height: 20),
              Text(
                'KUSUMA\nCANTIKA',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.primaryNavy,
                  fontFamily: 'PlayfairDisplay',
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Create your fashion\nin your own way',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 40),

              // Tombol Login
              _buildGoldButton('Login', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginFormPage(),
                  ),
                );
              }),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  '— Atau —',
                  style: TextStyle(color: AppColors.mediumGrey),
                ),
              ),

              // Tombol Register
              // Cari bagian Tombol Register, ubah onPressed-nya:
              _buildGoldButton('Register', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoldButton(String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryGold, AppColors.lightGold],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.primaryNavy,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
