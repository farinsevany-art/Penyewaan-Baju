import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardService {
  static const String baseUrl = "https://api-krent-production.up.railway.app";

  static Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await http.get(
      Uri.parse("$baseUrl/get_dashboard_stats.php"),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal mengambil data dashboard');
    }
  }
}
