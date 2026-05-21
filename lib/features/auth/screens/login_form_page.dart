import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/colors.dart';
import '../../../data/services/auth_service.dart';
import '../widgets/auth_background.dart';
import '../../customer/screens/home_page.dart';
import '../../admin/screens/admin_dashboard_page.dart';
import 'register_page.dart';

class LoginFormPage extends StatefulWidget {
  const LoginFormPage({super.key});

  @override
  State<LoginFormPage> createState() => _LoginFormPageState();
}

class _LoginFormPageState extends State<LoginFormPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  void _handleLogin(String roleType) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Harap isi semua kolom", Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await AuthService.login(email, password);

      if (response['status'] == 'success') {
        final userRole = response['role'];
        final userData =
            response['data']; // Mengambil object data dari login.php

        // MENCARI ID DAN PROFIL DARI DALAM "data"
        String userId = '1';
        String userName = 'Pengguna';
        String userEmail = email;
        String userPhone = '-';
        String userAddress = '-';
        String? userFoto; // 🔻 VARIABEL BARU UNTUK FOTO

        if (userData != null) {
          // Tangkap ID
          userId =
              userData['id_pelanggan']?.toString() ??
              userData['id_admin']?.toString() ??
              '1';

          // Tangkap Info Profil (sesuaikan dengan nama kolom tabel database Anda)
          userName = userData['nama']?.toString() ?? 'Pengguna';
          userEmail = userData['email']?.toString() ?? email;
          userPhone = userData['no_hp']?.toString() ?? '-';
          userAddress = userData['alamat']?.toString() ?? '-';
          userFoto = userData['foto']?.toString(); // 🔻 TANGKAP NAMA FILE FOTO
        }

        final prefs = await SharedPreferences.getInstance();

        // SIMPAN SEMUA DATA KE PENYIMPANAN HP
        await prefs.setString('user_id', userId);
        await prefs.setString('name', userName);
        await prefs.setString('email', userEmail);
        await prefs.setString('phone', userPhone);
        await prefs.setString('address', userAddress);

        // 🔻 SIMPAN FOTO KE PENYIMPANAN JIKA ADA 🔻
        if (userFoto != null && userFoto.isNotEmpty) {
          await prefs.setString('foto', userFoto);
        }

        if (userRole == roleType.toLowerCase()) {
          if (userRole == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminDashboardPage(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CustomerHomePage()),
            );
          }
        } else {
          _showSnackBar(
            "Akun Anda tidak terdaftar sebagai $roleType",
            Colors.red,
          );
        }
      } else {
        _showSnackBar(response['message'] ?? "Login Gagal", Colors.red);
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
    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: AuthBackground(
        child: SafeArea(
          child: Stack(
            children: [
              // ================= ORNAMEN ATAS =================
              Positioned(
                top: -40,
                right: -30,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGold.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Positioned(
                top: 80,
                left: -40,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGold.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // ================= ISI =================
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 24,
                ),

                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // ================= LOGO =================
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(18),

                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              shape: BoxShape.circle,

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),

                            child: Image.asset(
                              'assets/images/Logotransparan.png',
                              width: 65,
                            ),
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            'KUSUMA CANTIKA',

                            style: TextStyle(
                              fontFamily: 'PlayfairDisplay',
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: AppColors.primaryNavy,
                              letterSpacing: 1.2,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Penyewaan Kostum',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 45),

                    // ================= CARD LOGIN =================
                    Container(
                      padding: const EdgeInsets.all(30),

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.97),

                        borderRadius: BorderRadius.circular(32),

                        border: Border.all(
                          color: AppColors.pureWhite,
                          width: 1.2,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            'Selamat Datang',

                            style: TextStyle(
                              fontFamily: 'PlayfairDisplay',
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryNavy,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Masuk untuk melanjutkan ke aplikasi',

                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),

                          const SizedBox(height: 35),

                          // EMAIL
                          _buildTextField(
                            'Email',
                            controller: _emailController,
                          ),

                          const SizedBox(height: 20),

                          // PASSWORD
                          _buildTextField(
                            'Password',

                            controller: _passwordController,

                            isObscure: _obscurePassword,

                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,

                                color: AppColors.mediumGrey,
                              ),

                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),

                          const SizedBox(height: 35),

                          // LOADING
                          if (_isLoading)
                            const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryGold,
                              ),
                            )
                          // BUTTON
                          else ...[
                            _buildLoginButton(
                              'Login Pelanggan',
                              AppColors.primaryGold,
                              () => _handleLogin('Pelanggan'),
                            ),

                            const SizedBox(height: 16),

                            _buildLoginButton(
                              'Login Admin',
                              AppColors.primaryGold,
                              () => _handleLogin('Admin'),
                            ),
                          ],

                          const SizedBox(height: 28),

                          // REGISTER
                          Center(
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (context) => const RegisterPage(),
                                ),
                              ),

                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    color: AppColors.mediumGrey,

                                    fontSize: 13,

                                    fontFamily: 'Poppins',
                                  ),

                                  children: [
                                    TextSpan(text: 'Belum punya akun? '),

                                    TextSpan(
                                      text: 'Daftar di sini',

                                      style: TextStyle(
                                        color: Color.fromARGB(255, 255, 0, 0),

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

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint, {
    required TextEditingController controller,
    bool isObscure = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      style: const TextStyle(fontFamily: 'Poppins'),
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
        suffixIcon: suffixIcon,
      ),
    );
  }

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
            color: AppColors.offWhite,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
