import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/costume_model.dart';
import '../../../data/services/mock_data.dart';
import '../widgets/costume_card.dart';
import '../../auth/widgets/auth_background.dart';
import 'cart_page.dart';
// 🔻 Hapus import home_page atau customer_home_page dari sini

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  bool _isExploring = false;

  List<Costume> get _itemsToShow => _isExploring
      ? allCostumes
      : allCostumes.where((c) => c.isWishlisted).toList();

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          // ✅ FIX ERROR: Color argumen sudah benar
          backgroundColor: const Color.fromRGBO(243, 239, 239, 0.9),
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () {
              if (_isExploring) {
                setState(() => _isExploring = false);
              } else {
                // ✅ FIX NAVIGASI: Cukup pop saja, ini paling aman
                Navigator.pop(context);
              }
            },
          ),
          title: Text(
            _isExploring ? 'Jelajahi Kostum' : 'Wishlist',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.black87,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              },
            ),
          ],
        ),
        body: (_itemsToShow.isEmpty && !_isExploring)
            ? _buildEmpty()
            : _buildGrid(_itemsToShow),
      ),
    );
  }

  Widget _buildGrid(List<Costume> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return CostumeCard(
          costume: item,
          onAddToCart: () {
            setState(() {
              if (!cartItemsGlobal.contains(item)) {
                item.quantity = 1;
                item.isInCart = true;
                cartItemsGlobal.add(item);
              } else {
                item.quantity++;
              }
            });

            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${item.name} ditambah ke keranjang'),
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: 'CEK',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartPage()),
                    );
                  },
                ),
              ),
            );
          },
          onWishlistToggle: () {
            setState(() {
              item.isWishlisted = !item.isWishlisted;
            });
          },
        );
      },
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'Wishlist Kamu Kosong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => setState(() => _isExploring = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNavy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text('Jelajahi Kostum'),
          ),
        ],
      ),
    );
  }
}
