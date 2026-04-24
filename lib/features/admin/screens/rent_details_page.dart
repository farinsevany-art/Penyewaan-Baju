import 'package:flutter/material.dart';

void main() {
  runApp(const RentalApp());
}

class RentalApp extends StatelessWidget {
  const RentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Serif'), // Menggunakan font bergaya klasik jika ada
      home: const DetailPenyewaanScreen(),
    );
  }
}

class DetailPenyewaanScreen extends StatelessWidget {
  const DetailPenyewaanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.yellow),
        title: const Text('Detail Penyewaan', style: TextStyle(color: Colors.white, fontSize: 18)),
        actions: const [Icon(Icons.more_vert, color: Colors.yellow), SizedBox(width: 10)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(),
            const SizedBox(height: 15),
            _buildDateCard(),
            const SizedBox(height: 20),
            const Text("INFORMASI PENYEWA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.brown)),
            const SizedBox(height: 10),
            _buildCustomerCard(),
            const SizedBox(height: 20),
            const Text("ITEMS RENTED", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.brown)),
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
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // Bagian Judul Pesanan & Status
  Widget _buildOrderHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("PESANAN #R-94021", style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text("TARI GANDRUNG L\nSRIKANDI VER 2 L", 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 1.2)),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(15)),
          child: const Text("Aktif", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
        )
      ],
    );
  }

  // Kartu Tanggal Pinjam & Kembali
  Widget _buildDateCard() {
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
              _dateColumn("TANGGAL PEMESANAN", "FEB 11, 2026", "09:00 AM"),
              const Icon(Icons.arrow_forward, color: Colors.blue, size: 20),
              _dateColumn("TANGGAL PENGEMBALIAN", "FEB 12, 2026", "06:00 PM"),
            ],
          ),
          const Divider(height: 25),
          const Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              SizedBox(width: 8),
              Text("Total Durasi: 1 hari", style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          )
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

  // Kartu Informasi Penyewa (Detail Lengkap)
  Widget _buildCustomerCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        children: [
          const ListTile(
            leading: CircleAvatar(backgroundColor: Colors.black, child: Icon(Icons.person, color: Colors.white)),
            title: Text("Alex Johnson", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Pelanggan • Pro", style: TextStyle(fontSize: 12)),
            trailing: Icon(Icons.chat_bubble_outline, color: Colors.black),
          ),
          const Divider(height: 1),
          _infoRow(Icons.email_outlined, "alex.johnson@email.com"),
          const Divider(height: 1),
          _infoRow(Icons.phone_outlined, "+1 (555) 012-3456"),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
            child: Icon(icon, size: 16, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  // List Barang
  Widget _itemTile(String name, String size, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(size, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Text("Jumlah: 1", style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  // Ringkasan Harga
  Widget _buildPriceSummary() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFEEE4D1).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Subtotal", style: TextStyle(color: Colors.grey)),
              Text("Rp.205.000", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Harga", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("Rp.205.000", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  // Tombol Aksi di Bawah
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.swap_horiz, color: Colors.white),
          label: const Text("Ubah Status", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.description, color: Colors.black),
                label: const Text("Nota", style: TextStyle(color: Colors.black)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 50),
                  side: const BorderSide(color: Colors.orange),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit, color: Colors.black),
                label: const Text("Edit", style: TextStyle(color: Colors.black)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 50),
                  side: const BorderSide(color: Colors.orange),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  // Bottom Navigation Bar
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      currentIndex: 1, // Focus pada 'Penyewaan'
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Penyewaan'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Stok'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'REPORTS'),
      ],
    );
  }
}