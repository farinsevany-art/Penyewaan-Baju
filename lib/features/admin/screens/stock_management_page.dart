import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../auth/widgets/auth_background.dart';
import 'product_detail_page.dart'; // Halaman baru
import 'add_stock_page.dart'; // Halaman baru

class StockManagementPage extends StatefulWidget {
  const StockManagementPage({super.key});

  @override
  State<StockManagementPage> createState() => _StockManagementPageState();
}

class _StockManagementPageState extends State<StockManagementPage> {
  bool isShowingCategory = true;
  String selectedCategory = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Agar background terlihat
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (!isShowingCategory) {
              setState(() => isShowingCategory = true);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          isShowingCategory ? 'Manajemen Stok' : selectedCategory,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: AppColors.primaryGold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box, color: AppColors.primaryGold),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddStockPage()),
            ),
          ),
        ],
      ),
      body: AuthBackground(
        child: Column(
          children: [
            // Search Bar Rapih
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                style: const TextStyle(fontFamily: 'Poppins'),
                decoration: InputDecoration(
                  hintText: isShowingCategory
                      ? 'Cari Kategori...'
                      : 'Cari Kostum...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.primaryNavy,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: isShowingCategory
                  ? _buildCategoryList()
                  : _buildProductList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddStockPage()),
        ),
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildCategoryList() {
    final categories = [
      {'name': 'Tari Anak', 'count': '25 Jenis'},
      {'name': 'Tari Dewasa', 'count': '32 Jenis'},
      {'name': 'Wayang', 'count': '67 Jenis'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            title: Text(
              categories[index]['name']!,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              categories[index]['count']!,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: AppColors.primaryGold,
            ),
            onTap: () => setState(() {
              selectedCategory = categories[index]['name']!;
              isShowingCategory = false;
            }),
          ),
        );
      },
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            title: const Text(
              "Kostum Tari Gandrung",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              "Stok: 12",
              style: TextStyle(fontFamily: 'Poppins', fontSize: 12),
            ),
            trailing: const Text(
              "Rp 80k",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: AppColors.primaryNavy,
              ),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductDetailPage(),
              ),
            ),
          ),
        );
      },
    );
  }
}
