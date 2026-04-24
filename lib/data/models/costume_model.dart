  class Costume {
  final String id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String imageUrl;
  final String description;
  final String size;
  bool isWishlisted;

  Costume({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.description,
    this.size = 'M - XL',
    this.isWishlisted = false,
  });

  String get formattedPrice {
    final formatted = price.toInt().toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]}.',
    );
    return 'Rp. $formatted';
  }
}