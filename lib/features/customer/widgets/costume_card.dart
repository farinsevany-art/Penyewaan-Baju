import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/costume_model.dart';
// 🔻 PASTIKAN IMPORT INI ADA
import '../../../data/services/mock_data.dart';
// 🔻 Tambahkan import halaman detail produk Anda
import '../screens/product_detail_page.dart';

class CostumeCard extends StatefulWidget {
  final Costume? costume;
  final String? name;
  final String? image;
  final String? price;
  final String? size;

  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onWishlistToggle;

  const CostumeCard({
    super.key,
    this.costume,
    this.name,
    this.image,
    this.price,
    this.size,
    this.onTap,
    this.onAddToCart,
    this.onWishlistToggle,
  });

  @override
  State<CostumeCard> createState() => _CostumeCardState();
}

class _CostumeCardState extends State<CostumeCard> {
  String get _name => widget.costume?.name ?? widget.name ?? '';
  String get _image => widget.costume?.imageUrl ?? widget.image ?? '';
  String get _price =>
      widget.costume?.formattedPrice ??
      (widget.price != null ? 'Rp. ${widget.price}' : '');
  String get _size => widget.costume?.size ?? widget.size ?? '';
  bool get _isWishlisted => widget.costume?.isWishlisted ?? false;

  void _handleWishlistClick() {
    if (widget.onWishlistToggle != null) {
      widget.onWishlistToggle!();
    } else {
      if (widget.costume == null) return;
      setState(() {
        widget.costume!.isWishlisted = !widget.costume!.isWishlisted;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.costume!.isWishlisted
                ? '$_name ditambahkan ke wishlist'
                : '$_name dihapus dari wishlist',
          ),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleAddToCart() {
    if (widget.costume != null) {
      if (!cartItemsGlobal.contains(widget.costume)) {
        setState(() {
          widget.costume!.isInCart = true;
          widget.costume!.quantity = 1;
          cartItemsGlobal.add(widget.costume!);
        });
      } else {
        setState(() {
          widget.costume!.quantity++;
        });
      }
    }

    if (widget.onAddToCart != null) {
      widget.onAddToCart!();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_name ditambahkan ke keranjang'),
        backgroundColor: const Color.fromARGB(255, 7, 32, 60),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 🔥 Perbaikan: Menambahkan aksi default untuk navigasi ke halaman detail
      onTap:
          widget.onTap ??
          () {
            if (widget.costume != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailPage(costume: widget.costume!),
                ),
              );
            }
          },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: _image.isNotEmpty
                        ? Image.network(
                            "$imageBaseUrl$_image",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFFE8DDD0),
                              child: const Center(
                                child: Icon(Icons.image_not_supported_outlined),
                              ),
                            ),
                          )
                        : Container(
                            color: const Color(0xFFE8DDD0),
                            child: const Center(
                              child: Icon(Icons.image_not_supported_outlined),
                            ),
                          ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: _handleWishlistClick,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isWishlisted
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: _isWishlisted
                              ? Colors.red.shade600
                              : Colors.grey,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Ukuran: $_size',
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _price,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton.icon(
                      onPressed: _handleAddToCart,
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        size: 13,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Tambah Keranjang',
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 7, 32, 60),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
