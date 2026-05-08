import 'package:flutter/material.dart';
import '../../../../../data/models/costume_model.dart';

class RentOptionsBottomSheet extends StatefulWidget {
  final Costume costume;
  final int initialQuantity;
  final Function(int selectedQuantity) onConfirm;

  const RentOptionsBottomSheet({
    super.key,
    required this.costume,
    required this.initialQuantity,
    required this.onConfirm,
  });

  @override
  State<RentOptionsBottomSheet> createState() => _RentOptionsBottomSheetState();
}

class _RentOptionsBottomSheetState extends State<RentOptionsBottomSheet> {
  late int _sheetQuantity;
  DateTime _startDate = DateTime.now();
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _sheetQuantity = widget.initialQuantity;
    // Otomatis set tanggal selesai 3 hari (hari ini + 2 hari)
    _endDate = _startDate.add(const Duration(days: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF6F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50, height: 5,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Atur Sewa", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),

          // SEKSI KALENDER
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.date_range, color: Color(0xFF0D1B3E)),
                    SizedBox(width: 8),
                    Text("Pilih Tanggal Mulai (Durasi 3 Hari)", style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                CalendarDatePicker(
                  initialDate: _startDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  onDateChanged: (date) {
                    setState(() {
                      _startDate = date;
                      _endDate = date.add(const Duration(days: 2));
                    });
                  },
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info_outline, size: 16, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        "Kembali pada: ${_endDate.day}-${_endDate.month}-${_endDate.year}",
                        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // JUMLAH SEWA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Jumlah Kostum", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Row(
                children: [
                  _buildQtyBtn(Icons.remove, () {
                    if (_sheetQuantity > 1) setState(() => _sheetQuantity--);
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text('$_sheetQuantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  _buildQtyBtn(Icons.add, () {
                    if (_sheetQuantity < (widget.costume.stock ?? 0)) {
                      setState(() => _sheetQuantity++);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Stok mencapai batas maksimum")),
                      );
                    }
                  }),
                ],
              ),
            ],
          ),

          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D1B3E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                widget.onConfirm(_sheetQuantity);
                Navigator.pop(context);
              },
              child: const Text("Konfirmasi Sewa", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}