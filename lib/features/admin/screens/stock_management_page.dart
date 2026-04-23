import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'edit_stock_page.dart';

class StockManagementPage extends StatefulWidget {
  const StockManagementPage({super.key});

  @override
  State<StockManagementPage> createState() => _StockManagementPageState();
}

class _StockManagementPageState extends State<StockManagementPage> {
  // State untuk switch antara tampilan Kategori atau Daftar Produk
  bool isShowingCategory = true;
  String selectedCategory = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,
        leading: isShowingCategory
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => setState(() => isShowingCategory = true),
              ),
        title: Text(
          isShowingCategory ? 'Manajemen Stok' : selectedCategory,
          style: const TextStyle(
            color: AppColors.primaryGold,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          const Icon(Icons.notifications_none, color: Colors.white),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.add_box, color: AppColors.primaryGold),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditStockPage()),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: isShowingCategory
                    ? 'Cari Kategori Kostum'
                    : 'Cari Kostum',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Tab bar kecil (Kostum | Aksesoris)
          if (!isShowingCategory) _buildSubCategoryTab(),

          Expanded(
            child: isShowingCategory
                ? _buildCategoryList()
                : _buildProductList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    final categories = [
      {
        'name': 'Tari Anak',
        'count': '25 Jenis',
        'img': 'assets/images/tari_anak.png',
      },
      {
        'name': 'Tari Dewasa',
        'count': '32 Jenis',
        'img': 'assets/images/tari_dewasa.png',
      },
      {
        'name': 'Raja & Ratu',
        'count': '45 Jenis',
        'img': 'assets/images/raja_ratu.png',
      },
      {
        'name': 'Wayang',
        'count': '67 Jenis',
        'img': 'assets/images/wayang.png',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 50,
                height: 50,
                color: Colors.grey[300],
              ), // Placeholder Image
            ),
            title: Text(
              categories[index]['name']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(categories[index]['count']!),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              setState(() {
                selectedCategory = categories[index]['name']!;
                isShowingCategory = false;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildProductItem("Baju Bodo", "Tari Anak", "55.000", "5");
      },
    );
  }

  Widget _buildProductItem(
    String name,
    String cat,
    String price,
    String stock,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(width: 50, height: 50, color: Colors.grey[200]),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          "$cat\nStok: $stock",
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Text(
          "Rp$price",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryNavy,
          ),
        ),
        isThreeLine: true,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EditStockPage()),
        ),
      ),
    );
  }

  Widget _buildSubCategoryTab() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            const Text("Kostum", style: TextStyle(fontWeight: FontWeight.bold)),
            Container(height: 2, width: 40, color: AppColors.primaryNavy),
          ],
        ),
        const Text("Aksesoris", style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
