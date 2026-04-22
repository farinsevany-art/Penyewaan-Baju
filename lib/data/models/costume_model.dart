class Costume {
  final String id;
  final String name;
  final String category; // Misal: Tradisional, Karnaval, Jas
  final double price;
  final int stock;
  final String imageUrl;
  final String description;

  Costume({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.description,
  });
}
