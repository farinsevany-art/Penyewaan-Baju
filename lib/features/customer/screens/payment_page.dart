import 'package:flutter/material.dart';
import '../../../data/services/mock_data.dart';
import '../../../data/services/order_service.dart';
import '../../auth/widgets/auth_background.dart';
import 'home_page.dart';

class PaymentPage extends StatefulWidget {
  final double totalAmount;
  final Map<String, dynamic> orderData;

  const PaymentPage({
    super.key,
    required this.totalAmount,
    required this.orderData,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isLoading = false;
  String _selectedMethod = '';

  void _processPayment() async {
    if (_selectedMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Harap pilih metode pembayaran terlebih dahulu!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    widget.orderData['metode_pembayaran'] = _selectedMethod;

    final res = await OrderService.checkoutPesanan(widget.orderData);

    setState(() => _isLoading = false);

    if (res['status'] == 'success') {
      if (mounted) _showSuccessDialog();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res['message'])));
      }
    }
  }

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
              'Pembayaran Berhasil!',
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
                onPressed: () {
                  cartItemsGlobal.clear();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomerHomePage(),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D1B3E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0D1B3E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'PEMBAYARAN',
          style: TextStyle(
            color: Color(0xFF0D1B3E),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: AuthBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 15,
                  ),
                  children: [
                    // KOTAK TOTAL TAGIHAN
                    Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'TOTAL YANG HARUS DIBAYAR',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Rp ${widget.totalAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                            style: const TextStyle(
                              color: Color(0xFF0D1B3E),
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 35),

                    _buildHeaderSection('Tunai / Cash'),
                    _buildPaymentCard(
                      'Bayar Tunai di Tempat',
                      'assets/images/cash.png',
                      isLocalAsset: true,
                      description: 'Bayar saat mengambil kostum di toko',
                    ),

                    const SizedBox(height: 25),

                    _buildHeaderSection('Transfer Bank'),
                    _buildPaymentCard(
                      'Bank BCA',
                      'assets/images/bca.png',
                      isLocalAsset: true,
                      description: '8901 2345 67 (a.n. Kusuma Cantika)',
                    ),
                    _buildPaymentCard(
                      'Bank Mandiri',
                      'assets/images/mandiri.png',
                      isLocalAsset: true,
                      description: '1710 0012 3456 (a.n. Kusuma Cantika)',
                    ),

                    const SizedBox(height: 25),

                    _buildHeaderSection('Dompet Digital'),
                    _buildPaymentCard(
                      'OVO Cash',
                      'assets/images/ovo.png',
                      isLocalAsset: true,
                      description: '0812 3456 7890 (a.n. Kusuma Cantika)',
                    ),
                    _buildPaymentCard(
                      'GoPay',
                      'assets/images/gopay.png',
                      isLocalAsset: true,
                      description: '0812 3456 7890 (a.n. Kusuma Cantika)',
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // FOOTER BUTTON
              Container(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
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
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D1B3E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'BAYAR SEKARANG',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  // 🔻 DITAMBAHKAN PARAMETER 'description' UNTUK NOMOR REKENING 🔻
  Widget _buildPaymentCard(
    String name,
    String logoUrl, {
    bool isLocalAsset = false,
    String? description,
  }) {
    bool isSelected = _selectedMethod == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = name;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0D1B3E)
                : Colors.grey.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF0D1B3E).withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 30,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: isLocalAsset
                  ? Image.asset(
                      logoUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.payment, size: 20),
                    )
                  : Image.network(
                      logoUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.payment, size: 20),
                    ),
            ),
            const SizedBox(width: 16),

            // 🔻 DIGANTI MENJADI COLUMN AGAR BISA MENAMPUNG TEKS DESKRIPSI DI BAWAH NAMA 🔻
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.w900
                          : FontWeight.bold,
                      color: isSelected
                          ? const Color(0xFF0D1B3E)
                          : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFF0D1B3E).withOpacity(0.8)
                            : Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 10),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: isSelected ? const Color(0xFF0D1B3E) : Colors.grey,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
