import 'dart:async'; // TAMBAHKAN IMPORT INI UNTUK TIMER
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/colors.dart';
import '../../../data/services/order_service.dart';
import '../../auth/widgets/auth_background.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<dynamic> _myOrders = [];
  bool _isLoading = true;
  Timer? _timer; // VARIABEL TIMER

  @override
  void initState() {
    super.initState();
    _fetchMyOrders(showLoading: true);

    // FITUR REAL-TIME: Mengecek database secara diam-diam setiap 3 detik
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _fetchMyOrders(showLoading: false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // MATIKAN TIMER SAAT PINDAH HALAMAN
    super.dispose();
  }

  // Parameter showLoading agar saat auto-refresh layarnya tidak kedap-kedip
  Future<void> _fetchMyOrders({bool showLoading = false}) async {
    if (!mounted) return;
    if (showLoading) setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    String? userIdStr = prefs.getString('user_id');

    int idPelanggan = 1;
    if (userIdStr != null && userIdStr.isNotEmpty) {
      idPelanggan = int.tryParse(userIdStr) ?? 1;
    }

    final data = await OrderService.getOrders(idPelanggan: idPelanggan);

    if (mounted) {
      setState(() {
        _myOrders = data;
        if (showLoading) _isLoading = false;
      });
    }
  }

  String formatRupiah(String numberStr) {
    double number = double.tryParse(numberStr) ?? 0;
    return "Rp ${number.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0.5,
        title: const Text(
          "Pesanan Saya",
          style: TextStyle(
            color: Color(0xFF0D1B3E),
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: () => _fetchMyOrders(showLoading: true),
          ),
        ],
      ),
      body: AuthBackground(
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryNavy,
                  ),
                )
              : _myOrders.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () => _fetchMyOrders(showLoading: true),
                  color: AppColors.primaryNavy,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _myOrders.length,
                    itemBuilder: (context, index) {
                      final order = _myOrders[index];
                      return _buildOrderCard(order);
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    // 🔻 PERBAIKAN: Menggunakan ID Penyewaan sesuai saran Anda 🔻
    String orderId = order['id_penyewaan']?.toString() ?? '-';
    String displayTitle = "ID Penyewaan: $orderId";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  displayTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: AppColors.primaryNavy,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildStatusBadge(order['status_penyewaan'] ?? 'Menunggu'),
            ],
          ),
          const Divider(height: 25),
          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                size: 20,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                "${order['tanggal_sewa']} s/d ${order['tanggal_kembali']}",
                style: const TextStyle(color: Colors.black87, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                size: 20,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  order['items_summary'] ?? '-',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Pembayaran",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  formatRupiah(order['total_harga'].toString()),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: AppColors.primaryNavy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor = Colors.grey.shade200;
    Color textColor = Colors.black;

    if (status.contains('Menunggu')) {
      bgColor = Colors.orange.shade50;
      textColor = Colors.orange.shade800;
    } else if (status.contains('Diproses')) {
      bgColor = Colors.blue.shade50;
      textColor = Colors.blue.shade800;
    } else if (status.contains('Disewa')) {
      bgColor = Colors.green.shade50;
      textColor = Colors.green.shade800;
    } else if (status.contains('Selesai')) {
      bgColor = Colors.teal.shade50;
      textColor = Colors.teal.shade800;
    } else if (status.contains('Batal')) {
      bgColor = Colors.red.shade50;
      textColor = Colors.red.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            "Belum ada pesanan",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Pesanan yang Anda buat akan muncul di sini.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
