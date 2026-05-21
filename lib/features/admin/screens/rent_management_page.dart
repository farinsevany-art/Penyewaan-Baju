import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/order_service.dart';
import '../../auth/widgets/auth_background.dart';
import 'rent_details_page.dart';

class ManajemenPesananScreen extends StatefulWidget {
  const ManajemenPesananScreen({super.key});

  @override
  State<ManajemenPesananScreen> createState() => _ManajemenPesananScreenState();
}

class _ManajemenPesananScreenState extends State<ManajemenPesananScreen>
    with SingleTickerProviderStateMixin {
  List<dynamic> _allOrders = [];
  bool _isLoading = true;
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  bool _isSearching = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchOrders(showLoading: true);

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _fetchOrders(showLoading: false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchOrders({bool showLoading = false}) async {
    if (showLoading && mounted) setState(() => _isLoading = true);

    final data = await OrderService.getOrders();

    if (mounted) {
      setState(() {
        _allOrders = data;
        if (showLoading) _isLoading = false;
      });
    }
  }

  List<dynamic> _filterOrders(String type) {
    List<dynamic> filteredByStatus = _allOrders.where((o) {
      String s = o['status_penyewaan'] ?? "";

      if (type == 'Baru') {
        return s.contains('Menunggu') || s.contains('Diproses');
      } else if (type == 'Aktif') {
        return s.contains('Disewa') || s.contains('Aktif');
      } else {
        return s.contains('Selesai') ||
            s.contains('Batal') ||
            s.contains('Kembali');
      }
    }).toList();

    if (_searchQuery.isEmpty) return filteredByStatus;

    return filteredByStatus.where((o) {
      String customerName = (o['nama_pelanggan'] ?? "")
          .toString()
          .toLowerCase();

      String items = (o['items_summary'] ?? "").toString().toLowerCase();

      String query = _searchQuery.toLowerCase();

      return customerName.contains(query) || items.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.primaryNavy,

      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset(
            'assets/images/Logotransparan.png',
            fit: BoxFit.contain,
          ),
        ),

        leadingWidth: 48,

        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Cari nama atau pesanan...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              )
            : Text(
                "Manajemen Pesanan",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.primaryGold,
                ),
              ),

        backgroundColor: AppColors.primaryNavy,
        foregroundColor: AppColors.primaryGold,
        elevation: 0,

        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  _searchQuery = "";
                } else {
                  _isSearching = true;
                }
              });
            },
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
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
          tabs: const [
            Tab(text: "Baru"),
            Tab(text: "Aktif"),
            Tab(text: "Selesai"),
          ],
        ),
      ),

      body: AuthBackground(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGold),
              )
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildOrderList('Baru'),
                  _buildOrderList('Aktif'),
                  _buildOrderList('Selesai'),
                ],
              ),
      ),
    );
  }

  Widget _buildOrderList(String type) {
    final theme = Theme.of(context);
    final orders = _filterOrders(type);

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 80, color: Colors.white24),

            const SizedBox(height: 16),

            Text(
              "Tidak ada pesanan $type.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _fetchOrders(showLoading: true),
      color: AppColors.primaryGold,

      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,

        itemBuilder: (context, index) {
          final order = orders[index];

          String itemsRaw = order['items_summary'] ?? "";

          String costumeName = itemsRaw.isNotEmpty
              ? itemsRaw.split(',').first.split('x ').first
              : "Tanpa Item";

          String customerName =
              order['nama_pelanggan']?.toString() ??
              "Pelanggan #${order['id_pelanggan']}";

          String customerPhoto = order['foto_pelanggan']?.toString() ?? "";

          return GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RentDetailsPage(
                    orderId: order['id_penyewaan'].toString(),
                  ),
                ),
              );

              if (result == true) {
                _fetchOrders(showLoading: true);
              }
            },

            child: Container(
              margin: const EdgeInsets.only(bottom: 16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),

                border: Border.all(color: AppColors.primaryGold, width: 1.2),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Padding(
                padding: const EdgeInsets.all(14),

                child: Row(
                  children: [
                    Container(
                      width: 65,
                      height: 65,

                      decoration: BoxDecoration(
                        color: AppColors.primaryNavy.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),

                        image: customerPhoto.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(
                                  "${OrderService.baseUrl}/uploads/profiles/$customerPhoto",
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),

                      child: customerPhoto.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 35,
                              color: AppColors.primaryNavy,
                            )
                          : null,
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            customerName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.primaryNavy,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 6),

                          Text(
                            costumeName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.mediumGrey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 10),

                          _buildStatusBadge(order['status_penyewaan'] ?? '-'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

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
