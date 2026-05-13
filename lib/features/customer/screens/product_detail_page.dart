import 'package:flutter/material.dart';
import '../../../data/models/costume_model.dart';
import '../../../data/services/mock_data.dart';
import 'rent_options_button_sheet.dart';
import '../../auth/widgets/auth_background.dart';

class ProductDetailPage extends StatefulWidget {
  final Costume costume;

  const ProductDetailPage({
    super.key,
    required this.costume,
    required Costume product,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late List<String> availableSizes;
  late String selectedSize;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    if (widget.costume.size != null && widget.costume.size!.isNotEmpty) {
      availableSizes = widget.costume.size!
          .split(',')
          .map((e) => e.trim())
          .toList();
    } else {
      availableSizes = ['All Size'];
    }
    selectedSize = availableSizes.first;
  }

  // MENGAMBIL SISA STOK BERDASARKAN UKURAN YANG DIKLIK SAAT INI
  int get currentStock =>
      widget.costume.sizeStocks[selectedSize] ?? widget.costume.stock;

  void _onSizeSelected(String newSize) {
    setState(() {
      selectedSize = newSize;
      // Jika pengguna ganti ukuran, cek apakah jumlah keranjang melebihi stok ukuran baru
      if (quantity > currentStock) {
        quantity = currentStock > 0 ? currentStock : 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        // --- PERUBAHAN: DITAMBAHKAN TEKS "KUSUMA CANTIKA" DI SAMPING LOGO ---
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Logotransparan.png', height: 40),
            const SizedBox(width: 8),
            const Text(
              "Kusuma Cantika",
              style: TextStyle(
                color: Color(0xFF0D1B3E),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.transparent),
            onPressed: () {},
          ),
        ],
      ),
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child:
                      widget.costume.imageUrl != null &&
                          widget.costume.imageUrl!.isNotEmpty
                      ? Image.network(
                          "$imageBaseUrl${widget.costume.imageUrl}",
                          width: double.infinity,
                          height: 350,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildErrorImage(),
                        )
                      : _buildErrorImage(),
                ),
                const SizedBox(height: 20),

                Text(
                  widget.costume.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D1B3E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.costume.formattedPrice,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0D1B3E),
                  ),
                ),
                const SizedBox(height: 25),

                // --- SISA STOK DITAMPILKAN DI SAMPING KANAN PILIHAN UKURAN ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Pilih Ukuran",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Sisa: $currentStock pcs", // Menggunakan stok dinamis
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: availableSizes.map((size) {
                    bool isSelected = selectedSize == size;
                    return GestureDetector(
                      onTap: () => _onSizeSelected(size),
                      child: Container(
                        width: size.length > 2 ? null : 55,
                        padding: size.length > 2
                            ? const EdgeInsets.symmetric(horizontal: 15)
                            : null,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF0D1B3E)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF0D1B3E)
                                : Colors.grey.shade300,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            size,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 25),

                const Text(
                  "Deskripsi",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.costume.description ?? 'Tidak ada deskripsi.',
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),

      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFFDF7F0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: IconButton(
                icon: Icon(
                  widget.costume.isWishlisted
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    widget.costume.isWishlisted = !widget.costume.isWishlisted;
                  });
                },
              ),
            ),
            const SizedBox(width: 15),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 18),
                    onPressed: () {
                      if (quantity > 1) setState(() => quantity--);
                    },
                  ),
                  Text(
                    "$quantity",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: () {
                      if (quantity < currentStock) setState(() => quantity++);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),

            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (context) => RentOptionsBottomSheet(
                      costume: widget.costume,
                      initialQuantity: quantity,
                      onConfirm: (selectedQty, startDate, endDate, days) {
                        setState(() {
                          // 🔻 LOGIKA BARU: Cek berdasarkan ID DAN UKURAN 🔻
                          int index = cartItemsGlobal.indexWhere(
                            (item) =>
                                item.id == widget.costume.id &&
                                item.selectedSize == selectedSize,
                          );

                          if (index != -1) {
                            // Jika ID & Ukuran yang sama sudah ada, cukup tambahkan jumlahnya
                            cartItemsGlobal[index].quantity += selectedQty;
                            // Update juga tanggalnya jika diperlukan
                            cartItemsGlobal[index].rentStartDate = startDate;
                            cartItemsGlobal[index].rentEndDate = endDate;
                            cartItemsGlobal[index].rentDays = days;
                          } else {
                            // Jika kombinasi ID & Ukuran belum ada, buat objek baru (clone)
                            // Gunakan instance baru agar data tidak menimpa satu sama lain
                            // Jika kombinasi ID & Ukuran belum ada, buat objek baru (clone)
                            final newCartItem = Costume(
                              id: widget.costume.id,
                              name: widget.costume.name,
                              price: widget.costume.price,
                              imageUrl: widget.costume.imageUrl,
                              size: widget.costume.size,
                              description: widget.costume.description,

                              // 🔻 TAMBAHKAN PARAMETER YANG DIMINTA DI SINI 🔻
                              category: widget.costume.category,
                              stock: widget.costume.stock,
                            );

                            // (Lanjutkan dengan kode rentStartDate dsb di bawahnya...)
                            newCartItem.rentStartDate = startDate;
                            newCartItem.rentEndDate = endDate;
                            // ... (kode Anda sebelumnya)
                            newCartItem.rentDays = days;
                            newCartItem.selectedSize =
                                selectedSize; // XL atau M
                            newCartItem.quantity = selectedQty;
                            newCartItem.isInCart = true;

                            cartItemsGlobal.add(newCartItem);
                          }
                        });

                        // Berikan feedback dan tutup sheet
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Berhasil menambah ${widget.costume.name} ($selectedSize) ke keranjang",
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D1B3E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  elevation: 0,
                ),
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text(
                  "Sewa",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorImage() {
    return Container(
      height: 350,
      color: const Color(0xFFE8DDD0),
      child: const Center(
        child: Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
      ),
    );
  }
}
