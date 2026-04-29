import 'package:flutter/material.dart';
import 'rent_details_page.dart'; // Pastikan file ini ada
import 'rent_details_page.dart';
import '../../auth/widgets/auth_background.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ManajemenPesananScreen(),
    ),
  );
}

class ManajemenPesananScreen extends StatefulWidget {
  const ManajemenPesananScreen({super.key});

  @override
  State<ManajemenPesananScreen> createState() => _ManajemenPesananScreenState();
}

class _ManajemenPesananScreenState extends State<ManajemenPesananScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController
        .dispose(); // Praktik baik: hapus controller saat tidak dipakai
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(Icons.shield, color: Colors.yellow, size: 28),
        ),
        title: const Text(
          'Manajemen Pesanan',
          style: TextStyle(
            color: Color(0xFFEEE4D1),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor:
              Colors.white, // Ganti putih agar kontras dengan AppBar biru
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "Baru"),
            Tab(text: "Aktif"),
            Tab(text: "Selesai"),
          ],
        ),
      ),
      // PERBAIKAN: Hapus duplikasi properti 'body'
      body: AuthBackground(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildPesananBaruList(),
            const Center(child: Text("Tab Aktif")),
            const Center(child: Text("Tab Selesai")),
          ],
        ),
      ),
    );
  }

  Widget _buildPesananBaruList() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://www.toptal.com/designers/subtlepatterns/patterns/floral-felt.png',
          ),
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
              const Text(
                "Pesanan Terbaru",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "4 Menunggu",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildOrderItem(
            context, // Tambahkan context untuk navigasi
            name: "Sarah Jenkins",
            category: "Clara 1",
            status: "Menunggu Disetujui",
            isUrgent: true,
            imageUrl: "",
          ),
          _buildOrderItem(
            context,
            name: "Michael Chen",
            category: "Rama",
            status: "Memproses Pembayaran",
            imageUrl: "https://i.pravatar.cc/150?u=michael",
          ),
          _buildOrderItem(
            context,
            name: "Elena Rodriguez",
            category: "Shinta",
            status: "Menunggu Pelunasan",
            imageUrl: "https://i.pravatar.cc/150?u=elena",
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(
    BuildContext context, {
    required String name,
    required String category,
    required String status,
    required String imageUrl,
    bool isUrgent = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white.withOpacity(0.9), // Lebih cerah agar teks terbaca
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 50,
            height: 50,
            color: Colors.grey.shade300,
            child: imageUrl.isEmpty
                ? const Icon(Icons.person, color: Colors.grey)
                : Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, color: Colors.grey),
                  ),
          ),
        ),
        title: Row(
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (isUrgent) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "PENTING",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: const TextStyle(color: Colors.blueGrey, fontSize: 13),
            ),
            Text(
              status,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black,
              ),
            ),
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
        },
      ),
    );
  }
}
