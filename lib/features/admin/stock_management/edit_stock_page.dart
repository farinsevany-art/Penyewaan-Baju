import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb; // Tambahkan ini
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:apkpenyewaanbaju/data/models/stock_model.dart';
import 'package:apkpenyewaanbaju/data/services/stock_service.dart';
import 'package:apkpenyewaanbaju/core/constants/colors.dart';

class EditStockPage extends StatefulWidget {
  final StockModel stock;

  const EditStockPage({super.key, required this.stock});

  @override
  State<EditStockPage> createState() => _EditStockPageState();
}

class _EditStockPageState extends State<EditStockPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _hargaController;
  late TextEditingController _deskripsiController;
  late TextEditingController _stokController;

  XFile? _imageFile; // Menggunakan XFile agar kompatibel dengan Web

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
    _namaController = TextEditingController(text: widget.stock.namaKostum);
    _hargaController = TextEditingController(
      text: widget.stock.hargaSewa.toString(),
    );
    _deskripsiController = TextEditingController(text: widget.stock.deskripsi);
    _stokController = TextEditingController(text: widget.stock.stok.toString());

    _selectedKategoriId = widget.stock.idKategori;
    if (!_kategoriList.any((cat) => cat['id'] == _selectedKategoriId)) {
      _selectedKategoriId = 1;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _deskripsiController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  // Fungsi untuk memilih gambar dari galeri
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
      final stockData = StockModel(
        idKostum: widget.stock.idKostum,
        namaKostum: _namaController.text,
        idKategori: _selectedKategoriId,
        stok: int.tryParse(_stokController.text) ?? 0,
        hargaSewa: int.tryParse(_hargaController.text.replaceAll('.', '')) ?? 0,
        ukuran: widget.stock.ukuran,
        deskripsi: _deskripsiController.text,
        gambar: widget.stock.gambar,
      );

      final res = await StockService.saveStock(
        stockData,
        true,
        imageFile: _imageFile, // Kirim file gambar
      );

      if (res['success']) {
        if (mounted) Navigator.pop(context);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Gagal: ${res['message']}")));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 90,
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
          "Edit Item",
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

                    _buildSizeStockRow(widget.stock.ukuran, _stokController),

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
      child: GestureDetector(
        onTap: _pickImage,
        child: CustomPaint(
          painter: DashedRectPainter(color: AppColors.primaryGold),
          child: Container(
            width: double.infinity,
            height: 200,
            alignment: Alignment.center,
            // Menampilkan gambar (baru dipilih ATAU dari database ATAU placeholder kosong)
            child: _buildImagePreview(),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    // 1. Jika ada gambar baru yang dipilih dari Galeri
    if (_imageFile != null) {
      return ClipRRect(
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
      );
    }
    // 2. Jika tidak pilih gambar baru, tapi ada gambar lama di database
    if (widget.stock.gambar != null && widget.stock.gambar!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          "${StockService.imageBaseUrl}${widget.stock.gambar}",
          fit: BoxFit.cover,
          width: double.infinity,
          height: 200,
          errorBuilder: (context, error, stackTrace) =>
              _buildUploadPlaceholder(),
        ),
      );
    }
    // 3. Jika kosong
    return _buildUploadPlaceholder();
  }

  Widget _buildUploadPlaceholder() {
    return Column(
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            "Pilih Berkas",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
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
          "Simpan Perubahan",
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
