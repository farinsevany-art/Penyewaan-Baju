import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/services/auth_service.dart';
import '../widgets/auth_background.dart';
import 'success_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _alamatController = TextEditingController();
  final _passwordController = TextEditingController();
  final _verifyPasswordController = TextEditingController();

  bool _isLoading = false;

  // Dua variabel terpisah untuk masing-masing kolom sandi
  bool _obscurePassword = true;
  bool _obscureVerifyPassword = true;

  void _handleRegister() async {
    final nama = _namaController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final alamat = _alamatController.text.trim();
    final password = _passwordController.text.trim();
    final verify = _verifyPasswordController.text.trim();

    if (nama.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        alamat.isEmpty ||
        password.isEmpty) {
      _showSnackBar("Semua kolom harus diisi", Colors.orange);
      return;
    }

    if (password != verify) {
      _showSnackBar("Password tidak cocok", Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await AuthService.register(
        nama,
        email,
        password,
        phone,
        alamat,
      );

      if (response['status'] == 'success') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SuccessPage()),
        );
      } else {
        _showSnackBar(response['message'] ?? "Pendaftaran Gagal", Colors.red);
      }
    } catch (e) {
      _showSnackBar("Gagal terhubung ke server", Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header Logo
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
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
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
                    _buildRegisterField(
                      'Nama Lengkap',
                      Icons.person_outline,
                      _namaController,
                    ),
                    const SizedBox(height: 15),
                    _buildRegisterField(
                      'Email',
                      Icons.email_outlined,
                      _emailController,
                    ),
                    const SizedBox(height: 15),
                    _buildRegisterField(
                      'No. Handphone',
                      Icons.phone_android_outlined,
                      _phoneController,
                    ),
                    const SizedBox(height: 15),
                    _buildRegisterField(
                      'Alamat',
                      Icons.location_on_outlined,
                      _alamatController,
                    ),
                    const SizedBox(height: 15),

                    // Kolom Password Pertama
                    _buildRegisterField(
                      'Password',
                      Icons.lock_outline,
                      _passwordController,
                      isObscure: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.mediumGrey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Kolom Password Verifikasi
                    _buildRegisterField(
                      'Verifikasi Password',
                      Icons.verified_user_outlined,
                      _verifyPasswordController,
                      isObscure: _obscureVerifyPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureVerifyPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.mediumGrey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureVerifyPassword = !_obscureVerifyPassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryGold,
                        ),
                      )
                    else
                      _buildSubmitButton(),
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

  // Tambahkan parameter suffixIcon pada helper ini
  Widget _buildRegisterField(
    String label,
    IconData icon,
    TextEditingController controller, {
    bool isObscure = false,
    Widget? suffixIcon,
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
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isObscure,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
          decoration: InputDecoration(
            hintText: label,
            prefixIcon: Icon(icon, size: 20, color: AppColors.mediumGrey),
            suffixIcon: suffixIcon, // Masukkan ikon mata ke sini
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

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryGold, AppColors.lightGold],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ElevatedButton(
          onPressed: _handleRegister,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: const Text(
            'Daftar',
            style: TextStyle(
              color: AppColors.offWhite,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }
}
