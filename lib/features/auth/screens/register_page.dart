import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../widgets/auth_background.dart';
import 'success_page.dart'; // Kita buat setelah ini

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Logo Header
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
            const SizedBox(height: 30),

            // Card Register
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                padding: const EdgeInsets.all(25),
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
                      'Register',
                      style: TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Input Fields dengan Icon sesuai desainmu
                    _buildRegisterField('Nama Lengkap', Icons.person_outline),
                    const SizedBox(height: 15),
                    _buildRegisterField('Username', Icons.badge_outlined),
                    const SizedBox(height: 15),
                    _buildRegisterField(
                      'No. Handphone',
                      Icons.phone_android_outlined,
                    ),
                    const SizedBox(height: 15),
                    _buildRegisterField(
                      'Password',
                      Icons.lock_outline,
                      isObscure: true,
                    ),
                    const SizedBox(height: 15),
                    _buildRegisterField(
                      'Verifikasi Password',
                      Icons.verified_user_outlined,
                      isObscure: true,
                    ),

                    const SizedBox(height: 30),

                    // Tombol Daftar
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primaryGold,
                              AppColors.lightGold,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigasi ke halaman sukses
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SuccessPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: const Text(
                            'Daftar',
                            style: TextStyle(
                              color: AppColors.primaryNavy,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              color: AppColors.mediumGrey,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                            children: [
                              TextSpan(text: 'Sudah punya akun? '),
                              TextSpan(
                                text: 'Login di sini',
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterField(
    String label,
    IconData icon, {
    bool isObscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGrey,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: isObscure,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: AppColors.mediumGrey),
            filled: true,
            fillColor: AppColors.offWhite,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
