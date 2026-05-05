import 'package:flutter/material.dart';
import 'package:apkpenyewaanbaju/data/models/stock_model.dart';
import 'package:apkpenyewaanbaju/data/services/stock_service.dart';
import 'package:apkpenyewaanbaju/core/constants/colors.dart';
import 'package:apkpenyewaanbaju/features/auth/widgets/auth_background.dart';
import 'stock_form_page.dart';

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
  String _selectedFilter = "Semua"; // State untuk filter ukuran

  @override
  void initState() {
    super.initState();
    _refreshData();
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
        title: Text(
          "Stok: ${widget.categoryName}",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.primaryGold,
            fontFamily: 'PlayfairDisplay',
          ),
        ),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: AppColors.primaryGold,
        actions: [
          IconButton(onPressed: _refreshData, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: AuthBackground(
        child: Column(
          children: [
            // Filter Ukuran Interaktif
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ["Semua", "S", "M", "L", "XL"].map((size) {
                    return _buildFilterBtn(size);
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<StockModel>>(
                future: _stockFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Data tidak ditemukan"));
                  }

                  // Logika Penyaringan Client-Side
                  final filteredList = _selectedFilter == "Semua"
                      ? snapshot.data!
                      : snapshot.data!
                            .where((item) => item.ukuran == _selectedFilter)
                            .toList();

                  if (filteredList.isEmpty) {
                    return const Center(
                      child: Text("Tidak ada stok untuk ukuran ini"),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) =>
                        _buildStockCard(filteredList[index]),
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
            builder: (context) => StockFormPage(categoryId: widget.categoryId),
          ),
        ).then((_) => _refreshData()),
        child: const Icon(Icons.add, color: AppColors.primaryGold),
      ),
    );
  }

  Widget _buildFilterBtn(String label) {
    bool isActive = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryGold : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppColors.primaryGold : Colors.grey.shade300,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            if (isActive && label == "Semua") ...[
              const Icon(Icons.check, size: 16, color: Colors.white),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockCard(StockModel item) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Icon Placeholder (Sesuai Gambar)
            Container(
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
            ),
            const SizedBox(width: 16),
            // Detail Tengah
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
                  Row(
                    children: [
                      Text(
                        "Stok: ${item.stok}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "Tersedia",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Sisi Kanan: Harga, Ukuran, & Aksi
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Rp ${item.hargaSewa ~/ 1000}k",
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.blue,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StockFormPage(
                            stock: item,
                            categoryId: widget.categoryId,
                          ),
                        ),
                      ).then((_) => _refreshData()),
                    ),
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                      icon: const Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.red,
                      ),
                      onPressed: () => _confirmDelete(item.idKostum!),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(int id) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Stok?"),
        content: const Text("Data kostum ini akan dihapus permanen."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              final res = await StockService.deleteStock(id);
              if (res['success']) {
                Navigator.pop(context);
                _refreshData();
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
