import 'package:flutter/material.dart';
import 'rent_details_page.dart'; 
import 'rent_details_page.dart';
import '../../auth/widgets/auth_background.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/app_theme.dart';


void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, 
      home: const ManajemenPesananScreen(),
    ),
  );
}

// --- MODEL DATA ---
class PesananData {
  final String name;
  final String category;
  final String status;
  final String imageUrl;
  final bool isUrgent;

  PesananData({
    required this.name,
    required this.category,
    required this.status,
    required this.imageUrl,
    this.isUrgent = false,
  });
}

// --- SCREEN UTAMA ---
class ManajemenPesananScreen extends StatefulWidget {
  const ManajemenPesananScreen({super.key});

  @override
  State<ManajemenPesananScreen> createState() => _ManajemenPesananScreenState();
}

class _ManajemenPesananScreenState extends State<ManajemenPesananScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  bool _isSearching = false;

  final List<PesananData> _allOrders = [
    PesananData(name: "Sarah Jenkins", category: "Clara 1", status: "Baru", imageUrl: "", isUrgent: true),
    PesananData(name: "Michael Chen", category: "Rama", status: "Baru", imageUrl: "https://i.pravatar.cc/150?u=michael"),
    PesananData(name: "Elena Rodriguez", category: "Shinta", status: "Baru", imageUrl: "https://i.pravatar.cc/150?u=elena"),
    PesananData(name: "Andi Wijaya", category: "Laksamana", status: "Aktif", imageUrl: ""),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor, 
        elevation: 0,
        leading: _isSearching 
          ? IconButton(
              // Hapus const karena AppColors.pureWhite nilainya dinamis dari luar
              icon: Icon(Icons.arrow_back, color: AppColors.pureWhite),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
              },
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset('assets/images/Logotransparan.png', fit: BoxFit.contain),
            ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(color: AppColors.pureWhite), // Hapus const
                decoration: const InputDecoration(
                  hintText: "Cari pelanggan...",
                  hintStyle: TextStyle(color: AppColors.lightGrey),
                  border: InputBorder.none,
                ),
              )
            : Text(
                'Manajemen Pesanan',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.pureWhite, // Hapus const
                  fontSize: 18,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: AppColors.pureWhite), // Hapus const
            onPressed: () {
              setState(() {
                if (_isSearching) _searchController.clear();
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryGold,
          indicatorWeight: 3,
          labelColor: AppColors.lightGold,
          unselectedLabelColor: AppColors.lightGrey,
          tabs: const [
            Tab(text: "Baru"),
            Tab(text: "Aktif"),
            Tab(text: "Selesai"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFilteredPesananList("Baru"),
          _buildFilteredPesananList("Aktif"),
          _buildFilteredPesananList("Selesai"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primaryGold, 
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: AppColors.primaryNavy, size: 30), // Hapus const
      ),
    );
  }

  Widget _buildFilteredPesananList(String statusTab) {
    final filteredList = _allOrders.where((p) {
      final matchStatus = p.status == statusTab;
      final matchSearch = p.name.toLowerCase().contains(_searchText.toLowerCase()) ||
                          p.category.toLowerCase().contains(_searchText.toLowerCase());
      return matchStatus && matchSearch;
    }).toList();

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://www.toptal.com/designers/subtlepatterns/patterns/floral-felt.png'),
          opacity: 0.05,
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return _buildHeader(filteredList.length);
          
          final item = filteredList[index - 1];
          return _buildOrderItem(
            context,
            name: item.name,
            category: item.category,
            status: item.status == "Baru" ? "Menunggu Disetujui" : item.status,
            imageUrl: item.imageUrl,
            isUrgent: item.isUrgent,
          );
        },
      ),
    );
  }

  Widget _buildHeader(int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Hasil Pesanan", 
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.lightGold.withOpacity(0.3), 
              borderRadius: BorderRadius.circular(20)
            ),
            child: Text(
              "$count Total", 
              style: const TextStyle(fontSize: 12, color: AppColors.primaryGold, fontWeight: FontWeight.bold)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, {
    required String name, 
    required String category, 
    required String status, 
    required String imageUrl, 
    bool isUrgent = false
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: AppColors.pureWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 50, height: 50, color: AppColors.lightGrey,
            child: imageUrl.isEmpty
                ? const Icon(Icons.person, color: AppColors.mediumGrey)
                : Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image)),
          ),
        ),
        title: Row(
          children: [
            Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkGrey)), // Hapus const
            if (isUrgent) ...[
              const SizedBox(width: 8),
              _urgentBadge(),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category, style: TextStyle(color: AppColors.mediumGrey, fontSize: 13)), // Hapus const
            Text(status, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.secondaryNavy)), // Hapus const
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: AppColors.primaryGold), // Hapus const
        onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        // Pastikan nama class di rent_details_page.dart adalah DetailPenyewaanScreen
        builder: (context) => const DetailPenyewaanScreen(), 
      ),
    );
  },
      ),
    );
  }

  Widget _urgentBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(4)),
      child: const Text("PENTING", style: TextStyle(color: Colors.red, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }
}