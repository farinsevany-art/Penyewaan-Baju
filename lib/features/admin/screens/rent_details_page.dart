import 'package:flutter/material.dart';
import '../widgets/status_update_sheet.dart';
import '../../auth/widgets/auth_background.dart';

class RentDetailsPage extends StatefulWidget {
  final String orderId; // Variabel penampung ID

  const RentDetailsPage({
    super.key, 
    required this.orderId, // Wajib diisi saat navigasi
  });

  @override
  State<RentDetailsPage> createState() => _RentDetailsPageState();
}

class _RentDetailsPageState extends State<RentDetailsPage> {
  String currentStatus = "Aktif/Disewa";

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
          onSave: (newStatus) {
            setState(() {
              currentStatus = newStatus;
            });
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Penyewaan',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: AuthBackground(
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
              _itemTile("Tari Gandrung 2", "Ukuran L", "Rp 80.000"),
              _itemTile("Srikandi Ver 2", "Ukuran L", "Rp 125.000"),
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
            // Menggunakan widget.orderId untuk menampilkan ID yang dikirim
            Text("PESANAN ${widget.orderId}", 
              style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
            const Text(
              "TARI GANDRUNG L\nSRIKANDI VER 2 L",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 1.2),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: currentStatus == "Aktif/Disewa" ? Colors.green.shade100 : Colors.blue.shade100,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            currentStatus,
            style: TextStyle(
              color: currentStatus == "Aktif/Disewa" ? Colors.green : Colors.blue,
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
          _dateColumn("TANGGAL PEMESANAN", "FEB 11, 2026", "09:00 AM"),
          const Icon(Icons.arrow_forward, color: Colors.blue, size: 20),
          _dateColumn("TANGGAL PENGEMBALIAN", "FEB 12, 2026", "06:00 PM"),
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
      child: const ListTile(
        leading: CircleAvatar(backgroundColor: Colors.black, child: Icon(Icons.person, color: Colors.white)),
        title: Text("Alex Johnson", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Pelanggan • Pro"),
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
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total Harga", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text("Rp.205.000", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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