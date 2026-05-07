class StockModel {
  final int? idKostum;
  final String namaKostum;
  final int idKategori;
  final int stok;
  final int hargaSewa;
  final String ukuran;
  final String deskripsi;
  final String? gambar;

  StockModel({
    this.idKostum,
    required this.namaKostum,
    required this.idKategori,
    required this.stok,
    required this.hargaSewa,
    required this.ukuran,
    required this.deskripsi,
    this.gambar,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      idKostum: int.tryParse(json['id_kostum'].toString()),
      namaKostum: json['nama_kostum'] ?? '',
      // Memastikan id_kategori dibaca dengan benar dari database
      idKategori: int.tryParse(json['id_kategori'].toString()) ?? 0,
      stok: int.tryParse(json['stok'].toString()) ?? 0,
      // Mengonversi Decimal SQL ke Double lalu ke Int agar tidak 0
      hargaSewa: double.tryParse(json['harga_sewa'].toString())?.toInt() ?? 0,
      ukuran: json['ukuran'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      // Disesuaikan dengan kolom 'foto' di phpMyAdmin[cite: 3]
      gambar: json['foto'],
    );
  }

  // Tambahkan method toMap untuk mempermudah pengiriman data ke API/Service
  Map<String, dynamic> toJson() {
    return {
      'id_kostum': idKostum,
      'nama_kostum': namaKostum,
      'id_kategori': idKategori,
      'stok': stok,
      'harga_sewa': hargaSewa,
      'ukuran': ukuran,
      'deskripsi': deskripsi,
      'foto': gambar,
    };
  }
}
