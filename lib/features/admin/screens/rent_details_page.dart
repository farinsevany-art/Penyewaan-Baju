import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/status_update_sheet.dart';
import '../../auth/widgets/auth_background.dart';
import '../../../data/services/order_service.dart';

class RentDetailsPage extends StatefulWidget {
  final String orderId; // Variabel penampung ID wajib dikirim saat navigasi

  const RentDetailsPage({
    super.key, 
    required this.orderId, 
  });

  @override
  State<RentDetailsPage> createState() => _RentDetailsPageState();
}

class _RentDetailsPageState extends State<RentDetailsPage> {
  String currentStatus = "Baru";
  Map<String, dynamic>? _orderData; // Menampung data pelanggan & ringkasan
  List<dynamic> _rentedItems = [];  // Menampung array pakaian yang disewa
  bool _isLoading = true;           // Status loading database

// 1. Pastikan initState memanggil data
@override
void initState() {
  super.initState();
  _fetchOrderDetails();
}

// 2. Ambil data dan set currentStatus dari DB
Future<void> _fetchOrderDetails() async {
  try {
    final response = await http.get(
      Uri.parse('http://localhost/api_penyewaan/get_order_details.php?id=${widget.orderId}'),
    );

    if (response.statusCode == 200) {
      final resBody = json.decode(response.body);
      
      if (resBody['status'] == 'success') {
        setState(() {
          _orderData = resBody['data']; 
          _rentedItems = resBody['items'];
          // Ambil status dari DB agar variabel currentStatus tidak default "Baru" terus
          currentStatus = _orderData?['status_penyewaan'] ?? "Baru"; 
          _isLoading = false;
        });
      }
    }
  } catch (e) {
    debugPrint("Error Fetch: $e");
    setState(() => _isLoading = false);
  }
}

// 3. Fungsi Popup dengan OrderService yang sudah di-import
void _showStatusPopup() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (context) {
      return StatusUpdateSheet(
        currentStatus: currentStatus,
        onSave: (newStatus) async {
          // Memanggil OrderService 
          bool success = await OrderService.updateOrderStatus(
            int.parse(widget.orderId),
            newStatus,
          );

          if (success) {
            setState(() {
              currentStatus = newStatus;
            });
            if (mounted) {
              Navigator.pop(context); // Tutup bottom sheet
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Status berhasil diperbarui!")),
              );
            }
          }
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.yellow),
          onPressed: () {
            Navigator.pop(context, true);
          },
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
              ? const Center(child: Text("Detail pesanan tidak ditemukan atau gagal dimuat."))
              : AuthBackground(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildOrderHeader(),
                        const SizedBox(height: 15),
                        _buildDateCard(),
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
                          "ITEMS RENTED",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.brown,
                          ),
                        ),
                        const SizedBox(height: 10),
                        
                        // Render daftar baju secara dinamis dari DB
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _rentedItems.length,
                          itemBuilder: (context, index) {
                            final item = _rentedItems[index];
                            return _itemTile(
                              item['nama_kostum'] ?? 'Tidak Diketahui', 
                              "Ukuran ${item['ukuran'] ?? '-'}", 
                              "Rp ${item['subtotal'] ?? '0'}"
                            );
                          },
                        ),
                        
                        const SizedBox(height: 10),
                        _buildPriceSummary(),
                        const SizedBox(height: 20),
                        _buildActionButtons(context),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("PESANAN ${widget.orderId}", 
              style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
            Text(
              "${_rentedItems.isNotEmpty ? _rentedItems[0]['nama_kostum'] : 'Data Kostum'}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 1.2),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: currentStatus == "Aktif" || currentStatus == "Aktif/Disewa" ? Colors.green.shade100 : Colors.blue.shade100,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            currentStatus,
            style: TextStyle(
              color: currentStatus == "Aktif" || currentStatus == "Aktif/Disewa" ? Colors.green : Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _dateColumn("TANGGAL PEMESANAN", _orderData!['tanggal_sewa'] ?? "-", ""),
          const Icon(Icons.arrow_forward, color: Colors.blue, size: 20),
          _dateColumn("TANGGAL PENGEMBALIAN", _orderData!['tanggal_kembali'] ?? "-", ""),
        ],
      ),
    );
  }

  Widget _dateColumn(String label, String date, String time) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
        Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildCustomerCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.orange.shade200),
      ),
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Colors.black, child: Icon(Icons.person, color: Colors.white)),
        title: Text(_orderData!['nama_pelanggan'] ?? "No Name", style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("HP: ${_orderData!['no_hp'] ?? '-'} \nAlamat: ${_orderData!['alamat'] ?? '-'}"),
        isThreeLine: true,
      ),
    );
  }

  Widget _itemTile(String name, String size, String price) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 50, 
          height: 50, 
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(size),
        trailing: Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
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
          const Text("Total Harga", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text("Rp ${_orderData!['total_harga'] ?? '0'}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _showStatusPopup,
      icon: const Icon(Icons.swap_horiz, color: Colors.white),
      label: const Text("Ubah Status", style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}