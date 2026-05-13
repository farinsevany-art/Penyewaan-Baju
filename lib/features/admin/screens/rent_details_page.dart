import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/status_update_sheet.dart';
import '../../auth/widgets/auth_background.dart';
import '../../../data/services/order_service.dart';

class RentDetailsPage extends StatefulWidget {
  final String orderId;
  const RentDetailsPage({super.key, required this.orderId});

  @override
  State<RentDetailsPage> createState() => _RentDetailsPageState();
}

class _RentDetailsPageState extends State<RentDetailsPage> {
  String currentStatus = "Baru";
  Map<String, dynamic>? _orderData;
  List<dynamic> _rentedItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${OrderService.baseUrl}/get_order_details.php?id=${widget.orderId}',
        ),
      );
      if (response.statusCode == 200) {
        final resBody = json.decode(response.body);
        if (resBody['status'] == 'success') {
          setState(() {
            _orderData = resBody['data'];
            _rentedItems = resBody['items'];
            currentStatus = _orderData?['status_penyewaan'] ?? "Baru";
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // --- FUNGSI FORMAT RUPIAH ---
  String formatRupiah(double number) {
    return "Rp ${number.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
    // HITUNG TOTAL HARI SEWA
    int totalDays = 1;
    if (_orderData != null &&
        _orderData!['tanggal_sewa'] != null &&
        _orderData!['tanggal_kembali'] != null) {
      DateTime start = DateTime.parse(_orderData!['tanggal_sewa']);
      DateTime end = DateTime.parse(_orderData!['tanggal_kembali']);
      totalDays = end.difference(start).inDays;
      if (totalDays <= 0) totalDays = 1;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDF7E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.yellow),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text(
          'Detail Penyewaan',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orderData == null
          ? const Center(child: Text("Gagal memuat data"))
          : AuthBackground(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderHeader(),
                    const SizedBox(height: 15),
                    _buildDateCard(totalDays),
                    const SizedBox(height: 20),
                    const Text(
                      "INFORMASI PENYEWA",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildCustomerCard(),
                    const SizedBox(height: 20),
                    const Text(
                      "DAFTAR KOSTUM DISEWA",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(height: 10),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _rentedItems.length,
                      itemBuilder: (context, index) {
                        final item = _rentedItems[index];
                        return _itemTile(
                          item['nama_kostum'] ?? 'Kostum',
                          "Ukuran ${item['ukuran'] ?? '-'}",
                          double.tryParse(
                                item['harga_sewa']?.toString() ?? '0',
                              ) ??
                              0,
                          int.tryParse(item['jumlah']?.toString() ?? '1') ?? 1,
                          totalDays,
                          item['foto_kostum']?.toString() ?? "",
                        );
                      },
                    ),

                    const SizedBox(height: 10),
                    _buildPriceSummary(),
                    const SizedBox(height: 20),
                    _buildActionButtons(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildOrderHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "${_rentedItems.isNotEmpty ? _rentedItems[0]['nama_kostum'] : 'Data Kostum'}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Color(0xFF1A237E),
            ),
          ),
        ),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        currentStatus,
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildDateCard(int days) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _dateCol("TGL SEWA", _orderData!['tanggal_sewa'] ?? "-"),
              const Icon(Icons.arrow_forward, color: Colors.blue, size: 20),
              _dateCol("TGL KEMBALI", _orderData!['tanggal_kembali'] ?? "-"),
            ],
          ),
          const Divider(height: 25),
          Text(
            "Durasi Penyewaan: $days Hari",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateCol(String label, String date) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
        Text(
          date,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildCustomerCard() {
    String foto = _orderData!['foto_pelanggan'] ?? "";
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.orange.shade200),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          backgroundImage: foto.isNotEmpty
              ? NetworkImage("${OrderService.baseUrl}/uploads/profiles/$foto")
              : null,
          child: foto.isEmpty
              ? const Icon(Icons.person, color: Colors.grey)
              : null,
        ),
        title: Text(
          _orderData!['nama_pelanggan'] ?? "No Name",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${_orderData!['no_hp']}\n${_orderData!['alamat']}"),
        isThreeLine: true,
      ),
    );
  }

  Widget _itemTile(
    String name,
    String size,
    double price,
    int qty,
    int days,
    String foto,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // 🔻 MENAMPILKAN FOTO KOSTUM 🔻
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: foto.isNotEmpty
                  // UBAH FOLDER 'uploads/kostum/' SESUAIKAN DENGAN LOKASI FOTO ANDA DI HTDOCS
                  ? Image.network(
                      "${OrderService.baseUrl}/uploads/$foto",
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 65,
                        height: 65,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    )
                  : Container(
                      width: 65,
                      height: 65,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔻 NAMA LEBIH DETAIL 🔻
                  Text(
                    "Menyewa $name",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    size,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 6),

                  // 🔻 RINCIAN HARGA LENGKAP: 5x Rp 80.000 x 3 Hari 🔻
                  Text(
                    "${qty}x ${formatRupiah(price)} x $days Hari",
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // TOTAL HARGA ITEM
            Text(
              formatRupiah(price * qty * days),
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF1A237E),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFEEE4D1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Total Harga",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            formatRupiah(double.parse(_orderData!['total_harga'].toString())),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return ElevatedButton(
      onPressed: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        // 🔻 PERBAIKAN: Kata "const" dihilangkan dari RoundedRectangleBorder
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        builder: (c) => StatusUpdateSheet(
          currentStatus: currentStatus,
          onSave: (s) async {
            if (await OrderService.updateOrderStatus(
              int.parse(widget.orderId),
              s,
            )) {
              setState(() => currentStatus = s);
              Navigator.pop(context);
            }
          },
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text(
        "Ubah Status",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
