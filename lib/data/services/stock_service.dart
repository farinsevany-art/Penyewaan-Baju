import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../models/stock_model.dart';

class StockService {
  static const String baseUrl = "http://localhost/api_penyewaan";
  static const String imageBaseUrl = "$baseUrl/uploads/";

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
    bool isEdit, {
    XFile? imageFile,
  }) async {
    final url = isEdit ? "$baseUrl/update_stock.php" : "$baseUrl/add_stock.php";
    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));

      request.fields['nama_kostum'] = stock.namaKostum;
      request.fields['id_kategori'] = stock.idKategori.toString();
      request.fields['stok'] = stock.stok.toString();
      request.fields['harga_sewa'] = stock.hargaSewa.toString();
      request.fields['ukuran'] = stock.ukuran;
      request.fields['deskripsi'] = stock.deskripsi;

      if (isEdit) {
        request.fields['id_kostum'] = stock.idKostum.toString();
      }

      if (imageFile != null) {
        var bytes = await imageFile.readAsBytes();
        var pic = http.MultipartFile.fromBytes(
          "foto",
          bytes,
          filename: imageFile.name,
        );
        request.files.add(pic);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      return json.decode(response.body);
    } catch (e) {
      return {"success": false, "message": "Koneksi gagal: $e"};
    }
  }

  static Future<Map<String, dynamic>> deleteStock(int idKostum) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/delete_stock.php"),
        body: {"id_kostum": idKostum.toString()},
      );

      if (response.statusCode == 200) {
        try {
          // Coba jadikan JSON
          return json.decode(response.body);
        } catch (e) {
          // JIKA BUKAN JSON (ADA SPASI/ERROR), TAMPILKAN ISI ASLINYA DARI SERVER!
          return {
            "success": false,
            "message": "Balasan Server Tidak Dikenal:\n${response.body}",
          };
        }
      } else {
        return {
          "success": false,
          "message": "Server error dengan kode ${response.statusCode}",
        };
      }
    } catch (e) {
      return {"success": false, "message": "Terjadi kesalahan koneksi: $e"};
    }
  }
}
