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
  int _quantity = 1;
  late String _selectedSize; // Menyimpan ukuran yang dipilih

  @override
  void initState() {
    super.initState();
    // Inisialisasi ukuran awal, ambil dari properti costume atau default 'S'
    if (widget.costume.size != null && widget.costume.size!.isNotEmpty) {
      _selectedSize = widget.costume.size!.split(' - ').first.trim();
    } else {
      _selectedSize = 'S';
    }
  }

  void _toggleWishlist() {
    setState(() {
      widget.costume.isWishlisted = !widget.costume.isWishlisted;
    });

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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F0),
      resizeToAvoidBottomInset: true,
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
            height: 35,
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Produk
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  widget.costume.imageUrl ?? '',
                  width: double.infinity,
                  height: size.height * 0.38,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: size.height * 0.38,
                    color: const Color(0xFFE8DDD0),
                    child: const Center(
                      child: Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Judul & Harga
              Text(
                widget.costume.name,
                style: TextStyle(
                  fontSize: size.width * 0.055,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D1B3E),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Rp. ${widget.costume.price}',
                style: TextStyle(
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0D1B3E),
                ),
              ),
              const SizedBox(height: 16),

              // Size & Sisa Stok
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Size", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      // Tampilan Ukuran Berbentuk Lingkaran
                      Row(
                        children: ['S', 'M', 'L', 'XL'].map((sizeOption) {
                          final isSelected = _selectedSize == sizeOption;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedSize = sizeOption;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF0D1B3E) : Colors.grey,
                                  width: 1.5,
                                ),
                                color: isSelected ? const Color(0xFF0D1B3E) : Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  sizeOption,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Sisa Stok", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text("${widget.costume.stock}"),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Deskripsi
              const Text("Deskripsi", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                widget.costume.description ?? 'Tidak ada deskripsi.',
                style: const TextStyle(fontSize: 12, height: 1.4, color: Colors.black54),
              ),
              const SizedBox(height: 110), 
            ],
          ),
        ),
      ),
      
      // Bottom Action Bar
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: const Color(0xFFFDF7F0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: IconButton(
                icon: Icon(
                  widget.costume.isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: _toggleWishlist,
              ),
            ),
            
            // Tombol Kuantitas
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 16),
                    onPressed: () {
                      if (_quantity > 1) {
                        setState(() {
                          _quantity--;
                        });
                      }
                    },
                  ),
                  Text(
                    '$_quantity',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 16),
                    onPressed: () {
                      setState(() {
                        _quantity++;
                      });
                    },
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Aksi tambah keranjang
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D1B3E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                  icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 18),
                  label: const Text(
                    "Tambah", 
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}