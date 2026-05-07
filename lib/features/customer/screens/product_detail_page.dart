import 'package:flutter/material.dart';
import '../../../data/models/costume_model.dart';
import '../../../data/services/mock_data.dart'; // Untuk cartItemsGlobal
import '../../../data/services/stock_service.dart'; // Untuk imageBaseUrl

class ProductDetailPage extends StatefulWidget {
  final Costume costume;

  const ProductDetailPage({super.key, required this.costume});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

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
          child: Image.asset('assets/images/Logotransparan.png', height: 40),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Navigasi ke search page (opsional)
            },
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
              // Gambar Produk dari Database
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child:
                    widget.costume.imageUrl != null &&
                        widget.costume.imageUrl!.isNotEmpty
                    ? Image.network(
                        "${StockService.imageBaseUrl}${widget.costume.imageUrl}",
                        width: double.infinity,
                        height: 350,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildNoImage(),
                      )
                    : _buildNoImage(),
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
              Text(
                widget.costume.formattedPrice,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0D1B3E),
                ),
              ),
              const SizedBox(height: 20),

              // Size & Sisa Stok
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Size",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.costume.size ?? '-',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE4B04B),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        "Sisa Stok",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          "${widget.costume.stock}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Deskripsi
              const Text(
                "Deskripsi",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                widget.costume.description != null &&
                        widget.costume.description!.isNotEmpty
                    ? widget.costume.description!
                    : 'Tidak ada deskripsi.',
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 100), // Space untuk bottom bar
            ],
          ),
        ),
      ),

      // Bottom Action Bar
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        color: const Color(0xFFFDF7F0),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  widget.costume.isWishlisted
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    widget.costume.isWishlisted = !widget.costume.isWishlisted;
                  });
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        widget.costume.isWishlisted
                            ? '${widget.costume.name} ditambahkan ke wishlist'
                            : '${widget.costume.name} dihapus dari wishlist',
                      ),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 15),

            // Pengatur Jumlah (Quantity)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_quantity > 1) {
                        setState(() => _quantity--);
                      }
                    },
                    child: const Text(
                      " - ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "$_quantity",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (_quantity < widget.costume.stock) {
                        setState(() => _quantity++);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Maksimal stok tercapai!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      " + ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),

            // Tombol Tambah ke Keranjang
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (widget.costume.stock <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Maaf, stok sedang habis!')),
                    );
                    return;
                  }

                  // Logika memasukkan ke keranjang
                  if (!cartItemsGlobal.contains(widget.costume)) {
                    setState(() {
                      widget.costume.isInCart = true;
                      widget.costume.quantity = _quantity;
                      cartItemsGlobal.add(widget.costume);
                    });
                  } else {
                    setState(() {
                      widget.costume.quantity += _quantity;
                    });
                  }

                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '$_quantity ${widget.costume.name} ditambahkan ke keranjang',
                      ),
                      backgroundColor: const Color.fromARGB(255, 7, 32, 60),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D1B3E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  "Tambah",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoImage() {
    return Container(
      height: 350,
      width: double.infinity,
      color: const Color(0xFFE8DDD0),
      child: const Center(
        child: Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
      ),
    );
  }
}
