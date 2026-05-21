import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // 🔻 TAMBAHKAN IMPORT INI

class AuthService {
  static const String baseUrl = "http://172.16.115.146/api_penyewaan";

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

  static Future<Map<String, dynamic>> updateProfileFoto(
    String userId,
    XFile imageFile,
  ) async {
    try {
      // PERBAIKAN: Gunakan $baseUrl agar konsisten
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/update_profile.php"),
      );
      request.fields['id_pelanggan'] = userId;
      request.fields['aksi'] = 'update_foto';

      var bytes = await imageFile.readAsBytes();

      // PERBAIKAN: Berikan fallback nama jika file dari galeri HP tidak punya nama
      String fileName = imageFile.name.isNotEmpty
          ? imageFile.name
          : "profile_image.jpg";

      var pic = http.MultipartFile.fromBytes("foto", bytes, filename: fileName);
      request.files.add(pic);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // PERBAIKAN: Tangkap error jika balasan PHP bukan format JSON (seperti Error MySQL)
      try {
        return json.decode(response.body);
      } catch (e) {
        return {
          "success": false,
          "message": "Respon Server Bukan JSON: ${response.body}",
        };
      }
    } catch (e) {
      return {"success": false, "message": "Gagal terhubung ke server: $e"};
    }
  }

  // Fungsi Hapus Foto
  static Future<Map<String, dynamic>> deleteProfileFoto(String userId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/update_profile.php"),
        body: {"id_pelanggan": userId, "aksi": "delete_foto"},
      );
      return json.decode(response.body);
    } catch (e) {
      return {"success": false, "message": "Gagal terhubung ke server"};
    }
  }

  // Fungsi Update Data Diri
  static Future<Map<String, dynamic>> updateProfileData(
    String userId,
    String nama,
    String email,
    String noHp,
    String alamat,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/update_profile.php"),
        body: {
          "id_pelanggan": userId,
          "aksi": "update_data",
          "nama": nama,
          "email": email,
          "no_hp": noHp,
          "alamat": alamat,
        },
      );
      return json.decode(response.body);
    } catch (e) {
      return {"success": false, "message": "Gagal terhubung ke server"};
    }
  }
}
