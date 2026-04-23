import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/costume_model.dart';
import '../../../data/services/mock_data.dart';
 
class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});
 
  @override
  State<WishlistPage> createState() => _WishlistPageState();
}
 
class _WishlistPageState extends State<WishlistPage> {
  List<Costume> get _wishlisted =>
      allCostumes.where((c) => c.isWishlisted).toList();
 
  int _cartCount = 0;
  int _selectedNav = 1;
 
  void _toggleWishlist(Costume item) {
    setState(() => item.isWishlisted = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${item.name} dihapus dari wishlist'),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.red.shade700,
    ));
  }
 
  void _addToCart(Costume item) {
    setState(() => _cartCount++);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${item.name} ditambahkan ke keranjang'),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.primaryNavy,
      action: SnackBarAction(
        label: 'Lihat',
        textColor: AppColors.primaryGold,
        onPressed: () {},
      ),
    ));
  }
 
  @override
  Widget build(BuildContext context) {
    final items = _wishlisted;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 20, color: Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Wishlist',
          style: TextStyle(
              color: Colors.black87,
              fontSize: 17,
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 22, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: items.isEmpty ? _buildEmpty() : _buildList(items),
      bottomNavigationBar: _buildBottomNav(),
    );
  }
 
  Widget _buildList(List<Costume> items) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: items.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
      itemBuilder: (context, i) => _buildCard(items[i]),
    );
  }
 
  Widget _buildCard(Costume item) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 270,
                child: Image.asset(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFE8DDD0),
                    child: const Center(
                      child: Icon(Icons.image_not_supported_outlined,
                          size: 48, color: Color(0xFFB0A090)),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 12,
                child: GestureDetector(
                  onTap: () => _toggleWishlist(item),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Icon(Icons.favorite,
                        color: Colors.red.shade600, size: 18),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.formattedPrice,
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _addToCart(item),
                  icon: const Icon(Icons.shopping_cart_outlined, size: 14),
                  label: const Text(
                    'Tambah Keranjang',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNavy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
 
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Wishlist Kosong',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan kostum favoritmu ke wishlist',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).maybePop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNavy,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('Jelajahi Kostum'),
          ),
        ],
      ),
    );
  }
 
  Widget _buildBottomNav() {
    final navItems = [
      {'icon': Icons.home_outlined, 'active': Icons.home, 'label': 'Home'},
      {
        'icon': Icons.favorite_outline,
        'active': Icons.favorite,
        'label': 'Wishlist'
      },
      {
        'icon': Icons.shopping_cart_outlined,
        'active': Icons.shopping_cart,
        'label': 'Pesanan'
      },
      {'icon': Icons.search, 'active': Icons.search, 'label': 'Cari'},
      {
        'icon': Icons.person_outline,
        'active': Icons.person,
        'label': 'Profil'
      },
    ];
 
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border(top: BorderSide(color: Colors.grey.shade200, width: 0.5)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(navItems.length, (i) {
              final active = i == _selectedNav;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedNav = i);
                    if (i == 0) Navigator.of(context).maybePop();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            active
                                ? navItems[i]['active'] as IconData
                                : navItems[i]['icon'] as IconData,
                            size: 22,
                            color: active
                                ? AppColors.primaryGold
                                : AppColors.mediumGrey,
                          ),
                          if (i == 2 && _cartCount > 0)
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Text(
                                    _cartCount > 9 ? '9+' : '$_cartCount',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        navItems[i]['label'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: active
                              ? AppColors.primaryGold
                              : AppColors.mediumGrey,
                          fontWeight: active
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
 