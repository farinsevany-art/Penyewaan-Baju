import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderService {
  static const String baseUrl = "http://10.136.173.149/api_penyewaan";

  // 1. Fungsi Checkout (Sudah ada sebelumnya)
  static Future<Map<String, dynamic>> checkoutPesanan(
    Map<String, dynamic> orderData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/checkout.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {"status": "error", "message": "Gagal terhubung ke server"};
    } catch (e) {
      return {"status": "error", "message": "Terjadi kesalahan: $e"};
    }
  }

  // 2. Fungsi Ambil Data Pesanan (Admin & Customer)
  static Future<List<dynamic>> getOrders({int? idPelanggan}) async {
    try {
      String url = "$baseUrl/get_orders.php";
      if (idPelanggan != null) {
        url += "?id_pelanggan=$idPelanggan"; // Filter khusus customer
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return data['data'];
        }
      }
      return [];
    } catch (e) {
      print("Error getOrders: $e");
      return [];
    }
  }

  // 3. Fungsi Ubah Status Pesanan (Khusus Admin)
  static Future<bool> updateOrderStatus(
    int idPenyewaan,
    String statusBaru,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/update_status.php"),
        body: {
          "id_penyewaan": idPenyewaan.toString(),
          "status_penyewaan": statusBaru,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'success';
      }
      return false;
    } catch (e) {
      print("Error updateOrderStatus: $e");
      return false;
    }
  }
}
