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

                  // Filter ukuran
                  var filteredList = _selectedFilter == "Semua"
                      ? snapshot.data!
                      : snapshot.data!
                            .where((item) => item.ukuran == _selectedFilter)
                            .toList();

                  // Filter pencarian
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
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
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
        ).then((_) => _refreshData()),
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
        padding: const EdgeInsets.all(14.0), // Sedikit diperbesar paddingnya
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Agar sejajar di atas
          children: [
            _buildIconPlaceholder(item.gambar),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.namaKostum,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: AppColors.primaryNavy,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _buildStockBadge(item.stok),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _buildPriceAndActions(item, hargaFormatted),
          ],
        ),
      ),
    );
  }

  Widget _buildIconPlaceholder(String? fotoFileName) {
    // UKURAN GAMBAR DIPERBESAR MENJADI 85x85
    if (fotoFileName != null && fotoFileName.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            "${StockService.imageBaseUrl}$fotoFileName",
            width: 85,
            height: 85,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _defaultPlaceholder(),
          ),
        ),
      );
    }
    return _defaultPlaceholder();
  }

  Widget _defaultPlaceholder() {
    return Container(
      width: 85, // UKURAN DEFAULT PLACEHOLDER DIPERBESAR
      height: 85,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Icon(
        Icons.inventory_2_outlined,
        color: AppColors.primaryNavy,
        size: 40, // Ikon diperbesar agar seimbang
      ),
    );
  }

  Widget _buildStockBadge(int stok) {
    return Row(
      children: [
        Text(
          "Stok: $stok",
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: stok > 0 ? Colors.green.shade50 : Colors.red.shade50,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            stok > 0 ? "Tersedia" : "Habis",
            style: TextStyle(
              color: stok > 0 ? Colors.green : Colors.red,
              fontSize: 11,
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Rp $hargaFormatted",
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            color: AppColors.primaryNavy,
          ),
        ),
        Text(
          item.ukuran,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: AppColors.primaryGold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditStockPage(stock: item),
                ),
              ).then((_) => _refreshData()),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit, size: 20, color: Colors.blue),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () => _confirmDelete(item.idKostum!),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.delete, size: 20, color: Colors.red),
              ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
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
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
