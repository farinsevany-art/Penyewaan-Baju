import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/status_update_sheet.dart';
import '../../auth/widgets/auth_background.dart';
import '../../../core/constants/colors.dart';
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

  String formatRupiah(double number) {
    return "Rp ${number.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: AppColors.primaryNavy,

      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset(
            'assets/images/Logotransparan.png',
            fit: BoxFit.contain,
          ),
        ),

        leadingWidth: 48,

        title: Text(
          "Detail Penyewaan",
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: AppColors.primaryGold),
        ),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.primaryGold,
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGold),
            )
          : _orderData == null
          ? const Center(
              child: Text(
                "Gagal memuat data",
                style: TextStyle(color: Colors.white),
              ),
            )
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
                        color: AppColors.primaryNavy,
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
                        color: AppColors.primaryNavy,
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
              color: AppColors.primaryNavy,
            ),
          ),
        ),

        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color bgColor = Colors.grey.shade200;
    Color textColor = Colors.black;

    if (currentStatus.contains('Menunggu')) {
      bgColor = Colors.orange.shade100;
      textColor = Colors.orange.shade800;
    } else if (currentStatus.contains('Diproses')) {
      bgColor = Colors.blue.shade100;
      textColor = Colors.blue.shade800;
    } else if (currentStatus.contains('Disewa')) {
      bgColor = Colors.green.shade100;
      textColor = Colors.green.shade800;
    } else if (currentStatus.contains('Selesai')) {
      bgColor = Colors.teal.shade100;
      textColor = Colors.teal.shade800;
    } else if (currentStatus.contains('Batal')) {
      bgColor = Colors.red.shade100;
      textColor = Colors.red.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
      ),

      child: Text(
        currentStatus,

        style: TextStyle(
          color: textColor,
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
        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: AppColors.primaryGold, width: 1.2),
      ),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              _dateCol("TGL SEWA", _orderData!['tanggal_sewa'] ?? "-"),

              const Icon(
                Icons.arrow_forward,
                color: AppColors.primaryNavy,
                size: 20,
              ),

              _dateCol("TGL KEMBALI", _orderData!['tanggal_kembali'] ?? "-"),
            ],
          ),

          const Divider(height: 25),

          Text(
            "Durasi Penyewaan: $days Hari",

            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryNavy,
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

          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.primaryNavy,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerCard() {
    String foto = _orderData!['foto_pelanggan'] ?? "";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: AppColors.primaryGold, width: 1.2),
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.all(14),

        leading: CircleAvatar(
          radius: 28,
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

          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryNavy,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),

          child: Text(
            "${_orderData!['no_hp']}\n${_orderData!['alamat']}",

            style: TextStyle(color: Colors.grey.shade700, height: 1.4),
          ),
        ),

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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: AppColors.primaryGold.withOpacity(0.4)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),

              child: foto.isNotEmpty
                  ? Image.network(
                      "${OrderService.baseUrl}/uploads/$foto",

                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,

                      errorBuilder: (_, __, ___) => Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey.shade200,

                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    )
                  : Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey.shade200,

                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "Menyewa $name",

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.primaryNavy,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    size,

                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),

                  const SizedBox(height: 6),

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

            Text(
              formatRupiah(price * qty * days),

              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: AppColors.primaryNavy,
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
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: AppColors.primaryGold, width: 1.5),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          const Text(
            "Total Harga",

            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.primaryNavy,
            ),
          ),

          Text(
            formatRupiah(double.parse(_orderData!['total_harga'].toString())),

            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.primaryNavy,
            ),
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
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,

        minimumSize: const Size(double.infinity, 55),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      child: const Text(
        "Ubah Status",

        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.white,
        ),
      ),
    );
  }
}
