import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/costume_model.dart';
import '../../../data/services/mock_data.dart';
import '../../../data/services/stock_service.dart'; // Untuk imageBaseUrl
import '../../../data/services/order_service.dart'; // Untuk fitur Checkout
import 'home_page.dart';

class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage({super.key});

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  // --- STATE DATA ---
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));
  String namaPanggilan = "Iriya Crimson";
  String nomorHp = "+62 0000 0000";

  // --- HELPER: FORMAT RUPIAH ---
  String formatRupiah(double number) {
    return "Rp ${number.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  // --- FUNGSI: PILIH TANGGAL ---
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.black),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }

  // --- FUNGSI: POP-UP EDIT PROFIL ---
  void _showEditDialog() {
    TextEditingController nameController = TextEditingController(
      text: namaPanggilan,
    );
    TextEditingController phoneController = TextEditingController(
      text: nomorHp,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Profil Pengirim"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nama Panggilan"),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Nomor HP"),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                namaPanggilan = nameController.text;
                nomorHp = phoneController.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          "KONFIRMASI PESANAN",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // 1. BACKGROUND GAMBAR
          Positioned.fill(
            child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
          ),
          // 2. KONTEN UTAMA
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 10),
                const Text(
                  "SELECTED COSTUMES",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 15),
                // Daftar Baju
                ...cartItemsGlobal.map((item) => _buildItemCard(item)).toList(),
                const SizedBox(height: 10),
                const Text(
                  "DELIVERY DETAILS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 10),
                _buildDeliverySection(),
                const SizedBox(height: 25),
                _buildSummarySection(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomButton(), // Memanggil tombol bawah
    );
  }

  // --- WIDGET: KARTU ITEM ---
  Widget _buildItemCard(Costume item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // PERBAIKAN: Menggunakan Image.network dan handle null
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                    ? Image.network(
                        "${StockService.imageBaseUrl}${item.imageUrl}",
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade300,
                        ),
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade300,
                      ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      formatRupiah(item.price),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Size: ${item.size ?? '-'}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Tambah Kurang Jumlah
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18),
                      onPressed: () => setState(
                        () => item.quantity > 1 ? item.quantity-- : null,
                      ),
                    ),
                    Text(
                      "${item.quantity}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18),
                      onPressed: () {
                        if (item.quantity < item.stock) {
                          setState(() => item.quantity++);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Batas stok tercapai!'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Tombol Durasi Sewa
          InkWell(
            onTap: () => _selectDateRange(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4F8).withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 18),
                  const SizedBox(width: 10),
                  const Text("Durasi Sewa"),
                  const Spacer(),
                  Text(
                    "${DateFormat('MMM dd').format(startDate)} - ${DateFormat('MMM dd').format(endDate)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.edit_outlined, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET: PENGIRIM ---
  Widget _buildDeliverySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                namaPanggilan,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              GestureDetector(
                onTap: _showEditDialog,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: const [
                      Text(
                        "Edit ",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.edit, size: 14),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Text(nomorHp, style: const TextStyle(color: Colors.grey)),
          const Divider(height: 30),
          Row(
            children: const [
              Icon(
                Icons.location_on_outlined,
                color: Colors.blueAccent,
                size: 24,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "123 Fashion Ave, Apartment 4B\nManhattan, NY 10001",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- WIDGET: RINGKASAN HARGA ---
  Widget _buildSummarySection() {
    double total = 0;
    int totalItems = 0;
    for (var item in cartItemsGlobal) {
      total += item.price * item.quantity;
      totalItems += item.quantity;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F6FB).withOpacity(0.9),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ringkasan Pesanan",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(height: 15),
          ...cartItemsGlobal.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${item.name} (${item.quantity}x)",
                    style: const TextStyle(color: Colors.black54),
                  ),
                  Text(
                    formatRupiah(item.price * item.quantity),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Item", style: TextStyle(color: Colors.black54)),
              Text(
                "$totalItems kostum",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Pembayaran",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                formatRupiah(total),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- WIDGET: TOMBOL BAWAH ---
  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      color: Colors.white,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () async {
          if (cartItemsGlobal.isEmpty) return;

          // 1. Ambil ID Pelanggan yang sedang login
          final prefs = await SharedPreferences.getInstance();
          // Gunakan ID default 1 (Misal Budi) jika belum ada sistem login statis
          int idPelanggan =
              int.tryParse(prefs.getString('user_id') ?? '1') ?? 1;

          // 2. Hitung total harga & siapkan keranjang
          double total = 0;
          List<Map<String, dynamic>> items = [];

          for (var item in cartItemsGlobal) {
            double subtotal = item.price * item.quantity;
            total += subtotal;
            items.add({
              "id_kostum": int.parse(item.id),
              "jumlah": item.quantity,
              "subtotal": subtotal,
            });
          }

          // 3. Susun data Order
          Map<String, dynamic> orderData = {
            "id_pelanggan": idPelanggan,
            "tanggal_sewa": DateFormat('yyyy-MM-dd').format(startDate),
            "tanggal_kembali": DateFormat('yyyy-MM-dd').format(endDate),
            "total_harga": total,
            "items": items,
          };

          // 4. Kirim ke Database Backend
          final res = await OrderService.checkoutPesanan(orderData);

          if (res['status'] == 'success') {
            // Jika sukses, kosongkan keranjang
            setState(() {
              cartItemsGlobal.clear();
            });

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Pesanan berhasil dibuat!")),
              );
              // Kembali ke halaman Home
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomerHomePage(),
                ),
                (route) => false,
              );
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(res['message'])));
            }
          }
        },
        child: const Text(
          "PESAN SEKARANG",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
