import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../widgets/stat_card.dart';
import '../widgets/income_chart.dart';
import 'stock_management_page.dart';
import 'rent_management_page.dart'; 

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan berdasarkan index navigasi
  final List<Widget> _pages = [
    const DashboardContent(), // Index 0: Konten Utama Dashboard
    const ManajemenPesananScreen(), // Index 1: Placeholder
    const StockManagementPage(), // Index 2: Halaman Manajemen Stok
    const Center(child: Text("Halaman Reports")), // Index 3: Placeholder
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body:
          _pages[_selectedIndex], // Menampilkan halaman sesuai index yang dipilih
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryNavy,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Penyewaan',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Stok'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
        ],
      ),
    );
  }
}

// Widget terpisah untuk isi konten Dashboard agar kode tidak menumpuk
class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Navy
        Container(
          padding: const EdgeInsets.only(
            top: 50,
            left: 20,
            right: 20,
            bottom: 20,
          ),
          color: AppColors.primaryNavy,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset('assets/images/Logotransparan.png', width: 40),
                  const SizedBox(width: 12),
                  const Text(
                    'Dashboard Penyewaan',
                    style: TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.notifications_active,
                color: AppColors.primaryGold,
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row Statistik Atas
                const Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Total Pendapatan Hari Ini',
                        value: 'Rp450.000',
                        percentage: '+12%',
                        isIncrease: true,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: StatCard(
                        title: 'Pendapatan Bulanan',
                        value: 'Rp12.400.000',
                        percentage: '+5%',
                        isIncrease: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // Card Jumlah Kostum
                const StatCard(
                  title: 'Jumlah Kostum Disewa',
                  value: '84',
                  percentage: '-2%',
                  isIncrease: false,
                ),

                const SizedBox(height: 20),
                const IncomeChart(),

                const SizedBox(height: 30),
                const Text(
                  'Kostum Dengan Penyewaan Terbanyak',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 15),

                _buildPopularItem(
                  'Tari Kreasi Baru',
                  'Tari Anak',
                  '24 Disewa',
                  true,
                ),
                _buildPopularItem('Clara 1', 'Tari Dewasa', '18 Disewa', false),
                _buildPopularItem('Anoman', 'Wayang', '15 Disewa', true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopularItem(
    String name,
    String cat,
    String count,
    bool isPopuler,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  cat,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(count, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (isPopuler)
                const Text(
                  '↑ Populer',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else
                const Text(
                  'Stabil',
                  style: TextStyle(color: Colors.blue, fontSize: 10),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
