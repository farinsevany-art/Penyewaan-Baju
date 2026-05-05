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
      idKategori: int.tryParse(json['id_kategori'].toString()) ?? 0,
      stok: int.tryParse(json['stok'].toString()) ?? 0,
      hargaSewa: int.tryParse(json['harga_sewa'].toString()) ?? 0,
      ukuran: json['ukuran'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      gambar: json['gambar'],
    );
  }
}
