import 'package:flutter/material.dart';
import '../../../../../data/models/costume_model.dart';
import 'rent_options_button_sheet.dart';

class ProductDetailPage extends StatefulWidget {
  final Costume costume;

  const ProductDetailPage({super.key, required this.costume});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;
  late String _selectedSize;
  late bool _isWishlisted;

  @override
  void initState() {
    super.initState();
    _selectedSize = (widget.costume.size != null && widget.costume.size!.isNotEmpty)
        ? widget.costume.size!.split(' - ').first.trim()
        : 'S';
  }
void _toggleWishlist() {
    setState(() {
      _isWishlisted = !_isWishlisted; // Ubah tampilan UI
      widget.costume.isWishlisted = _isWishlisted; // Simpan ke data asli
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isWishlisted ? "Ditambah ke Wishlist" : "Dihapus dari Wishlist"),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showOpsiSewa(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RentOptionsBottomSheet(
        costume: widget.costume,
        initialQuantity: _quantity,
        onConfirm: (selectedQuantity) {
          setState(() => _quantity = selectedQuantity);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pesanan dikonfirmasi!'), behavior: SnackBarBehavior.floating),
          );
        },
      ),
    );
  }
  

 @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), 
          onPressed: () => Navigator.pop(context)
        ),
        title: const Text("Detail Produk", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        // 1. TAMBAHKAN TOMBOL WISHLIST DI APPBAR
        actions: [
          IconButton(
            icon: Icon(
              _isWishlisted ? Icons.favorite : Icons.favorite_border, 
              color: Colors.red
            ),
            onPressed: _toggleWishlist,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 2. GAMBAR DENGAN FLOATING WISHLIST
              Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      widget.costume.imageUrl ?? '',
                      width: double.infinity,
                      height: size.height * 0.35,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: size.height * 0.35,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                  // Tombol Hati di atas gambar
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: IconButton(
                        icon: Icon(
                          _isWishlisted ? Icons.favorite : Icons.favorite_border, 
                          color: Colors.red
                        ),
                        onPressed: _toggleWishlist,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // NAMA & HARGA
              Text(widget.costume.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rp ${widget.costume.price}', style: const TextStyle(fontSize: 20, color: Color(0xFF0D1B3E), fontWeight: FontWeight.bold)),
                  // TAMPILAN STOK
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text("Stok: ${widget.costume.stock ?? 0}", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // UKURAN (Sama seperti kodemu)
              const Text("Pilih Ukuran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Row(
                children: ['S', 'M', 'L', 'XL'].map((s) {
                  bool isSelected = _selectedSize == s;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedSize = s),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 50, height: 50,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF0D1B3E) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSelected ? const Color(0xFF0D1B3E) : Colors.grey[300]!),
                      ),
                      child: Center(child: Text(s, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold))),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 25),

              // DESKRIPSI
              const Text("Deskripsi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              Text(widget.costume.description ?? "-", style: const TextStyle(color: Colors.black54, height: 1.5)),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: (widget.costume.stock ?? 0) > 0 ? () => _showOpsiSewa(context) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D1B3E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text((widget.costume.stock ?? 0) > 0 ? "Sewa Sekarang" : "Stok Habis", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}