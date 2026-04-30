import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../auth/widgets/auth_background.dart';

// --- Note: Gunakan Theme.of(context).textTheme untuk konsistensi font ---

class ManajemenPesananScreen extends StatefulWidget {
  const ManajemenPesananScreen({super.key});

  @override
  State<ManajemenPesananScreen> createState() => _ManajemenPesananScreenState();
}

class _ManajemenPesananScreenState extends State<ManajemenPesananScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  bool _isSearching = false;

  // Data dummy (Sama seperti sebelumnya)
  final List<PesananData> _allOrders = [
    PesananData(
      name: "Sarah Jenkins",
      category: "Clara 1",
      status: "Baru",
      imageUrl: "",
      isUrgent: true,
    ),
    PesananData(
      name: "Michael Chen",
      category: "Rama",
      status: "Baru",
      imageUrl: "",
    ),
    PesananData(
      name: "Elena Rodriguez",
      category: "Shinta",
      status: "Baru",
      imageUrl: "",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Agar background terlihat
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _isSearching = false),
              )
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'assets/images/Logotransparan.png',
                  fit: BoxFit.contain,
                ),
              ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
                decoration: const InputDecoration(
                  hintText: "Cari pelanggan...",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (val) => setState(() => _searchText = val),
              )
            : Text(
                'Manajemen Pesanan',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primaryGold,
                  // Playfair Display otomatis dari AppTheme.titleLarge
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () => setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) _searchController.clear();
            }),
          ),
        ],
      ),
      body: AuthBackground(
        child: Column(
          children: [
            // TabBar styling
            Container(
              color: AppColors.primaryNavy,
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primaryGold,
                indicatorWeight: 3,
                labelColor: AppColors.primaryGold,
                unselectedLabelColor: Colors.white60,
                labelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: "Baru"),
                  Tab(text: "Aktif"),
                  Tab(text: "Selesai"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFilteredPesananList("Baru"),
                  _buildFilteredPesananList("Aktif"),
                  _buildFilteredPesananList("Selesai"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilteredPesananList(String statusTab) {
    final filteredList = _allOrders.where((p) {
      return p.status == statusTab &&
          p.name.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filteredList.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _buildHeader(filteredList.length);
        final item = filteredList[index - 1];
        return _buildOrderItem(item);
      },
    );
  }

  Widget _buildHeader(int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Text(
            "Pesanan Terbaru",
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryNavy,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Text(
              "$count Menunggu",
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(PesananData item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: AppColors.offWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryGold.withOpacity(0.3)),
          ),
          child: const Icon(Icons.person_outline, color: AppColors.primaryNavy),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                item.name,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primaryNavy,
                ),
              ),
            ),
            if (item.isUrgent)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  "PENTING",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.orange,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              item.category,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.status == "Baru" ? "Menunggu Disetujui" : item.status,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.primaryGold,
        ),
        onTap: () {},
      ),
    );
  }
}

// Model Class sederhana
class PesananData {
  final String name, category, status, imageUrl;
  final bool isUrgent;
  PesananData({
    required this.name,
    required this.category,
    required this.status,
    required this.imageUrl,
    this.isUrgent = false,
  });
}
