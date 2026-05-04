import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Gunakan IP Laptop jika pakai emulator/HP asli, misal: 192.168.1.5
  static const String baseUrl = "http://localhost/api_penyewaan";

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login.php"),
      body: {"email": email, "password": password},
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> register(
    String nama,
    String email,
    String password,
    String noHp,
    String alamat,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register.php"),
      body: {
        "nama": nama,
        "email": email,
        "password": password,
        "no_hp": noHp,
        "alamat": alamat,
      },
    );
    return json.decode(response.body);
  }
}
