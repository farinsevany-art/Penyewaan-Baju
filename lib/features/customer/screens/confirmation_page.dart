import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/costume_model.dart';
import '../../../data/services/mock_data.dart';
import '../../../data/services/stock_service.dart';
import '../../../data/services/order_service.dart';
import '../../auth/widgets/auth_background.dart';
import 'home_page.dart';

class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage({super.key});

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  String namaPanggilan = "Pelanggan";
  String nomorHp = "-";
  String alamat = "-";

  String selectedPaymentMethod = "Pilih Metode Pembayaran";
  String selectedPaymentLogo = "";
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

  void _showPaymentMethodDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Metode Pembayaran",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 15),
            // 🔻 UBAH LINK MENJADI ASSETS 🔻
            _buildPaymentOption("Tunai / Cash", "assets/images/cash.png"),
            _buildPaymentOption("Bank BCA", "assets/images/bca.png"),
            _buildPaymentOption("Bank Mandiri", "assets/images/mandiri.png"),
            _buildPaymentOption("GoPay", "assets/images/gopay.png"),
            _buildPaymentOption("OVO", "assets/images/ovo.png"),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String name, String logo) {
    return ListTile(
      // 🔻 UBAH Image.network MENJADI Image.asset 🔻
      leading: Image.asset(
        logo,
        width: 35,
        height: 35,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(Icons.payment),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: () {
        setState(() {
          selectedPaymentMethod = name;
          selectedPaymentLogo = logo;
        });
        Navigator.pop(context);
      },
    );
  }

  // --- NOTIFIKASI BERHASIL (LANGSUNG KEMBALI KE HOME) ---
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 80,
            ),
            const SizedBox(height: 20),
            const Text(
              'Pesanan Berhasil!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D1B3E),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Pesananmu sudah masuk dan sedang diproses. Silakan cek menu Pesanan.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D1B3E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                // PASTIKAN ANDA SUDAH MENGIMPORT HALAMAN HOME DI PALING ATAS
                // import 'customer_home_page.dart';
                onPressed: () {
                  cartItemsGlobal.clear(); // Kosongkan Keranjang

                  // 🔻 PERBAIKAN: Hancurkan semua riwayat dan set Home sebagai root 🔻
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomerHomePage(),
                    ),
                    (route) =>
                        false, // Ini akan menghapus semua route sebelumnya termasuk Login
                  );
                },
                child: const Text(
                  'KEMBALI KE BERANDA',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Transparent untuk AuthBackground
      appBar: AppBar(
        // 🔻 TAMBAHKAN LEADING INI AGAR TOMBOL BACK TERLIHAT
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0D1B3E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "KONFIRMASI PESANAN",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF0D1B3E), // Pastikan teks juga gelap
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

              const SizedBox(height: 20),
              const Text(
                "METODE PEMBAYARAN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 10),
              _buildPaymentSection(),

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

  Widget _buildPaymentSection() {
    return GestureDetector(
      onTap: _showPaymentMethodDialog,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        // ... potongan kode di dalam _buildPaymentSection ...
        child: Row(
          children: [
            if (selectedPaymentLogo.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 15),
                // 🔻 UBAH Image.network MENJADI Image.asset 🔻
                child: Image.asset(
                  selectedPaymentLogo,
                  width: 35,
                  height: 25,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.orange,
                    size: 25,
                  ),
                ),
              )
            else
              // ... sisa kode ...
              const Padding(
                padding: EdgeInsets.only(right: 15),
                child: Icon(Icons.account_balance_wallet, color: Colors.orange),
              ),
            Expanded(
              child: Text(
                selectedPaymentMethod,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: selectedPaymentMethod.contains("Pilih")
                      ? Colors.grey
                      : Colors.black,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    double total = 0;
    for (var item in cartItemsGlobal) {
      total += item.price * item.quantity * item.rentDays; // Hitung dengan hari
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
                if (selectedPaymentMethod.contains("Pilih")) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Harap pilih metode pembayaran!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

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
                    "ukuran": item.selectedSize, // 🔻 KIRIM UKURAN KE API
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
                  "metode_pembayaran":
                      selectedPaymentMethod, // 🔻 TAMBAHKAN BARIS INI
                  "items": items,
                };

                final res = await OrderService.checkoutPesanan(orderData);
                setState(() => _isLoading = false);

                if (res['status'] == 'success') {
                  if (mounted)
                    _showSuccessDialog(); // LANGSUNG TAMPILKAN POPUP BERHASIL
                } else {
                  if (mounted)
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(res['message'])));
                }
              },
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "PESAN SEKARANG",
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
