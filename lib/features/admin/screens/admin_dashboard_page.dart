import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/colors.dart';
import '../widgets/stat_card.dart';
import '../widgets/income_chart.dart';
import '../stock_management/category_selection_page.dart';
import 'rent_management_page.dart';
import 'reports.dart';
import '../../auth/widgets/auth_background.dart';
import 'notification_page.dart';
import '../../../data/services/dashboard_service.dart';
import '../../auth/screens/auth_selection_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0;
  final GlobalKey<_DashboardContentState> _dashboardKey = GlobalKey();

  late final List<Widget> _pages = [
    DashboardContent(key: _dashboardKey),
    const ManajemenPesananScreen(),
    const CategorySelectionPage(),
    const ReportScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      _dashboardKey.currentState?.fetchDashboardData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      body: IndexedStack(index: _selectedIndex, children: _pages),
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
            label: 'Laporan',
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
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
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
    int incomeToday =
        double.tryParse(_stats?['income_today']?.toString() ?? '0')?.toInt() ??
        0;
    int incomeMonthly =
        double.tryParse(
          _stats?['income_monthly']?.toString() ?? '0',
        )?.toInt() ??
        0;
    int rentedCount =
        int.tryParse(_stats?['rented_count']?.toString() ?? '0') ?? 0;

    return Column(
      children: [
        // 1. Header
        Container(
          padding: const EdgeInsets.only(
            top: 50,
            left: 20,
            right: 15,
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
              Row(
                children: [
                  // 🔻 PERBAIKAN: Fitur Dot Merah pada Notifikasi 🔻
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationPage(),
                            ),
                          ).then((_) {
                            // Refresh dashboard saat kembali agar dot merah otomatis hilang jika sudah dibaca
                            fetchDashboardData();
                          });
                        },
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: AppColors.primaryGold,
                          size: 26,
                        ),
                      ),

                      if ((int.tryParse(
                                _stats?['unread_notif']?.toString() ?? '0',
                              ) ??
                              0) >
                          0)
                        Positioned(
                          right: 12,
                          top: 12,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primaryNavy,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Konfirmasi Logout"),
                          content: const Text(
                            "Apakah Anda yakin ingin keluar dari halaman Admin?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Batal"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.clear();
                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const AuthSelectionPage(),
                                    ),
                                    (route) => false,
                                  );
                                }
                              },
                              child: const Text(
                                "Logout",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.redAccent,
                      size: 26,
                    ),
                  ),
                ],
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
                    onRefresh: fetchDashboardData,
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
                                  value: 'Rp $incomeToday',
                                  percentage: 'Live',
                                  isIncrease: true,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: StatCard(
                                  title: 'Pendapatan Bulanan',
                                  value: 'Rp $incomeMonthly',
                                  percentage: '+5%',
                                  isIncrease: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          StatCard(
                            title: 'Jumlah Kostum Sedang Disewa',
                            value: '$rentedCount Unit',
                            percentage: 'Aktif',
                            isIncrease: rentedCount > 0,
                          ),
                          const SizedBox(height: 20),
                          IncomeChart(chartData: _stats?['chart_data'] ?? []),
                          const SizedBox(height: 30),

                          const Text(
                            'Sering Disewa',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 15),
                          if (_stats?['top_costumes'] != null &&
                              (_stats!['top_costumes'] as List).isNotEmpty)
                            ...(_stats!['top_costumes'] as List).map((item) {
                              return _buildPopularItem(
                                item['nama_kostum']?.toString() ?? 'Unknown',
                                item['kategori']?.toString() ?? 'Kategori',
                                '${item['total_disewa']} Disewa',
                                true,
                                item['foto_kostum']?.toString() ?? '',
                              );
                            }).toList()
                          else
                            const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Center(
                                child: Text(
                                  "Belum ada data penyewaan",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
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
    String foto,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: foto.isNotEmpty
                ? Image.network(
                    "${DashboardService.baseUrl}/uploads/$foto",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  )
                : Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image, color: Colors.grey),
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
