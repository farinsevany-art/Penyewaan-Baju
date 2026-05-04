import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../widgets/auth_background.dart';
import '../../customer/screens/home_page.dart';
import '../../admin/screens/admin_dashboard_page.dart';

class LoginFormPage extends StatelessWidget {
  const LoginFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header Kecil di Atas
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/Logotransparan.png', width: 40),
                const SizedBox(width: 10),
                const Text(
                  'KUSUMA CANTIKA',
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),

            // Kartu Login
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField('Username'),
                    const SizedBox(height: 20),
                    _buildTextField('Password', isObscure: true),
                    const SizedBox(height: 40),

                    // Tombol Login Pelanggan (Sudah diperbaiki navigasinya)
                    _buildLoginButton(
                      'Login Pelanggan',
                      AppColors.primaryGold,
                      () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CustomerHomePage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 15),

                    // Tombol Login Admin
                    _buildLoginButton('Login Admin', AppColors.primaryGold, () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminDashboardPage(),
                        ), // Kata const dihapus
                      );
                    }),

                    const SizedBox(height: 20),
                    Center(
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: AppColors.mediumGrey,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                          children: [
                            TextSpan(text: 'Belum punya akun? '),
                            TextSpan(
                              text: 'Daftar di sini',
                              style: TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method Helper untuk Input Field
  Widget _buildTextField(String hint, {bool isObscure = false}) {
    return TextField(
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.offWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Method Helper untuk Membuat Tombol (Definisi Fungsi)
  Widget _buildLoginButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
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
