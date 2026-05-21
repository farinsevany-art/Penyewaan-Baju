import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/costume_model.dart';
import '../../../data/services/mock_data.dart';
import '../../../data/services/stock_service.dart';
import '../../auth/widgets/auth_background.dart';
import 'payment_page.dart';

class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage({super.key});

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  String namaPanggilan = "Pelanggan";
  String nomorHp = "-";
  String alamat = "-";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      namaPanggilan = prefs.getString('name') ?? "Pelanggan";
      nomorHp = prefs.getString('phone') ?? "-";
      alamat = prefs.getString('address') ?? "-";
    });
  }

  String formatRupiah(double number) {
    return "Rp ${number.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0D1B3E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "KONFIRMASI PESANAN",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF0D1B3E),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0,
        foregroundColor: const Color(0xFF0D1B3E),
      ),
      body: AuthBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              const Text(
                "DAFTAR KOSTUM",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 10),
              ...cartItemsGlobal.map((item) => _buildItemCard(item)).toList(),

              const SizedBox(height: 20),
              const Text(
                "DETAIL PENERIMA",
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
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildItemCard(Costume item) {
    String rentDuration = "Tanggal belum diatur";
    if (item.rentStartDate != null && item.rentEndDate != null) {
      rentDuration =
          "${DateFormat('dd MMM').format(item.rentStartDate!)} - ${DateFormat('dd MMM yyyy').format(item.rentEndDate!)} (${item.rentDays} Hari)";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                    ? Image.network(
                        "${StockService.imageBaseUrl}${item.imageUrl}",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey.shade300,
                        ),
                      )
                    : Container(
                        width: 60,
                        height: 60,
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
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "Uk. ${item.selectedSize ?? '-'}  x  ${item.quantity}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatRupiah(item.price),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0D1B3E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              const Icon(Icons.calendar_month, size: 16, color: Colors.orange),
              const SizedBox(width: 8),
              Text(
                rentDuration,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            namaPanggilan,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(nomorHp, style: const TextStyle(color: Colors.grey)),
          const Divider(height: 20),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.redAccent,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  alamat,
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    double total = 0;
    for (var item in cartItemsGlobal) {
      total += item.price * item.quantity * item.rentDays;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ringkasan Belanja",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 15),
          ...cartItemsGlobal.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${item.name} (${item.quantity}x) - ${item.rentDays}hr",
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    formatRupiah(item.price * item.quantity * item.rentDays),
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
              const Text(
                "Total Pembayaran",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                formatRupiah(total),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: Color(0xFF0D1B3E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D1B3E),
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: _isLoading
            ? null
            : () async {
                if (cartItemsGlobal.isEmpty) return;

                setState(() => _isLoading = true);

                final prefs = await SharedPreferences.getInstance();
                int idPelanggan =
                    int.tryParse(prefs.getString('user_id') ?? '1') ?? 1;

                double total = 0;
                List<Map<String, dynamic>> items = [];
                DateTime? tglMulai =
                    cartItemsGlobal.first.rentStartDate ?? DateTime.now();
                DateTime? tglSelesai =
                    cartItemsGlobal.first.rentEndDate ??
                    DateTime.now().add(const Duration(days: 2));

                for (var item in cartItemsGlobal) {
                  double subtotal = item.price * item.quantity * item.rentDays;
                  total += subtotal;
                  items.add({
                    "id_kostum": int.parse(item.id),
                    "ukuran": item.selectedSize,
                    "jumlah": item.quantity,
                    "subtotal": subtotal,
                  });
                }

                Map<String, dynamic> orderData = {
                  "id_pelanggan": idPelanggan,
                  "tanggal_sewa": DateFormat('yyyy-MM-dd').format(tglMulai),
                  "tanggal_kembali": DateFormat(
                    'yyyy-MM-dd',
                  ).format(tglSelesai),
                  "total_harga": total,
                  "items": items,
                };

                setState(() => _isLoading = false);

                // 🔻 Pindah ke halaman pembayaran dengan membawa data 🔻
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PaymentPage(totalAmount: total, orderData: orderData),
                    ),
                  );
                }
              },
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "LANJUT PEMBAYARAN",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
