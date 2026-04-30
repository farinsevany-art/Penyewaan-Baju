import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/costume_model.dart';
import '../widgets/costume_card.dart';
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
    Costume(id: '1', name: 'Gandrung', category: 'TARI DEWASA', price: 80000, stock: 10, imageUrl: 'assets/images/taridewasa.jpg', description: 'Kostum Gandrung.', size: 'M - XL'),
    Costume(id: '2', name: 'TPW Ver 2', category: 'TARI DEWASA', price: 85000, stock: 5, imageUrl: 'assets/images/tarikreasibaru.png', description: 'Kostum kreasi.', size: 'M - L'),
    Costume(id: '3', name: 'Ratu', category: 'RAJA & RATU', price: 175000, stock: 3, imageUrl: 'assets/images/rajaratu.jpg', description: 'Kostum Ratu.', size: 'M - XL'),
    Costume(id: '4', name: 'Pewayangan', category: 'PEWAYANGAN', price: 120000, stock: 6, imageUrl: 'assets/images/wayang.jpg', description: 'Kostum Wayang.', size: 'L - XL'),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeContent(costumes: dummyCostumes),
      const WishlistPage(),
      const Center(child: Text("Halaman Keranjang")),
      const SearchPage(),
      const Center(child: Text("Halaman Profil")),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryNavy,
        unselectedItemColor: Colors.grey,
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
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  int _activePage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToContent() {
    _scrollController.animateTo(
      540, 
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutQuart,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
            opacity: 0.4, 
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // --- HEADER ---
              Stack(
                children: [
                  ClipPath(
                    clipper: MyHeaderClipper(),
                    child: Container(
                      height: 350, 
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/home.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(color: Colors.black.withOpacity(0.35)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSearchBar(context),
                        const SizedBox(height: 35),
                        _buildHeaderText(),
                      ],
                    ),
                  ),
                ],
              ),

              // --- INDICATORS ---
              Transform.translate(
                offset: const Offset(0, -25),
                child: _buildIndicators(),
              ),
              SizedBox(
                height: 155, // Tinggi disesuaikan dengan ukuran ikon baru
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) => setState(() => _activePage = page),
                  children: [
                    _buildCurvedCategories(context, screenWidth),
                    const Center(child: Text("Halaman 2")),
                  ],
                ),
              ),

              _buildSectionHeader("POPULER"),

              // --- GRID PRODUK ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.costumes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    return CostumeCard(costume: widget.costumes[index]);
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

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 8, height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _activePage == index ? const Color(0xFF5D4037) : Colors.grey.withOpacity(0.4),
          ),
        );
      }),
    );
  }

  // --- KATEGORI LEBIH BESAR & PADAT ---
  Widget _buildCurvedCategories(BuildContext context, double width) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(left: 15, top: 0, child: _catItem(context, 'Tari\nDewasa', 'assets/images/taridewasa.jpg', 1)),
        Positioned(left: width * 0.28, top: 15, child: _catItem(context, 'Tari\nAnak', 'assets/images/kostumtarianak.jpg', 2)),
        Positioned(right: width * 0.28, top: 15, child: _catItem(context, 'Raja &\nRatu', 'assets/images/rajaratu.jpg', 3)),
        Positioned(right: 15, top: 0, child: _catItem(context, 'Wayang', 'assets/images/wayang.jpg', 4)),
      ],
    );
  }

  Widget _catItem(BuildContext context, String title, String path, int type) {
    return GestureDetector(
      onTap: () {
        Widget page = const CategoryDetailPage(categoryTitle: 'Tari Dewasa');
        if (type == 2) page = const Category2DetailPage(categoryTitle: 'Tari Anak');
        if (type == 3) page = const Category3DetailPage(categoryTitle: 'Raja & Ratu');
        if (type == 4) page = const Category4DetailPage(categoryTitle: 'Pewayangan');
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: CircleAvatar(
              radius: 35, // UKURAN IKON DIPERBESAR
              backgroundImage: AssetImage(path),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title, 
            textAlign: TextAlign.center, 
            style: const TextStyle(
              fontSize: 12, // UKURAN FONT DIPERBESAR
              fontWeight: FontWeight.bold, // DIBUAT BOLD AGAR TEGAS
              height: 1.1,
              color: Colors.black87
            ),
          ),
        ],
      ),
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

  Widget _buildHeaderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("KUSUMA", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 3.0)),
        const Text("CANTIKA", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 3.0, height: 0.9)),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: _scrollToContent,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE4B04B),
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          ),
          child: const Text("SEWA SEKARANG", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const Text('Tersedia >', style: TextStyle(color: Color(0xFFE4B04B), fontSize: 14, fontWeight: FontWeight.bold)),
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
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}