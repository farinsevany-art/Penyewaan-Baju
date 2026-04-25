import 'package:flutter/material.dart';
import 'rent_details_page.dart'; 

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ManajemenPesananScreen(),
  ));
}

class ManajemenPesananScreen extends StatefulWidget {
  const ManajemenPesananScreen({super.key});

  @override
  State<ManajemenPesananScreen> createState() => _ManajemenPesananScreenState();
}

class _ManajemenPesananScreenState extends State<ManajemenPesananScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7E9), // Background krem motif bunga
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(Icons.shield, color: Colors.yellow, size: 28), // Logo perisai/kuning
        ),
        title: const Text(
          'Manajemen Pesanan',
          style: TextStyle(color: Color(0xFFEEE4D1), fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.white)),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          indicatorWeight: 3,
          labelColor: Colors.brown,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "Baru"),
            Tab(text: "Aktif"),
            Tab(text: "Selesai"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPesananBaruList(), // Konten untuk tab 'Baru'
          const Center(child: Text("Tab Aktif")),
          const Center(child: Text("Tab Selesai")),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildPesananBaruList() {
    return Container(
      decoration: const BoxDecoration(
        // Catatan: Jika ingin menambahkan motif bunga, bisa menggunakan DecorationImage
        image: DecorationImage(
          image: NetworkImage('https://www.toptal.com/designers/subtlepatterns/patterns/floral-felt.png'),
          opacity: 0.1,
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Pesanan Terbaru", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(20)),
                child: const Text("4 Menunggu", style: TextStyle(fontSize: 12, color: Colors.blue)),
              )
            ],
          ),
          const SizedBox(height: 16),
          _buildOrderItem(
            name: "Sarah Jenkins",
            category: "Clara 1",
            status: "Menunggu Disetujui",
            isUrgent: true,
            imageUrl: "https://i.pravatar.cc/150?u=sarah",
          ),
          _buildOrderItem(
            name: "Michael Chen",
            category: "Rama",
            status: "Memproses Pembayaran",
            imageUrl: "https://i.pravatar.cc/150?u=michael",
          ),
          _buildOrderItem(
            name: "Elena Rodriguez",
            category: "Shinta",
            status: "Menunggu Pelunasan",
            imageUrl: "https://i.pravatar.cc/150?u=elena",
          ),
          _buildOrderItem(
            name: "David Wilson",
            category: "Raja",
            status: "Menunggu Verifikasi",
            imageUrl: "https://i.pravatar.cc/150?u=david",
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem({
    required String name,
    required String category,
    required String status,
    required String imageUrl,
    bool isUrgent = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.grey.shade200.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
        ),
        title: Row(
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (isUrgent) const SizedBox(width: 8),
            if (isUrgent)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(4)),
                child: const Text("PENTING", style: TextStyle(color: Colors.orange, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category, style: const TextStyle(color: Colors.blueGrey, fontSize: 13)),
            Text(status, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => const DetailPenyewaanScreen(),
            ),
          );
          // Navigasi ke halaman detail yang kita buat sebelumnya
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailPenyewaanScreen()));
        },
      ),
    );
  }
}