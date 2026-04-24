import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../widgets/costume_card.dart';
import 'category_detail_page.dart'; 
import 'wishlist_page.dart';// Import halaman detail kategori

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  int _selectedIndex = 0;

  // Daftar halaman untuk BottomNav
  final List<Widget> _pages = [
    const HomeContent(),
    const WishlistPage(),
    const Center(child: Text("Halaman Pesanan")),
    const Center(child: Text("Halaman Cari")),
    const Center(child: Text("Halaman Profil")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryGold,
        unselectedItemColor: AppColors.mediumGrey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Navy dengan Lengkungan (Clipper)
          Stack(
            children: [
              Container(height: 280, color: AppColors.offWhite),
              ClipPath(
                clipper: MyHeaderClipper(),
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
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.auto_awesome,
                                  color: AppColors.primaryGold,
                                ),
                          ),
                          const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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

          // Barisan Kategori
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryItem(
                  context,
                  'Tari Dewasa',
                  Icons.accessibility_new,
                ),
                _buildCategoryItem(context, 'Tari Anak', Icons.child_care),
                _buildCategoryItem(context, 'Raja & Ratu', Icons.auto_awesome),
                _buildCategoryItem(context, 'Pewayangan', Icons.theater_comedy),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Label Populer
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

          // Grid Kostum (Home)
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
                  image: 'assets/images/taridewas.png',
                  price: '80.000',
                  size: 'M - XL',
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        // Navigasi khusus untuk kategori Tari Dewasa sesuai permintaan
        if (title == 'Tari Dewasa') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryDetailPage(categoryTitle: title),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Kategori $title segera hadir!"),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      child: Column(
        children: [
          Material(
            elevation: 3,
            shadowColor: Colors.black26,
            shape: const CircleBorder(),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(icon, color: AppColors.primaryNavy),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 70,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
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
