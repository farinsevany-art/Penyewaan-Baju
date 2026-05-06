import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:apkpenyewaanbaju/data/models/stock_model.dart';
import 'package:apkpenyewaanbaju/data/services/stock_service.dart';
import 'package:apkpenyewaanbaju/core/constants/colors.dart';

class AddStockPage extends StatefulWidget {
  final int categoryId;
  const AddStockPage({super.key, required this.categoryId});

  @override
  State<AddStockPage> createState() => _AddStockPageState();
}

class _AddStockPageState extends State<AddStockPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  final TextEditingController _stokSController = TextEditingController();
  final TextEditingController _stokMController = TextEditingController();
  final TextEditingController _stokLController = TextEditingController();
  final TextEditingController _stokXLController = TextEditingController();

  final List<Map<String, dynamic>> _kategoriList = [
    {'id': 1, 'name': 'Tari Tradisional'},
    {'id': 2, 'name': 'Wayang'},
    {'id': 3, 'name': 'Modern/Karnaval'},
    {'id': 4, 'name': 'Pakaian Adat'},
  ];

  late int _selectedKategoriId;

  @override
  void initState() {
    super.initState();
    _selectedKategoriId = widget.categoryId;
    if (!_kategoriList.any((cat) => cat['id'] == _selectedKategoriId)) {
      _selectedKategoriId = 1;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _deskripsiController.dispose();
    _stokSController.dispose();
    _stokMController.dispose();
    _stokLController.dispose();
    _stokXLController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      Map<String, TextEditingController> stokControllers = {
        'S': _stokSController,
        'M': _stokMController,
        'L': _stokLController,
        'XL': _stokXLController,
      };

      bool isSuccess = true;
      String errorMessage = "";

      for (var entry in stokControllers.entries) {
        String ukuran = entry.key;
        int stok = int.tryParse(entry.value.text) ?? 0;

        if (stok > 0) {
          // Hanya simpan yang stoknya diisi lebih dari 0
          final stockData = StockModel(
            namaKostum: _namaController.text,
            idKategori: _selectedKategoriId,
            stok: stok,
            hargaSewa:
                int.tryParse(_hargaController.text.replaceAll('.', '')) ?? 0,
            ukuran: ukuran,
            deskripsi: _deskripsiController.text,
          );

          final res = await StockService.saveStock(stockData, false);

          if (!res['success']) {
            isSuccess = false;
            errorMessage = res['message'];
          }
        }
      }

      if (isSuccess) {
        if (mounted) Navigator.pop(context);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Gagal: $errorMessage")));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.primaryGold,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: AppColors.primaryNavy,
                size: 20,
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Tambah Item",
          style: TextStyle(
            color: AppColors.primaryGold,
            fontWeight: FontWeight.bold,
            fontFamily: 'PlayfairDisplay',
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _handleSave,
            child: const Text(
              "simpan",
              style: TextStyle(
                color: AppColors.primaryGold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
            ),
          ),
          Positioned.fill(
            child: Container(color: const Color(0xFFFAF6F0).withOpacity(0.85)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageUpload(),
                    const SizedBox(height: 25),
                    _buildLabel("Nama"),
                    _buildTextField(
                      controller: _namaController,
                      hint: "Contoh: Kebaya Clara 1",
                    ),
                    const SizedBox(height: 15),
                    _buildLabel("Kategori"),
                    _buildCategoryDropdown(),
                    const SizedBox(height: 15),
                    _buildSizeStockRow("S", _stokSController),
                    const SizedBox(height: 10),
                    _buildSizeStockRow("M", _stokMController),
                    const SizedBox(height: 10),
                    _buildSizeStockRow("L", _stokLController),
                    const SizedBox(height: 10),
                    _buildSizeStockRow("XL", _stokXLController),
                    const SizedBox(height: 15),
                    _buildLabel("Harga Sewa"),
                    _buildPriceField(),
                    const SizedBox(height: 15),
                    _buildLabel("Deskripsi"),
                    _buildTextField(
                      controller: _deskripsiController,
                      hint: "",
                      maxLines: 4,
                    ),
                    const SizedBox(height: 30),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER ---
  Widget _buildImageUpload() {
    return Center(
      child: CustomPaint(
        painter: DashedRectPainter(color: AppColors.primaryGold),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            children: [
              const Icon(
                Icons.cloud_upload_outlined,
                size: 40,
                color: AppColors.primaryNavy,
              ),
              const SizedBox(height: 10),
              const Text(
                "Upload Gambar Kostum",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "JPG, PNG sampai\n5MB",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Pilih Berkas",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'PlayfairDisplay',
          fontWeight: FontWeight.bold,
          color: AppColors.primaryNavy,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: _inputDecoration(hint: hint),
      validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: _hargaController,
      keyboardType: TextInputType.number,
      decoration: _inputDecoration().copyWith(
        prefixText: "Rp  ",
        prefixStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<int>(
      value: _selectedKategoriId,
      decoration: _inputDecoration(),
      items: _kategoriList.map((cat) {
        return DropdownMenuItem<int>(
          value: cat['id'],
          child: Text(cat['name']),
        );
      }).toList(),
      onChanged: (val) {
        setState(() => _selectedKategoriId = val!);
      },
    );
  }

  Widget _buildSizeStockRow(String size, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Ukuran"),
              TextFormField(
                initialValue: size,
                readOnly: true,
                textAlign: TextAlign.center,
                decoration: _inputDecoration(),
              ),
            ],
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Jumlah Stok"),
              TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNavy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: _handleSave,
        icon: const Icon(Icons.save, color: Colors.white, size: 20),
        label: const Text(
          "Simpan",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: AppColors.primaryGold.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryGold, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  DashedRectPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 8, dashSpace = 6, startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(15),
    );
    Path path = Path()..addRRect(rrect);
    Path dashPath = Path();

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (startX < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(startX, startX + dashWidth),
          Offset.zero,
        );
        startX += dashWidth + dashSpace;
      }
      startX = 0;
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
