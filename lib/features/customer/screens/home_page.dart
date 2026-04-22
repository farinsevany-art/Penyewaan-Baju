import '../../auth/widgets/auth_background.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../widgets/costume_card.dart';

class CustomerHomePage extends StatelessWidget {
  const CustomerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      bottomNavigationBar: _buildBottomNav(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Navy dengan Lengkungan
            Stack(
              children: [
                Container(height: 280, color: AppColors.offWhite),
                ClipPath(
                  clipper:
                      MyHeaderClipper(), // Menggunakan nama class yang unik
                  child: Container(
                    height: 250,
                    color: AppColors.primaryNavy,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/images/Logotransparan.png',
                              width: 40,
                            ),
                            const Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Search Bar
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari kostum...',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Kategori
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryItem('Tari Dewasa'),
                  _buildCategoryItem('Tari Anak'),
                  _buildCategoryItem('Raja & Ratu'),
                  _buildCategoryItem('Pewayangan'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section Populer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'POPULER',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Lihat Semua >',
                      style: TextStyle(color: AppColors.primaryGold),
                    ),
                  ),
                ],
              ),
            ),

            // Grid Kostum
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return const CostumeCard(
                    name: 'Tari Dewasa Gandrung',
                    image: 'assets/images/kostum1.png',
                    price: '80.000',
                    size: 'M - XL',
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: const Icon(Icons.theater_comedy, color: AppColors.primaryNavy),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryGold,
      unselectedItemColor: AppColors.mediumGrey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Pesanan',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
    );
  }
}

class MyHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
