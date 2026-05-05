import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stock_model.dart';

class StockService {
  static const String baseUrl = "http://localhost/api_penyewaan";

  static Future<List<StockModel>> getStocks(int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/get_stocks.php?id_kategori=$categoryId"),
      );
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((item) => StockModel.fromJson(item)).toList();
      }
      throw Exception("Gagal muat data");
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  static Future<Map<String, dynamic>> saveStock(
    StockModel stock,
    bool isEdit,
  ) async {
    final url = isEdit ? "$baseUrl/update_stock.php" : "$baseUrl/add_stock.php";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          "nama_kostum": stock.namaKostum,
          "id_kategori": stock.idKategori.toString(),
          "stok": stock.stok.toString(),
          "harga_sewa": stock.hargaSewa.toString(),
          "ukuran": stock.ukuran,
          "deskripsi": stock.deskripsi,
          if (isEdit) "id_kostum": stock.idKostum.toString(),
        },
      );
      return json.decode(response.body);
    } catch (e) {
      return {"success": false, "message": "Koneksi gagal: $e"};
    }
  }

  static Future<Map<String, dynamic>> deleteStock(int id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/delete_stock.php"),
        body: {"id_kostum": id.toString()},
      );
      return json.decode(response.body);
    } catch (e) {
      return {"success": false, "message": "Gagal menghapus: $e"};
    }
  }
}
