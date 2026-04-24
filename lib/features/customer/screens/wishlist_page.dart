import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/costume_model.dart';
import '../../../data/services/mock_data.dart';
import '../widgets/costume_card.dart'; // Pastikan path import benar

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  bool _isExploring = false;

  // Mengambil data berdasarkan mode (Wishlist atau Jelajah)
  List<Costume> get _itemsToShow => _isExploring
      ? allCostumes
      : allCostumes.where((c) => c.isWishlisted).toList();

  @override
  Widget build(BuildContext context) {
    final items = _itemsToShow;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFCF7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            if (_isExploring) {
              setState(() => _isExploring = false);
            } else {
              Navigator.of(context).maybePop();
            }
          },
        ),
        title: Text(
          _isExploring ? 'Jelajahi Kostum' : 'Wishlist',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: (items.isEmpty && !_isExploring) ? _buildEmpty() : _buildGrid(items),
    );
  }

  // Menggunakan GridView agar tampilan Card lebih proporsional sesuai desain CostumeCard
  Widget _buildGrid(List<Costume> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Menampilkan 2 card per baris
        childAspectRatio: 0.65, // Menyesuaikan tinggi card
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return CostumeCard(
          costume: item,
          onTap: () {
            // Logika navigasi ke detail jika diperlukan
          },
          onAddToCart: () {
            // Callback ini akan dipanggil saat tombol di card ditekan
            setState(() {
              // Logika tambah keranjang global bisa di sini
            });
          },
        );
      },
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 70, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'Wishlist Kamu Kosong',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => setState(() => _isExploring = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNavy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Jelajahi Kostum'),
          ),
        ],
      ),
    );
  }
}