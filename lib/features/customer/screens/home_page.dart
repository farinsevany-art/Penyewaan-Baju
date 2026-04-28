import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/constants/colors.dart';
import '../../../data/models/costume_model.dart';
import '../widgets/costume_card.dart';
import '../../auth/widgets/auth_background.dart';
import 'wishlist_page.dart';
import 'search_page.dart';
import 'category_detail_page.dart';
import 'category2_detail_page.dart';
import 'category3_detail_page.dart';
import 'category4_detail_page.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  int _selectedIndex = 0;

  final List<Costume> dummyCostumes = [
    Costume(
      id: '1',
      name: 'Gandrung',
      category: 'TARI DEWASA',
      price: 80000,
      stock: 10,
      imageUrl: 'assets/images/taridewasa.jpg',
      description: 'Kostum tari Gandrung tradisional.',
      size: 'M - XL',
    ),
    Costume(
      id: '2',
      name: 'TPW Ver 2',
      category: 'TARI DEWASA',
      price: 85000,
      stock: 5,
      imageUrl: 'assets/images/tarikreasibaru.png',
      description: 'Kostum tari kreasi baru versi 2.',
      size: 'M - L',
    ),
    Costume(
      id: '3',
      name: 'Ratu',
      category: 'RAJA & RATU',
      price: 175000,
      stock: 3,
      imageUrl: 'assets/images/rajaratu.jpg',
      description: 'Kostum Ratu dengan jubah mewah.',
      size: 'M - XL',
    ),
    Costume(
      id: '4',
      name: 'Ratu Tradisional',
      category: 'RAJA & RATU',
      price: 150000,
      stock: 4,
      imageUrl: 'assets/images/raja.png',
      description: 'Kostum Ratu nuansa klasik.',
      size: 'M - XL',
    ),
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeContent(costumes: dummyCostumes),
      const WishlistPage(),
      const Center(child: Text("Halaman Keranjang")),
      const SearchPage(),
      const Center(child: Text("Halaman Profil")),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryNavy,
        unselectedItemColor: AppColors.mediumGrey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final List<Costume> costumes;
  const HomeContent({super.key, required this.costumes});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ─── HEADER BANNER DENGAN 4 BUNGA ───
              Stack(
                children: [
                  ClipPath(
                    clipper: MyHeaderClipper(),
                    child: Container(height: 380, color: AppColors.primaryNavy),
                  ),
                  
                  // Dekorasi Bunga di 4 Sisi
                  _buildFlower(top: 10, left: -30, rotation: 0),
                  _buildFlower(top: 10, right: -30, rotation: 90),
                  _buildFlower(bottom: 100, left: -30, rotation: 270),
                  _buildFlower(bottom: 100, right: -30, rotation: 180),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 60, 25, 0),
                    child: Column(
                      children: [
                        _buildSearchBar(context),
                        const SizedBox(height: 30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildHeaderText(),
                            const Spacer(),
                            Image.asset('assets/images/Home.png', height: 230, fit: BoxFit.contain),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // ─── KATEGORI ───
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCategoryCircle(context, 'Tari Dewasa', 'assets/images/taridewasa.jpg'),
                    _buildCategoryCircle(context, 'Tari Anak', 'assets/images/kostumtarianak.jpg'),
                    _buildCategoryCircle(context, 'Raja & Ratu', 'assets/images/rajaratu.jpg'),
                    _buildCategoryCircle(context, 'Pewayangan', 'assets/images/wayang.jpg'),
                  ],
                ),
              ),

              // ─── LABEL POPULER ───
              _buildSectionHeader("POPULER"),

              // ─── GRID KOSTUM ───
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.63, // Rasio agar tombol Sewa proporsional
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: widget.costumes.length,
                  itemBuilder: (context, index) {
                    final data = widget.costumes[index];
                    return CostumeCard(
                      costume: data,
                      onWishlistToggle: () => setState(() => data.isWishlisted = !data.isWishlisted),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Bunga dengan rotasi otomatis
  Widget _buildFlower({double? top, double? bottom, double? left, double? right, double rotation = 0}) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Opacity(
        opacity: 0.25,
        child: Transform.rotate(
          angle: rotation * math.pi / 180,
          child: Image.asset('assets/images/bunga.png', width: 160),
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "KUSUMA",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.5,
          ),
        ),
        const Text(
          "CANTIKA",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.5,
            height: 0.9,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE4B04B),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text(
            "SEWA SEKARANG",
            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage())),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: Colors.grey, size: 20),
            SizedBox(width: 10),
            Text('Cari kostum...', style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
          const Row(
            children: [
              Text('Tersedia ', style: TextStyle(color: Color(0xFFE4B04B), fontSize: 12, fontWeight: FontWeight.bold)),
              Icon(Icons.arrow_forward_ios, size: 10, color: Color(0xFFE4B04B)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCircle(BuildContext context, String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        Widget page;
        if (title == 'Tari Anak') page = const Category2DetailPage(categoryTitle: 'Tari Anak');
        else if (title == 'Raja & Ratu') page = const Category3DetailPage(categoryTitle: 'Raja & Ratu');
        else if (title == 'Pewayangan') page = const Category4DetailPage(categoryTitle: 'Pewayangan');
        else page = const CategoryDetailPage(categoryTitle: 'Tari Dewasa');
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imagePath),
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class MyHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 70);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 70);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}