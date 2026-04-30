import 'package:flutter/material.dart';
import '../../../data/models/costume_model.dart';
import '../../../data/services/mock_data.dart';
import '../widgets/costume_card.dart';
import '../../auth/widgets/auth_background.dart';

class SearchPage extends StatefulWidget {
  // 1. Tambahkan parameter ini agar bisa menerima kiriman teks dari Home
  final String? initialQuery; 

  const SearchPage({super.key, this.initialQuery});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  List<Costume> _filteredCostumes = allCostumes;

  @override
  void initState() {
    super.initState();
    // 2. Inisialisasi controller dengan teks kiriman (jika ada)
    _searchController = TextEditingController(text: widget.initialQuery ?? "");
    
    // 3. Jika ada kiriman teks dari Home, langsung jalankan filter di awal
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _runFilter(widget.initialQuery!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      _filteredCostumes = allCostumes
          .where((costume) =>
              costume.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.9),
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Cari Kostum',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 17),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _runFilter,
                  decoration: const InputDecoration(
                    hintText: 'Tokoh dan Wayang',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),

            // Grid Kostum
            Expanded(
              child: _filteredCostumes.isEmpty
                  ? _buildNoResult()
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredCostumes.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        final item = _filteredCostumes[index];
                        return CostumeCard(
                          costume: item,
                          onTap: () {
                            // Detail produk
                          },
                          onWishlistToggle: () {
                            setState(() {
                              item.isWishlisted = !item.isWishlisted;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(item.isWishlisted 
                                  ? '${item.name} ditambah ke Wishlist' 
                                  : '${item.name} dihapus dari Wishlist'),
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          onAddToCart: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item.name} masuk keranjang'),
                                behavior: SnackBarBehavior.floating,
                                action: SnackBarAction(
                                  label: 'CEK',
                                  onPressed: () {
                                    // Navigator ke keranjang_page
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('Kostum tidak ditemukan', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}