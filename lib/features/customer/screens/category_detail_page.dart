import 'package:flutter/material.dart';
import 'category2_detail_page.dart'; // Import file anak agar bisa pindah ke sana
import 'category3_detail_page.dart'; // Import file anak agar bisa pindah ke sana
import 'category4_detail_page.dart'; // Import file anak agar bisa pindah ke sana
import 'product_detail_page.dart'; // Import file anak agar bisa pindah ke sana

class CategoryDetailPage extends StatefulWidget {
  final String categoryTitle;

  const CategoryDetailPage({super.key, required this.categoryTitle});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  // Variabel untuk menyimpan tab mana yang sedang aktif
  late String _currentSelected;

  @override
  void initState() {
    super.initState();
    // Ambil judul dari halaman sebelumnya (Home) sebagai pilihan awal
    _currentSelected = widget.categoryTitle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: SizedBox(
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'cari kostum',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildFilterTabs(), // Memanggil tab kategori
          const SizedBox(height: 15),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: 4,
              itemBuilder: (context, index) => _buildProductCard(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final categories = ['Tari Dewasa', 'Tari Anak', 'Raja & Ratu', 'Wayang'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: categories.map((cat) {
          // Sekarang isSelected dinamis sesuai yang diklik
          bool isSelected = cat == _currentSelected;
          return Container(
            margin: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (selected) {
                if (cat == _currentSelected) return; // Jika klik tab yang sama, abaikan

                // LOGIKA PINDAH HALAMAN
                if (cat == 'Tari Anak') {
                  // Jika user klik Tari Anak, pindah ke file Category2DetailPage
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Category2DetailPage(categoryTitle: cat),
                    ),
                  );
                } else {
                  // Jika tetap di kategori umum, cukup ganti state di sini
                  setState(() {
                    _currentSelected = cat;
                  });
                }
              },
              selectedColor: Colors.black87,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey[300]!),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context) {
    return GestureDetector(
    onTap: () {
      // Fungsi pindah ke halaman detail
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProductDetailPage(
            title: 'Kostum Tari Gandrung',
            price: 'Rp 80.000/set',
            imagePath: 'assets/images/taridewasa.jpg', // Samakan dengan asset di bawah
          ),
        ),
      );
    },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 13,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    color: Color(0xFFF0F0F0),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      'assets/images/tarikreasibaru.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image, color: Colors.grey, size: 40),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.favorite_border, size: 16, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 11,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentSelected.toUpperCase(), // Judul kecil otomatis berubah
                    style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Clara 1',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const Text('Ukuran M - XL', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  const Spacer(),
                  const Text('Rp. 75.000 /day', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D1B3E),
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        'Sewa',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}