class Costume {
  final String id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String? imageUrl;
  final String? description;
  final String? size;
  bool isWishlisted;
  int quantity = 1;
  bool isInCart = false;

  Costume({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    this.imageUrl,
    this.description,
    this.size,
    this.isWishlisted = false,
  });

  String get formattedPrice {
    final formatted = price.toInt().toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]}.',
    );
    return 'Rp. $formatted';
  }

  // Fungsi untuk konversi JSON dari MySQL ke Model Dart
  factory Costume.fromJson(Map<String, dynamic> json) {
    // Mapping ID Kategori ke String sesuai database
    String catName = "Lainnya";
    int idKat = int.tryParse(json['id_kategori'].toString()) ?? 0;
    if (idKat == 1) catName = "Tari Dewasa";
    if (idKat == 2) catName = "Tari Anak";
    if (idKat == 3) catName = "Raja & Ratu";
    if (idKat == 4) catName = "Wayang";

    return Costume(
      id: json['id_kostum'].toString(),
      name: json['nama_kostum'] ?? '',
      category: catName,
      price: double.tryParse(json['harga_sewa'].toString()) ?? 0,
      stock: int.tryParse(json['stok'].toString()) ?? 0,
      imageUrl: json['foto'], // Hanya mengambil nama filenya saja
      description: json['deskripsi'] ?? '',
      size: json['ukuran'] ?? '',
    );
  }
}
