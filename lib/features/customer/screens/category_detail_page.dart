import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/costume_model.dart';
import '../../../data/services/mock_data.dart';
import '../widgets/costume_card.dart';
import 'product_detail_page.dart';

class CategoryDetailPage extends StatefulWidget {
  final String categoryTitle;

  const CategoryDetailPage({super.key, required this.categoryTitle});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  late String _currentSelected;

  @override
  void initState() {
    super.initState();
    _currentSelected = widget.categoryTitle;
  }

  @override
  Widget build(BuildContext context) {
    // 1. Filter yang lebih aman dan robust (mengatasi null dan spasi)
    final filteredCostumes = allCostumes.where((item) {
      final itemCategory = (item.category ?? '').trim().toLowerCase();
      final selectedCategory = _currentSelected.trim().toLowerCase();

      return itemCategory == selectedCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: SizedBox(
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'cari kostum',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      body: Column(
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
                        costume:
                            item, // atau nama variabel kostum Anda di file ini (misal: kostum, data, dll)
                        onWishlistToggle: () {
                          setState(() {
                            item.isWishlisted = !item.isWishlisted;
                          });
                        },
                        // Jika masih ada baris onAddToCart di sini, biarkan saja atau hapus juga tidak apa-apa
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final categories = [
      'Tari Dewasa',
      'Tari Anak',
      'Raja & Ratu',
      'Pewayangan',
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
              selectedColor: Colors.black87,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
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
