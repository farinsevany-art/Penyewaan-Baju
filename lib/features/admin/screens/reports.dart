import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/colors.dart';
import '../../auth/widgets/auth_background.dart';

// 1. PINDAHKAN MODEL DATA KE TOP-LEVEL
class RevenueData {
  final double x;
  final double y;

  RevenueData(this.x, this.y);
}

// 2. PINDAHKAN WIDGET GRAFIK KE TOP-LEVEL
class RevenueChart extends StatelessWidget {
  final List<RevenueData> chartData;
  const RevenueChart({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: chartData.map((e) => FlSpot(e.x, e.y)).toList(),
            isCurved: true,
            color: AppColors.primaryNavy,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primaryNavy.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String _selectedTab = "Bulan";

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.pureWhite,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.primaryGold.withOpacity(0.2)),
      boxShadow: [
        BoxShadow(
          color: AppColors.darkGrey.withOpacity(0.05),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF8F9FA),
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildTabSwitcher(),
                    const SizedBox(height: 24),
                    _buildPerformanceCard(),
                    const SizedBox(height: 16),
                    _buildRevenueChartCard(), // Fungsi ini sekarang sudah benar
                    const SizedBox(height: 16),
                    _buildPopularSection(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 32, bottom: 32, left: 24, right: 24),
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColors.primaryNavy),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryGold,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.primaryNavy,
                size: 20,
              ),
            ),
          ),
          const Text(
            'Laporan',
            style: TextStyle(
              color: AppColors.primaryGold,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGold.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTabItem("Hari"),
          _buildTabItem("Bulan"),
          _buildTabItem("Tahun"),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title) {
    bool isActive = _selectedTab == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.lightGold.withOpacity(0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? AppColors.primaryNavy : AppColors.mediumGrey,
            ),
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
              Text(
                "Ringkasan Kinerja",
                style: TextStyle(
                  color: AppColors.mediumGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(Icons.insights, size: 20, color: AppColors.primaryNavy),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                "PENDAPATAN",
                _selectedTab == "Hari" ? "Rp450.000" : "Rp8.400.000",
              ),
              _buildStatItem(
                "PELANGGAN",
                _selectedTab == "Hari" ? "12" : "246",
              ),
              _buildStatItem("PENGEMBALIAN", "94%"),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download, size: 18),
            label: const Text("Unduh Laporan PDF"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNavy,
              foregroundColor: AppColors.pureWhite,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.mediumGrey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryNavy,
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueChartCard() {
    // Simulasi data grafik
    List<RevenueData> currentData = _selectedTab == "Hari"
        ? [RevenueData(0, 10), RevenueData(1, 45), RevenueData(2, 30)]
        : [
            RevenueData(0, 20),
            RevenueData(1, 50),
            RevenueData(2, 40),
            RevenueData(3, 84),
          ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pendapatan ($_selectedTab)",
            style: const TextStyle(color: AppColors.mediumGrey, fontSize: 13),
          ),
          Row(
            children: [
              Text(
                _selectedTab == "Hari" ? "Rp450.000" : "Rp84.000.000",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.trending_up, color: Colors.green, size: 18),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 140,
            width: double.infinity,
            child: RevenueChart(chartData: currentData),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Sering Disewa",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.primaryNavy,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: _cardDecoration(),
          child: Column(
            children: [
              _buildListItem(
                "Srikandi",
                "12 Disewa",
                "Rp4.500.000",
                Icons.theater_comedy,
              ),
              _buildListItem(
                "Shinta",
                "8 Disewa",
                "Rp3.700.000",
                Icons.auto_fix_high,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(
    String title,
    String subtitle,
    String price,
    IconData icon,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.lightGold.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primaryGold),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: AppColors.primaryNavy,
        ),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: Text(
        "+$price",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }
}
