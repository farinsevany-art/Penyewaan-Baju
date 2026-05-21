import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/costume_model.dart';

const String baseUrl = "http://172.16.115.146/api_penyewaan";
const String imageBaseUrl = "$baseUrl/uploads/";

List<Costume> allCostumes = [];
List<Costume> cartItemsGlobal = [];

void resetAllData() {
  for (var costume in allCostumes) {
    costume.isWishlisted = false;
    costume.isInCart = false;
    costume.quantity = 1;
  }
  cartItemsGlobal.clear();
}

Future<void> fetchCostumesFromDB() async {
  try {
    final response = await http.get(Uri.parse("$baseUrl/get_stocks.php"));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);

      // --- LOGIKA PENGGABUNGAN KOSTUM & STOK ---
      Map<String, Costume> groupedCostumes = {};

      for (var item in data) {
        Costume costume = Costume.fromJson(item);

        if (costume.stock > 0) {
          String key = costume.name.toLowerCase().trim();
          String currentSize =
              (costume.size != null && costume.size!.trim().isNotEmpty)
              ? costume.size!.trim()
              : 'All Size';

          if (groupedCostumes.containsKey(key)) {
            Costume existing = groupedCostumes[key]!;

            // 1. Gabungkan Total Stok
            existing.stock += costume.stock;

            // 2. Simpan Stok Spesifik ke Dalam Map (Size -> Stock)
            existing.sizeStocks[currentSize] =
                (existing.sizeStocks[currentSize] ?? 0) + costume.stock;

            // 3. Gabungkan String Ukuran untuk Ditampilkan
            if (existing.size != null &&
                !existing.size!.contains(currentSize)) {
              existing.size = "${existing.size}, $currentSize";
            }
          } else {
            // Jika data pertama kali masuk map
            costume.sizeStocks[currentSize] = costume.stock;
            if (costume.size == null || costume.size!.trim().isEmpty)
              costume.size = currentSize;
            groupedCostumes[key] = costume;
          }
        }
      }

      List<Costume> fetchedCostumes = groupedCostumes.values.toList();
      // ------------------------------------------

      for (var newC in fetchedCostumes) {
        final existingIdx = allCostumes.indexWhere(
          (c) => c.name.toLowerCase() == newC.name.toLowerCase(),
        );
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
