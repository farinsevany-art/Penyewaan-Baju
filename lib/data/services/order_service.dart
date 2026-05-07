import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderService {
  // Sesuaikan dengan URL server Anda.
  // Jika menggunakan emulator Android, gunakan "http://10.0.2.2/api_penyewaan"
  static const String baseUrl = "http://localhost/api_penyewaan";

  // Fungsi untuk melakukan checkout ke database
  static Future<Map<String, dynamic>> checkoutPesanan(
    Map<String, dynamic> orderData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/checkout.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(orderData), // Kirim data order dalam format JSON
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {
        "status": "error",
        "message": "Gagal terhubung ke server (Code: ${response.statusCode})",
      };
    } catch (e) {
      return {"status": "error", "message": "Terjadi kesalahan: $e"};
    }
  }
}
