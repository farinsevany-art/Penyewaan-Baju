import 'package:flutter/material.dart';
import '../../../data/models/costume_model.dart';

class ProductDetailPage extends StatefulWidget {
  final Costume costume;

  const ProductDetailPage({
    super.key,
    required this.costume,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // List ukuran yang tersedia
  final List<String> sizes = ['S', 'M', 'L', 'XL'];
  
  // Variabel untuk menyimpan ukuran yang sedang dipilih
  String selectedSize = 'M'; 

  // Variabel untuk jumlah item (quantity)
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F0), // Warna background krem
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Center(
          child: Image.asset(
            'assets/images/Logotransparan.png', 
            height: 40,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Gambar Produk
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  widget.costume.imageUrl ?? '',
                  width: double.infinity,
                  height: 350,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 350,
                    color: const Color(0xFFE8DDD0),
                    child: const Center(
                      child: Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Judul & Harga
              Text(
                widget.costume.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D1B3E),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Rp. ${widget.costume.price}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0D1B3E),
                ),
              ),
              const SizedBox(height: 25),

              // --- BAGIAN PILIH UKURAN ---
              const Text(
                "Pilih Ukuran",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Row(
                children: sizes.map((size) {
                  bool isSelected = selectedSize == size;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSize = size;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 55,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF0D1B3E) : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF0D1B3E) : Colors.grey.shade300,
                        ),
                        boxShadow: isSelected 
                          ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))]
                          : [],
                      ),
                      child: Center(
                        child: Text(
                          size,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 25),

              // Sisa Stok & Deskripsi
              Row(
                children: [
                  const Text("Sisa Stok: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("${widget.costume.stock} pcs", style: const TextStyle(color: Colors.black54)),
                ],
              ),
              const SizedBox(height: 15),
              const Text("Deskripsi", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                widget.costume.description ?? 'Tidak ada deskripsi.',
                style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
              ),
              const SizedBox(height: 120), // Space agar tidak tertutup bottom bar
            ],
          ),
        ),
      ),
      
      // Bottom Action Bar
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFFDF7F0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Wishlist Button
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: IconButton(
                icon: Icon(
                  widget.costume.isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  // Tambahkan logika toggle wishlist di sini
                },
              ),
            ),
            const SizedBox(width: 15),
            
            // Quantity Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 18),
                    onPressed: () {
                      if (quantity > 1) setState(() => quantity--);
                    },
                  ),
                  Text(
                    "$quantity",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: () {
                      if (quantity < widget.costume.stock) setState(() => quantity++);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            
            // Add to Cart Button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Logika tambah ke keranjang
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Berhasil menambah $quantity item (Size $selectedSize)"),
                      backgroundColor: const Color(0xFF0D1B3E),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D1B3E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  elevation: 0,
                ),
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text(
                  "Tambah",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}