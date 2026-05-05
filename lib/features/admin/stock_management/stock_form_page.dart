import 'package:flutter/material.dart';
import 'package:apkpenyewaanbaju/data/models/stock_model.dart';
import 'package:apkpenyewaanbaju/data/services/stock_service.dart';
import 'package:apkpenyewaanbaju/core/constants/colors.dart';

class StockFormPage extends StatefulWidget {
  final StockModel? stock;
  final int categoryId;

  const StockFormPage({super.key, this.stock, required this.categoryId});

  @override
  State<StockFormPage> createState() => _StockFormPageState();
}

class _StockFormPageState extends State<StockFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _stokController;
  late TextEditingController _hargaController;
  late TextEditingController _deskripsiController;
  String _selectedUkuran = 'M';

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(
      text: widget.stock?.namaKostum ?? '',
    );
    _stokController = TextEditingController(
      text: widget.stock?.stok.toString() ?? '',
    );
    _hargaController = TextEditingController(
      text: widget.stock?.hargaSewa.toString() ?? '',
    );
    _deskripsiController = TextEditingController(
      text: widget.stock?.deskripsi ?? '',
    );
    if (widget.stock != null) _selectedUkuran = widget.stock!.ukuran;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(widget.stock == null ? "Tambah Baju" : "Edit Baju"),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: AppColors.primaryGold,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField("Nama Kostum", _namaController, Icons.inventory_2),
              const SizedBox(height: 16),
              _buildField(
                "Harga Sewa",
                _hargaController,
                Icons.money,
                isNum: true,
              ),
              const SizedBox(height: 16),
              _buildField(
                "Jumlah Stok",
                _stokController,
                Icons.numbers,
                isNum: true,
              ),
              const SizedBox(height: 16),
              const Text(
                "Pilih Ukuran",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  'S',
                  'M',
                  'L',
                  'XL',
                ].map((u) => _buildSizeBtn(u)).toList(),
              ),
              const SizedBox(height: 16),
              _buildField(
                "Deskripsi",
                _deskripsiController,
                Icons.description,
                lines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNavy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _handleSave,
                  child: const Text(
                    "Simpan Perubahan",
                    style: TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isNum = false,
    int lines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: lines,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryNavy),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSizeBtn(String label) {
    bool isSelected = _selectedUkuran == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedUkuran = label),
      child: Container(
        width: 65,
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGold : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      final stockData = StockModel(
        idKostum: widget.stock?.idKostum,
        namaKostum: _namaController.text,
        idKategori: widget.categoryId,
        stok: int.parse(_stokController.text),
        hargaSewa: int.parse(_hargaController.text),
        ukuran: _selectedUkuran,
        deskripsi: _deskripsiController.text,
      );

      final res = await StockService.saveStock(stockData, widget.stock != null);
      if (res['success']) Navigator.pop(context);
    }
  }
}
