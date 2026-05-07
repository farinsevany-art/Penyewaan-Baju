import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tambahkan ini
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
        // --- PROSES PENYIMPANAN DATA KE SESSION ---
        final prefs = await SharedPreferences.getInstance();
        final userData = response['data']; // Mengambil data dari login.php[cite: 1]

        // Simpan data pelanggan agar otomatis muncul di ProfilePage
        await prefs.setString('name', userData['nama'] ?? '');
        await prefs.setString('email', userData['email'] ?? '');
        await prefs.setString('phone', userData['no_hp'] ?? '');
        await prefs.setString('address', userData['alamat'] ?? '');
        // -------------------------------------------

        final userRole = response['role'];
        if (userRole == roleType.toLowerCase()) {
          if (userRole == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminDashboardPage()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CustomerHomePage()),
            );
          }
        } else {
          _showSnackBar("Akun Anda tidak terdaftar sebagai $roleType", Colors.red);
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

  // ... (Widget build tetap sama seperti kode sebelumnya)
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color)
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
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
            const SizedBox(height: 50),
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
                    _buildTextField('Email', controller: _emailController),
                    const SizedBox(height: 20),
                    _buildTextField(
                      'Password',
                      controller: _passwordController,
                      isObscure: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.mediumGrey,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator(color: AppColors.primaryGold))
                    else ...[
                      _buildLoginButton('Login Pelanggan', AppColors.primaryGold, () => _handleLogin('Pelanggan')),
                      const SizedBox(height: 15),
                      _buildLoginButton('Login Admin', AppColors.primaryGold, () => _handleLogin('Admin')),
                    ],
                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage())),
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(color: AppColors.mediumGrey, fontSize: 12, fontFamily: 'Poppins'),
                            children: [
                              TextSpan(text: 'Belum punya akun? '),
                              TextSpan(
                                text: 'Daftar di sini',
                                style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
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
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {required TextEditingController controller, bool isObscure = false, Widget? suffixIcon}) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.offWhite,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
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
        style: ElevatedButton.styleFrom(backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        child: Text(text, style: const TextStyle(color: AppColors.primaryNavy, fontWeight: FontWeight.bold)),
      ),
    );
  }
}