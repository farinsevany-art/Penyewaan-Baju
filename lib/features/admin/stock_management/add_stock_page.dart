import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
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
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();

  XFile? _imageFile;

  final List<Map<String, dynamic>> _kategoriList = [
    {'id': 1, 'name': 'Tari Dewasa'},
    {'id': 2, 'name': 'Tari Anak'},
    {'id': 3, 'name': 'Raja & Ratu'},
    {'id': 4, 'name': 'Wayang'},
  ];

  late int _selectedKategoriId;
  String _selectedUkuran = 'M'; // Default ukuran

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
    _deskripsiController.dispose();
    _stokController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      int stok = int.tryParse(_stokController.text) ?? 0;
      int harga = int.tryParse(_hargaController.text.replaceAll('.', '')) ?? 0;

      // Validasi agar stok tidak 0
      if (stok <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Jumlah stok harus lebih dari 0!")),
        );
        return;
      }

      final stockData = StockModel(
        namaKostum: _namaController.text,
        idKategori: _selectedKategoriId,
        stok: stok,
        hargaSewa: harga,
        ukuran: _selectedUkuran,
        deskripsi: _deskripsiController.text,
      );

      final res = await StockService.saveStock(
        stockData,
        false,
        imageFile: _imageFile,
      );

      if (res['success'] == true) {
        if (mounted) Navigator.pop(context); // Kembali jika sukses
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Gagal: ${res['message'] ?? 'Error tidak diketahui'}",
              ),
            ),
          );
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

                    _buildLabel("Nama Kostum"),
                    _buildTextField(
                      controller: _namaController,
                      hint: "Contoh: Kebaya Clara 1",
                    ),
                    const SizedBox(height: 15),

                    _buildLabel("Kategori"),
                    _buildCategoryDropdown(),
                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Ukuran"),
                              _buildSizeDropdown(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Jumlah Stok"),
                              _buildTextField(
                                controller: _stokController,
                                hint: "0",
                                isNumber: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    _buildLabel("Harga Sewa"),
                    _buildPriceField(),
                    const SizedBox(height: 15),

                    _buildLabel("Deskripsi"),
                    _buildTextField(
                      controller: _deskripsiController,
                      hint: "Tuliskan deskripsi...",
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
      child: GestureDetector(
        onTap: _pickImage,
        child: CustomPaint(
          painter: DashedRectPainter(color: AppColors.primaryGold),
          child: Container(
            width: double.infinity,
            height: 200,
            alignment: Alignment.center,
            child: _imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: kIsWeb
                        ? Image.network(
                            _imageFile!.path,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          )
                        : Image.file(
                            File(_imageFile!.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Pilih Berkas",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
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
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: _inputDecoration(hint: hint),
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

  Widget _buildSizeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedUkuran,
      decoration: _inputDecoration(),
      items: ['S', 'M', 'L', 'XL'].map((size) {
        return DropdownMenuItem<String>(value: size, child: Text(size));
      }).toList(),
      onChanged: (val) {
        setState(() => _selectedUkuran = val!);
      },
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: _hargaController,
      keyboardType: TextInputType.number,
      decoration: _inputDecoration(hint: "Contoh: 75000").copyWith(
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
