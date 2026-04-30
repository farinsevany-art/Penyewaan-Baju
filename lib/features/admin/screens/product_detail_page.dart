import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../auth/widgets/auth_background.dart';
import 'edit_stock_page.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,
        title: Image.asset(
          'assets/images/Logotransparan.png',
          height: 40,
        ), // Sesuai gambar
        centerTitle: true,
      ),
      body: AuthBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Produk
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image, size: 100, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Judul & Harga (Playfair Display)
              Text(
                "Kostum Tari Gandrung",
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.primaryNavy,
                  fontSize: 26,
                ),
              ),
              Text(
                "Rp 80.000/set",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primaryNavy,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Size",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: ['S', 'M', 'L', 'XL']
                    .map(
                      (size) => Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Center(
                          child: Text(
                            size,
                            style: const TextStyle(fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 25),
              const Text(
                "Deskripsi",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Tari Gandrung adalah seni pertunjukan tradisional khas Banyuwangi, Jawa Timur...",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),
              // Tombol Hapus & Edit
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () => _showDeleteConfirmation(context),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Hapus",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNavy,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditStockPage(),
                        ),
                      ),
                      icon: const Icon(Icons.edit_note, color: Colors.white),
                      label: const Text(
                        "Edit",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Anda yakin untuk menghapus produk ini?",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(15),
                ),
                onPressed: () {},
                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text(
                  "Hapus",
                  style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
