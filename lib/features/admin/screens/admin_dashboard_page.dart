import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../widgets/stat_card.dart';
import '../widgets/income_chart.dart';
// Import CategorySelectionPage untuk memperbaiki error alur stok
import '../stock_management/category_selection_page.dart';
import 'rent_management_page.dart';
import 'reports.dart';
import '../../auth/widgets/auth_background.dart';
import 'notification_page.dart';
import '../../../data/services/dashboard_service.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0;

  // DAFTAR HALAMAN UTAMA
  final List<Widget> _pages = [
    const DashboardContent(),
    const ManajemenPesananScreen(),
    // PERBAIKAN: Diarahkan ke CategorySelectionPage agar user memilih kategori dulu
    const CategorySelectionPage(),
    const ReportScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      body: IndexedStack(
        // Menggunakan IndexedStack agar state halaman tetap terjaga
        index: _selectedIndex,
        children: _pages,
      ),
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

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  Map<String, dynamic>? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final data = await DashboardService.getDashboardStats();
      if (!mounted) return;
      setState(() {
        _stats = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memperbarui data: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Header
        Container(
          padding: const EdgeInsets.only(
            top: 50, // Disesuaikan untuk notch
            left: 20,
            right: 20,
            bottom: 25,
          ),
          color: AppColors.primaryNavy,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/Logotransparan.png',
                    width: 40,
                    errorBuilder: (c, e, s) =>
                        const Icon(Icons.store, color: AppColors.primaryGold),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Dashboard Admin',
                    style: TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: _fetchDashboardData,
                icon: const Icon(Icons.refresh, color: AppColors.primaryGold),
              ),
            ],
          ),
        ),

        // 2. Konten Utama
        Expanded(
          child: AuthBackground(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryNavy,
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchDashboardData,
                    color: AppColors.primaryNavy,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: StatCard(
                                  title: 'Pendapatan Hari Ini',
                                  value:
                                      'Rp ${_stats?['income_today']?.toInt() ?? 0}',
                                  percentage: 'Live',
                                  isIncrease: true,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: StatCard(
                                  title: 'Pendapatan Bulanan',
                                  value:
                                      'Rp ${_stats?['income_monthly']?.toInt() ?? 0}',
                                  percentage: '+5%',
                                  isIncrease: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          StatCard(
                            title: 'Jumlah Kostum Sedang Disewa',
                            value: '${_stats?['rented_count'] ?? 0} Unit',
                            percentage: 'Aktif',
                            isIncrease: (_stats?['rented_count'] ?? 0) > 0,
                          ),
                          const SizedBox(height: 20),
                          IncomeChart(chartData: _stats?['chart_data'] ?? []),
                          const SizedBox(height: 30),
                          const Text(
                            'Kostum Terpopuler',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 15),
                          _buildPopularItem(
                            'Tari Kreasi Baru',
                            'Tari Anak',
                            '24 Disewa',
                            true,
                          ),
                          _buildPopularItem(
                            'Clara 1',
                            'Tari Dewasa',
                            '18 Disewa',
                            false,
                          ),
                          _buildPopularItem(
                            'Anoman',
                            'Wayang',
                            '15 Disewa',
                            true,
                          ),
                        ],
                      ),
                    ),
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
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image, color: Colors.grey),
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
              Text(
                isPopuler ? '↑ Populer' : 'Stabil',
                style: TextStyle(
                  color: isPopuler ? Colors.green : Colors.blue,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
