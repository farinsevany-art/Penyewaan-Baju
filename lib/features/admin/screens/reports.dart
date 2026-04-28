import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  // Helper untuk dekorasi kartu agar seragam
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.orange.shade100),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Karena ini akan dimasukkan ke dalam body AdminDashboardPage, 
    // kita tidak perlu Scaffold lagi di sini.
    return SingleChildScrollView(
      child: Column(
        children: [
          // 1. Header Section
          _buildHeader(),

          // 2. Tab Switcher
          _buildTabSwitcher(),

          // 3. Main Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildPerformanceCard(),
                const SizedBox(height: 16),
                _buildRevenueChartCard(),
                const SizedBox(height: 16),
                _buildPopularSection(),
                const SizedBox(height: 100), // Memberi ruang agar tidak tertutup BottomNav
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 40, left: 24, right: 24),
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF10214F)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.person, color: Color(0xFF10214F)),
            ),
          ),
          const Text(
            'Laporan',
            style: TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade100),
          ),
          child: Row(
            children: [
              _buildTabItem("Hari", false),
              _buildTabItem("Bulan", true),
              _buildTabItem("Tahun", false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, bool isActive) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEFE9DB) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Ringkasan Kinerja",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
              Icon(Icons.insights, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem("PENDAPATAN", "Rp8.400.000"),
              _buildStatItem("PELANGGAN", "246"),
              _buildStatItem("PENGEMBALIAN", "94%"),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download, size: 18),
            label: const Text("Unduh Laporan PDF"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildRevenueChartCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Pendapatan dari Waktu ke Waktu",
              style: TextStyle(color: Colors.grey, fontSize: 13)),
          const Row(
            children: [
              Text("Rp84.000.000",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Icon(Icons.trending_up, color: Colors.green, size: 16),
              Text("12.5%",
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: CustomPaint(painter: ChartPainter()),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Minggu 1", style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text("Minggu 2", style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text("Minggu 3", style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text("Minggu 4", style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPopularSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Sering Disewa", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          decoration: _cardDecoration(),
          child: Column(
            children: [
              _buildListItem(
                  "Srikandi", "12 Disewa", "Rp4.500.000", Icons.theater_comedy),
              const Divider(height: 1, indent: 20, endIndent: 20),
              _buildListItem(
                  "Shinta", "8 Disewa", "Rp3.700.000", Icons.auto_fix_high),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(
      String title, String subtitle, String price, IconData icon) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: Colors.blue.shade800),
      ),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: Text("+$price",
          style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

// Painter untuk grafik
class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.blue.shade100, Colors.white],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
        size.width * 0.25, size.height * 0.2, size.width * 0.5, size.height * 0.6);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.9, size.width, size.height * 0.3);

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}