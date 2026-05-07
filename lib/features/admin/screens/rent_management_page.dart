import 'package:flutter/material.dart';
import '../../auth/widgets/auth_background.dart';
import '../../../core/constants/colors.dart';
import 'rent_details_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// --- MODEL DATA ---
class PesananData {
  final String id; // Tambahkan ini
  final String name;
  final String category;
  final String status;
  final String imageUrl;
  final bool isUrgent;

  PesananData({
    required this.id, // Tambahkan ini
    required this.name,
    required this.category,
    required this.status,
    required this.imageUrl,
    this.isUrgent = false,
  });

  // Fungsi untuk konversi dari JSON database PHP
  factory PesananData.fromJson(Map<String, dynamic> json) {
    return PesananData(
      id: json['id_penyewaan'].toString(),
      name: json['nama'] ?? '',
      category: '', // Mengosongkan default karena data join difokuskan ke nama & status
      imageUrl: '',
      status: json['status_penyewaan'] ?? "Baru", 
    );
  }
}

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

List<PesananData> _allOrders = [];
bool _isLoading = true;

  @override
void initState() {
  super.initState();
  _tabController = TabController(length: 3, vsync: this);
  _fetchOrders(); // Panggil fungsi ambil data database di sini
}
  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // FUNGSI BARU: Ambil data dari database melalui API PHP
Future<void> _fetchOrders() async {
  try {
    // Catatan: Jika pakai emulator Android, ganti localhost menjadi 10.0.2.2
    final response = await http.get(Uri.parse('http://localhost/api_penyewaan/get_orders.php'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        _allOrders = jsonResponse.map((data) => PesananData.fromJson(data)).toList();
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  } catch (e) {
    print("Error koneksi database: $e");
    setState(() => _isLoading = false);
  }
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => setState(() {
                  _isSearching = false;
                  _searchController.clear();
                  _searchText = "";
                }),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  'assets/images/Logotransparan.png',
                  fit: BoxFit.contain,
                ),
              ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Cari pelanggan...",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (val) => setState(() => _searchText = val),
              )
            : Text(
                'Manajemen Pesanan',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primaryGold),
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () => setState(() {
              if (_isSearching) {
                _searchController.clear();
                _searchText = "";
              }
              _isSearching = !_isSearching;
            }),
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : AuthBackground(
              child: Column(
                children: [
                  Container(
                    color: AppColors.primaryNavy,
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.primaryGold,
                      indicatorWeight: 3,
                      labelColor: AppColors.primaryGold,
                      unselectedLabelColor: Colors.white60,
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

  // MODIFIKASI DISINI: Bungkus dengan RefreshIndicator
  return RefreshIndicator(
    onRefresh: _fetchOrders, // Jalankan fungsi ambil data ulang saat di-refresh
    child: ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filteredList.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _buildHeader(filteredList.length, statusTab);
        final item = filteredList[index - 1];
        return _buildOrderItem(item);
      },
    ),
  );
}

  Widget _buildHeader(int count, String statusTab) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Text(
            statusTab == "Baru" ? "Pesanan Terbaru" : "Daftar Pesanan",
            style: const TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryNavy,
            ),
          ),
          const SizedBox(width: 12),
          if (statusTab == "Baru")
            _badge(Colors.blue, "$count Menunggu")
          else
            _badge(AppColors.primaryGold, "$count Total"),
        ],
      ),
    );
  }

  Widget _badge(Color color, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildOrderItem(PesananData item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.offWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.person_outline, color: AppColors.primaryNavy),
        ),
        title: Text(
          item.name,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: AppColors.primaryNavy,
          ),
        ),
        subtitle: Text(
          item.status == "Baru" ? "Menunggu Disetujui" : item.status,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.primaryGold,
        ),
        onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RentDetailsPage(orderId: item.id),
            ),
          );
        },
      ),
    );
  }
}// Penutup class _ManajemenPesananScreenState yang tadinya hilang