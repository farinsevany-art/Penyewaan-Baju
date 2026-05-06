import 'package:flutter/material.dart';
import '../../../data/models/costume_model.dart';
import '../../../data/services/mock_data.dart';
import '../widgets/costume_card.dart';
import 'cart_page.dart';
import 'home_page.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  bool _isExploring = false;

  // Filter untuk menampilkan kostum yang di-wishlist saja
  List<Costume> get _itemsToShow => _isExploring
      ? allCostumes
      : allCostumes.where((c) => c.isWishlisted).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan background putih tulang agar terlihat bersih di sela gambar
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            if (_isExploring) {
              // Jika sedang mode jelajah, matikan modenya kembali ke wishlist kosong
              setState(() => _isExploring = false);
            } else {
              // NAVIGASI BALIK KE HOME (IndexedStack Index 0)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CustomerHomePage()),
              );
            }
          },
        ),
        title: Text(
          _isExploring ? 'Jelajahi Kostum' : 'Wishlist Saya',
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xFF0D1B3E),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
      ),
      // BODY DENGAN BACKGROUND GAMBAR
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
            opacity: 0.40, // Opasitas rendah agar kartu kostum tetap terlihat jelas
          ),
        ),
        child: (_itemsToShow.isEmpty && !_isExploring)
            ? _buildEmptyState()
            : _buildGrid(_itemsToShow),
      ),
    );
  }

  // Widget Grid untuk menampilkan daftar kostum
  Widget _buildGrid(List<Costume> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68, // Rasio kartu yang sama dengan di Home
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return CostumeCard(
          costume: item,
          onWishlistToggle: () {
            setState(() {
              item.isWishlisted = !item.isWishlisted;
            });
          },
        );
      },
    );
  }

  // Widget Tampilan saat Wishlist kosong
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.favorite_outline, size: 60, color: Colors.grey.shade300),
          ),
          const SizedBox(height: 20),
          const Text(
            'Wishlist Kamu Kosong',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D1B3E),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
            child: Text(
              'Simpan kostum favoritmu di sini untuk disewa nanti.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Poppins', color: Colors.grey, fontSize: 13),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => setState(() => _isExploring = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE4B04B), // Warna emas Kusuma Cantika
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Mulai Cari Kostum',
              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}