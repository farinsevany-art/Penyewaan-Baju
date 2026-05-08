import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/order_service.dart';
import 'rent_details_page.dart';

class ManajemenPesananScreen extends StatefulWidget {
  const ManajemenPesananScreen({super.key});

  @override
  State<ManajemenPesananScreen> createState() =>
      _ManajemenPesananScreenState();
}

class _ManajemenPesananScreenState
    extends State<ManajemenPesananScreen>

    with SingleTickerProviderStateMixin {
  List<dynamic> _allOrders = [];
  bool _isLoading = true;
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
String _searchQuery = ""; // Untuk menyimpan teks yang diketik
bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);

    final data = await OrderService.getOrders();

    if (mounted) {
      setState(() {
        _allOrders = data;
        _isLoading = false;
      });
    }
  }

List<dynamic> _filterOrders(String type) {
  // 1. Filter berdasarkan status (Logika yang sudah kita perbaiki sebelumnya)
  List<dynamic> filteredByStatus = _allOrders.where((o) {
    String s = o['status_penyewaan'] ?? "";
    if (type == 'Baru') {
      return s.contains('Menunggu') || s.contains('Diproses');
    } else if (type == 'Aktif') {
      return s.contains('Disewa') || s.contains('Aktif');
    } else {
      return s.contains('Selesai') || s.contains('Batal') || s.contains('Kembali');
    }
  }).toList();

  // 2. Filter berdasarkan Search Query (Nama Pelanggan atau Item)
  if (_searchQuery.isEmpty) {
    return filteredByStatus;
  } else {
    return filteredByStatus.where((o) {
      String customerName = (o['nama_pelanggan'] ?? "").toString().toLowerCase();
      String items = (o['items_summary'] ?? "").toString().toLowerCase();
      String query = _searchQuery.toLowerCase();
      
      return customerName.contains(query) || items.contains(query);
    }).toList();
  }
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text("Manajemen Pesanan"),

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: AppColors.primaryGold,
            ),
          ),
        ],

        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryGold,
          indicatorWeight: 3,
          labelColor: AppColors.primaryGold,
          unselectedLabelColor: Colors.white70,
          labelStyle: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.primaryGold,
          ),
          tabs: const [
            Tab(text: "Baru"),
            Tab(text: "Aktif"),
            Tab(text: "Selesai"),
          ],
        ),
      ),

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryGold,
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList('Baru'),
                _buildOrderList('Aktif'),
                _buildOrderList('Selesai'),
              ],
            ),
    );
  }

Widget _buildOrderList(String type) {
    final theme = Theme.of(context);
    final orders = _filterOrders(type);

    if (orders.isEmpty) {
      return Center(
        child: Text(
          "Tidak ada pesanan.",
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];

        // 1. Logika pemrosesan String (Costume Name)
        String itemsRaw = order['items_summary'] ?? "";
        String costumeName = itemsRaw.isNotEmpty
            ? itemsRaw.split(',').first.split('x ').last
            : "Tanpa Item";

        // 2. Return widget tunggal
        return GestureDetector(
          onTap: () async {
            // Berpindah ke halaman detail dan menunggu hasil (result)
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RentDetailsPage(
                  orderId: order['id_penyewaan'].toString(),
                ),
              ),
            );

            // Jika kembali dari detail membawa nilai true, segarkan list
            if (result == true) {
              _fetchOrders();
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primaryGold.withOpacity(0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Icon Avatar
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.primaryNavy.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 38,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Informasi Pesanan
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['nama'] ?? "Pelanggan #${order['id_pelanggan']}",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.primaryNavy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          costumeName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.mediumGrey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildStatusBadge(
                          order['status_penyewaan'] ?? '-',
                        ),
                      ],
                    ),
                  ),
                  // Indikator Penting & Chevron
                  Column(
                    children: [
                      if (order['status_penyewaan'] == 'Menunggu Deposit')
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGold.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "PENTING",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: const Color(0xFF9A6B00),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.mediumGrey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditStatusDialog(Map<String, dynamic> order) {
    final theme = Theme.of(context);

    String currentStatus =
        order['status_penyewaan'] ?? 'Menunggu Deposit';

    final List<String> statusOptions = [
      'Menunggu Deposit',
      'Diproses',
      'Sedang Disewa',
      'Selesai',
      'Dibatalkan',
    ];

    String selectedStatus = currentStatus;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              title: Text(
                "Ubah Status #${order['id_penyewaan']}",
                style: theme.textTheme.titleLarge,
              ),

              content: DropdownButtonFormField<String>(
                value: selectedStatus,
                isExpanded: true,

                decoration: InputDecoration(
                  filled: true,
                  fillColor:
                      AppColors.primaryNavy.withOpacity(0.04),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),

                items: statusOptions.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),

                onChanged: (value) {
                  setStateDialog(() {
                    selectedStatus = value!;
                  });
                },
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: const Text(
                    "Batal",
                    style: TextStyle(
                      color: AppColors.mediumGrey,
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);

                    bool success =
                        await OrderService.updateOrderStatus(
                      int.parse(
                        order['id_penyewaan'].toString(),
                      ),
                      selectedStatus,
                    );

                    if (success) {
                      setState(() {
                        order['status_penyewaan'] =
                            selectedStatus;
                      });

                      if (mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            backgroundColor:
                                AppColors.primaryNavy,
                            content: Text(
                              "Status berhasil diperbarui!",
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              "Gagal memperbarui status.",
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }
                    }
                  },

                  child: const Text("Simpan"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor = Colors.grey.shade200;
    Color textColor = Colors.black;

    if (status.contains('Menunggu')) {
      bgColor = Colors.orange.shade100;
      textColor = Colors.orange.shade800;
    } else if (status.contains('Diproses')) {
      bgColor = Colors.blue.shade100;
      textColor = Colors.blue.shade800;
    } else if (status.contains('Disewa')) {
      bgColor = Colors.green.shade100;
      textColor = Colors.green.shade800;
    } else if (status.contains('Selesai')) {
      bgColor = Colors.teal.shade100;
      textColor = Colors.teal.shade800;
    } else if (status.contains('Batal')) {
      bgColor = Colors.red.shade100;
      textColor = Colors.red.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
      ),

      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}