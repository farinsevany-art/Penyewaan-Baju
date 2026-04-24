import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/costume_model.dart';

class CostumeCard extends StatefulWidget {

  final Costume? costume;

  
  final String? name;
  final String? image;
  final String? price;
  final String? size;

  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const CostumeCard({
    super.key,
    this.costume,
    this.name,
    this.image,
    this.price,
    this.size,
    this.onTap,
    this.onAddToCart,
  });

  @override
  State<CostumeCard> createState() => _CostumeCardState();
}

class _CostumeCardState extends State<CostumeCard> {
  String get _name => widget.costume?.name ?? widget.name ?? '';
  String get _image => widget.costume?.imageUrl ?? widget.image ?? '';
  String get _price => widget.costume?.formattedPrice ??
      (widget.price != null ? 'Rp. ${widget.price}' : '');
  String get _size => widget.costume?.size ?? widget.size ?? '';
  bool get _isWishlisted => widget.costume?.isWishlisted ?? false;

  void _toggleWishlist() {
    if (widget.costume == null) return;
    setState(() {
      widget.costume!.isWishlisted = !widget.costume!.isWishlisted;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        widget.costume!.isWishlisted
            ? '$_name ditambahkan ke wishlist'
            : '$_name dihapus dari wishlist',
      ),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: widget.costume!.isWishlisted
          ? AppColors.primaryNavy
          : Colors.red.shade700,
    ));
  }

  void _handleAddToCart() {
    if (widget.onAddToCart != null) {
      widget.onAddToCart!();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$_name ditambahkan ke keranjang'),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.primaryNavy,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 5),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Gambar + tombol wishlist ──
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: Image.asset(
                      _image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFE8DDD0),
                        child: const Center(
                          child: Icon(Icons.image_not_supported_outlined,
                              size: 36, color: Color(0xFFB0A090)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: _toggleWishlist,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isWishlisted
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: _isWishlisted
                              ? Colors.red.shade600
                              : AppColors.mediumGrey,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info + tombol ──
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _name,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Ukuran: $_size',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: AppColors.mediumGrey,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _price,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Tombol Tambah Keranjang
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
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                        elevation: 0,
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