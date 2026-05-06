import 'package:flutter/material.dart';
import 'stock_management_page.dart';
import '../../../core/constants/colors.dart';
import '../../auth/widgets/auth_background.dart';

class CategorySelectionPage extends StatelessWidget {
  const CategorySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Kategori dengan Icon (Kembali ke data awal)
    final List<Map<String, dynamic>> categories = [
      {'id': 1, 'name': 'Tari Dewasa', 'icon': Icons.accessibility_new},
      {'id': 2, 'name': 'Tari Anak', 'icon': Icons.child_care},
      {'id': 3, 'name': 'Raja & Ratu', 'icon': Icons.castle},
      {'id': 4, 'name': 'Wayang', 'icon': Icons.theater_comedy},
    ];

    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      appBar: AppBar(
        title: Text(
          "Pilih Kategori",
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: AppColors.primaryGold),
        ),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: AppColors.primaryGold,
        elevation: 0,
      ),
      body: AuthBackground(
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 40,
          ), // Padding lebih besar agar grid mengumpul di tengah
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio:
                0.85, // Rasio diatur agar kotak terlihat lebih kecil/compact
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];

            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StockManagementPage(
                      categoryId: cat['id'],
                      categoryName: cat['name'],
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryGold, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      cat['icon'],
                      size: 45, // Ukuran icon sedikit dikecilkan
                      color: AppColors.primaryNavy,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      cat['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                        fontSize: 16, // Ukuran teks disesuaikan
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
