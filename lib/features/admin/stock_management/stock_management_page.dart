import 'package:flutter/material.dart';
import 'package:apkpenyewaanbaju/data/models/stock_model.dart';
import 'package:apkpenyewaanbaju/data/services/stock_service.dart';
import 'package:apkpenyewaanbaju/core/constants/colors.dart';
import 'package:apkpenyewaanbaju/features/auth/widgets/auth_background.dart';
import 'add_stock_page.dart';
import 'edit_stock_page.dart';

class StockManagementPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const StockManagementPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<StockManagementPage> createState() => _StockManagementPageState();
}

class _StockManagementPageState extends State<StockManagementPage> {
  late Future<List<StockModel>> _stockFuture;
  String _selectedFilter = "Semua";

  // Variabel untuk fitur pencarian
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshData() {
    setState(() {
      _stockFuture = StockService.getStocks(widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: AppColors.pureWhite),
                decoration: const InputDecoration(
                  hintText: "Cari kostum...",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : Text(
                "Stok: ${widget.categoryName}",
                style: const TextStyle(
                  color: AppColors.primaryGold,
                  fontFamily: 'PlayfairDisplay',
                  fontWeight: FontWeight.bold,
                ),
              ),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: AppColors.primaryGold,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
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
          ),
        ],
      ),
      body: AuthBackground(
        child: Column(
          children: [
            _buildFilterRow(),
            Expanded(
              child: FutureBuilder<List<StockModel>>(
                future: _stockFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryGold,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Koneksi Gagal: ${snapshot.error}"),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Belum ada data stok."));
                  }

                  // 1. Filter berdasarkan ukuran (S, M, L, XL, Semua)
                  var filteredList = _selectedFilter == "Semua"
                      ? snapshot.data!
                      : snapshot.data!
                            .where((item) => item.ukuran == _selectedFilter)
                            .toList();

                  // 2. Filter tambahan berdasarkan pencarian nama kostum
                  if (_searchQuery.isNotEmpty) {
                    filteredList = filteredList
                        .where(
                          (item) => item.namaKostum.toLowerCase().contains(
                            _searchQuery.toLowerCase(),
                          ),
                        )
                        .toList();
                  }

                  if (filteredList.isEmpty) {
                    return const Center(child: Text("Kostum tidak ditemukan."));
                  }

                  return RefreshIndicator(
                    onRefresh: () async => _refreshData(),
                    color: AppColors.primaryGold,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) =>
                          _buildStockCard(filteredList[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryNavy,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddStockPage(categoryId: widget.categoryId),
          ),
        ).then((_) => _refreshData()), // Data otomatis refresh setelah tambah
        child: const Icon(Icons.add, color: AppColors.primaryGold),
      ),
    );
  }

  Widget _buildFilterRow() {
    final sizes = ["Semua", "S", "M", "L", "XL"];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: sizes.map((size) => _buildFilterBtn(size)).toList(),
        ),
      ),
    );
  }

  Widget _buildFilterBtn(String label) {
    bool isActive = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryGold
              : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isActive ? AppColors.primaryGold : Colors.grey.shade300,
          ),
          boxShadow: isActive
              ? [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.primaryNavy,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStockCard(StockModel item) {
    String hargaFormatted = item.hargaSewa >= 1000
        ? "${(item.hargaSewa / 1000).toStringAsFixed(0)}k"
        : item.hargaSewa.toString();

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            _buildIconPlaceholder(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.namaKostum,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildStockBadge(item.stok),
                ],
              ),
            ),
            _buildPriceAndActions(item, hargaFormatted),
          ],
        ),
      ),
    );
  }

  Widget _buildIconPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.inventory_2_outlined,
        color: AppColors.primaryNavy,
        size: 30,
      ),
    );
  }

  Widget _buildStockBadge(int stok) {
    return Row(
      children: [
        Text(
          "Stok: $stok",
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            "Tersedia",
            style: TextStyle(
              color: Colors.green,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAndActions(StockModel item, String hargaFormatted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "Rp $hargaFormatted",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.primaryNavy,
          ),
        ),
        Text(
          item.ukuran,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
              onPressed: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditStockPage(stock: item),
                    ),
                  ).then(
                    (_) => _refreshData(),
                  ), // Data otomatis refresh setelah edit
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 18, color: Colors.red),
              onPressed: () => _confirmDelete(item.idKostum!),
            ),
          ],
        ),
      ],
    );
  }

  void _confirmDelete(int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Data?"),
        content: const Text("Data kostum akan dihapus secara permanen."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              final res = await StockService.deleteStock(id);
              if (res['success']) {
                if (context.mounted) Navigator.pop(context);
                _refreshData();
              } else {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Gagal menghapus: ${res['message']}"),
                    ),
                  );
                }
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
