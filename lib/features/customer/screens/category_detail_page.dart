import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/costume_model.dart';
import '../../../data/services/mock_data.dart';
import '../widgets/costume_card.dart';
import 'product_detail_page.dart';
import '../../auth/widgets/auth_background.dart';

class CategoryDetailPage extends StatefulWidget {
  final String categoryTitle;

  const CategoryDetailPage({super.key, required this.categoryTitle});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  late String _currentSelected;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _currentSelected = widget.categoryTitle;
  }

  @override
  Widget build(BuildContext context) {
    final filteredCostumes = allCostumes.where((item) {
      bool matchCategory = false;
      final itemCategory = (item.category ?? '').trim().toLowerCase();
      final selectedCategory = _currentSelected.trim().toLowerCase();

      if (selectedCategory == 'semua') {
        matchCategory = true;
      } else {
        matchCategory =
            itemCategory == selectedCategory ||
            itemCategory.contains(selectedCategory) ||
            selectedCategory.contains(itemCategory);
      }

      bool matchSearch = true;
      if (_searchQuery.isNotEmpty) {
        final itemName = (item.name ?? '').toLowerCase();
        matchSearch = itemName.contains(_searchQuery.toLowerCase());
      }

      return matchCategory && matchSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,

      // 🔻 PERBAIKAN: Background diubah menjadi Putih 🔻
      appBar: AppBar(
        backgroundColor: Colors.white, // Menghilangkan blok hitam
        elevation: 0, // Tidak ada bayangan agar menyatu rapi
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF0D1B3E),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: SizedBox(
          height: 40,
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Cari nama kostum...',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
              filled: true,
              fillColor: const Color(
                0xFFF5F5F5,
              ), // Warna isian abu-abu muda lembut
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),

      body: AuthBackground(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildFilterTabs(),
            const SizedBox(height: 15),
            Expanded(
              child: filteredCostumes.isEmpty
                  ? _buildEmpty(context)
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.62,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                          ),
                      itemCount: filteredCostumes.length,
                      itemBuilder: (context, index) {
                        final item = filteredCostumes[index];
                        return CostumeCard(
                          costume: item,
                          onWishlistToggle: () {
                            setState(() {
                              item.isWishlisted = !item.isWishlisted;
                            });
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

  Widget _buildFilterTabs() {
    final categories = [
      'Semua',
      'Tari Dewasa',
      'Tari Anak',
      'Raja & Ratu',
      'Wayang',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: categories.map((cat) {
          bool isSelected = cat == _currentSelected;
          return Container(
            margin: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (selected) {
                if (cat == _currentSelected) return;

                setState(() {
                  _currentSelected = cat;
                });
              },
              selectedColor: const Color(0xFF0D1B3E),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF0D1B3E),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: BorderSide(
                color: isSelected ? Colors.transparent : Colors.grey[300]!,
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'Kostum Kosong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D1B3E),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Coba ubah kata kunci pencarian atau kategori.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D1B3E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text('Kembali'),
          ),
        ],
      ),
    );
  }
}
