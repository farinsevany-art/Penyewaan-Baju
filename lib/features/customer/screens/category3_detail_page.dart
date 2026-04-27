import 'package:flutter/material.dart';
import 'category_detail_page.dart';
import 'category2_detail_page.dart';
import 'category4_detail_page.dart';

class Category3DetailPage extends StatefulWidget {
  final String categoryTitle;
  const Category3DetailPage({super.key, required this.categoryTitle});

  @override
  State<Category3DetailPage> createState() => _Category3DetailPageState();
}

class _Category3DetailPageState extends State<Category3DetailPage> {
  late String _currentSelected;

  @override
  void initState() {
    super.initState();
    _currentSelected = widget.categoryTitle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Koleksi Raja & Ratu', style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildFilterTabs(),
          const SizedBox(height: 15),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.62, crossAxisSpacing: 14, mainAxisSpacing: 14,
              ),
              itemCount: 4,
              itemBuilder: (context, index) => _buildProductCard(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final categories = ['Tari Dewasa', 'Tari Anak', 'Raja & Ratu', 'Wayang'];
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
                // LOGIKA NAVIGASI 3 ARAH
                Widget destination;
                if (cat == 'Tari Anak') {
                  destination = Category2DetailPage(categoryTitle: cat);
                } else if (cat == 'Raja & Ratu') {
                  setState(() => _currentSelected = cat); return;
                } else {
                  destination = CategoryDetailPage(categoryTitle: cat);
                }
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => destination));
              },
              selectedColor: Colors.black87,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context) {
    return Container(/* ... sama seperti sebelumnya ... */);
  }
}