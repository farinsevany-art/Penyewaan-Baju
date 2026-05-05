import 'package:flutter/material.dart';

// Catatan: Jika kamu punya model data pesanan nantinya, import di sini.
// Contoh: import '../../../data/models/order_model.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  // Simulasi status dari database (nanti ini dihubungkan dengan backend/admin)
  // 0: Menunggu Deposit, 1: Diproses, 2: Aktif, 3: Selesai, 4: Batal
  int currentStatusIndex = 1; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(
            fontFamily: 'Poppins', 
            fontWeight: FontWeight.bold, 
            fontSize: 18, 
            color: Color(0xFF0D1B3E)
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false, // Menghilangkan tombol back jika ini tab navigator
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Status Pesanan",
              style: TextStyle(
                fontFamily: 'PlayfairDisplay', 
                fontSize: 24, 
                fontWeight: FontWeight.bold, 
                color: Color(0xFF0D1B3E)
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Pantau tahapan penyewaan kostum kamu",
              style: TextStyle(
                fontFamily: 'Poppins', 
                fontSize: 14, 
                color: Color(0xFFE4B04B)
              ),
            ),
            const SizedBox(height: 25),
            
            // Kartu Pesanan
            _buildOrderCard(
              context,
              costumeName: "Kostum Tari Legong Bali",
              orderId: "KC-2024-001",
              date: "12 Mei 2024",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context, {
    required String costumeName,
    required String orderId,
    required String date,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          // Header Kartu
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4B04B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFFE4B04B)),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      costumeName,
                      style: const TextStyle(
                        fontFamily: 'Poppins', 
                        fontWeight: FontWeight.bold, 
                        fontSize: 15
                      ),
                    ),
                    Text(
                      "$orderId • $date",
                      style: const TextStyle(
                        fontFamily: 'Poppins', 
                        color: Colors.grey, 
                        fontSize: 11
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(thickness: 1, height: 1),
          ),

          // LIST STATUS (Sesuai urutan gambar Admin yang kamu kirim)
          _statusStep("Menunggu Deposit", "Awaiting Deposit", Icons.account_balance_wallet_outlined, 0),
          _statusStep("Diproses", "Processing", Icons.sync, 1),
          _statusStep("Aktif/Disewa", "Active/Rented", Icons.check_circle_outline, 2),
          _statusStep("Selesai/Kembali", "Completed/Returned", Icons.assignment_returned_outlined, 3),
          _statusStep("Dibatalkan", "Cancelled", Icons.cancel_outlined, 4),
        ],
      ),
    );
  }

  Widget _statusStep(String title, String subtitle, IconData icon, int index) {
    // Logika warna: jika index ini sama dengan currentStatusIndex, maka aktif (kuning)
    bool isActive = currentStatusIndex == index;
    // Logika warna: jika index sudah lewat (sudah selesai), bisa diberi warna hijau atau tetap abu
    bool isPast = currentStatusIndex > index && currentStatusIndex != 4; 

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : const Color(0xFFF2F2F7).withOpacity(0.5),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isActive ? const Color(0xFFE4B04B) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Icon Radio (Sesuai Gambar)
            Icon(
              isActive ? Icons.radio_button_checked : (isPast ? Icons.check_circle : Icons.radio_button_off),
              color: isActive ? const Color(0xFFE4B04B) : (isPast ? Colors.green : Colors.grey[400]),
              size: 22,
            ),
            const SizedBox(width: 15),
            // Teks Status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                      color: isActive ? Colors.black : Colors.grey[600],
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Poppins', 
                      fontSize: 11, 
                      color: Colors.grey[400]
                    ),
                  ),
                ],
              ),
            ),
            // Icon Kanan (Sesuai Gambar)
            Icon(
              icon,
              color: isActive ? const Color(0xFFE4B04B) : Colors.grey[300],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}