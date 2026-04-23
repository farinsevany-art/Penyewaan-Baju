class CostumeStock {
  final String name;
  final String category;
  final String price;
  final Map<String, int> stockBySize; // Contoh: {'S': 5, 'M': 12}
  final String imagePath;

  CostumeStock({
    required this.name,
    required this.category,
    required this.price,
    required this.stockBySize,
    required this.imagePath,
  });

  int get totalStock => stockBySize.values.fold(0, (sum, item) => sum + item);
}
