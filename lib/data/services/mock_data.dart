import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/costume_model.dart';

// Ganti URL dengan IP Anda jika di HP asli (contoh: 192.168.1.10)
const String baseUrl = "http://localhost/api_penyewaan";
const String imageBaseUrl = "$baseUrl/uploads/";

List<Costume> allCostumes = [];
List<Costume> cartItemsGlobal = [];

Future<void> fetchCostumesFromDB() async {
  try {
    final response = await http.get(Uri.parse("$baseUrl/get_stocks.php"));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);

      // Ambil data dan filter: Hanya kostum yang stoknya > 0 yang bisa dilihat customer
      List<Costume> fetchedCostumes = data
          .map((item) => Costume.fromJson(item))
          .where((c) => c.stock > 0)
          .toList();

      // Sinkronisasi data lama (agar Wishlist & Keranjang tidak hilang saat layar direfresh)
      for (var newC in fetchedCostumes) {
        final existingIdx = allCostumes.indexWhere((c) => c.id == newC.id);
        if (existingIdx != -1) {
          newC.isWishlisted = allCostumes[existingIdx].isWishlisted;
          newC.isInCart = allCostumes[existingIdx].isInCart;
          newC.quantity = allCostumes[existingIdx].quantity;
        }
      }

      allCostumes = fetchedCostumes;
    }
  } catch (e) {
    print("Gagal mengambil data kostum: $e");
  }
}
