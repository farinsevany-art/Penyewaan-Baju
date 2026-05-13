import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../data/models/costume_model.dart';

class RentOptionsBottomSheet extends StatefulWidget {
  final Costume costume;
  final int initialQuantity;

  final Function(
    int selectedQuantity,
    DateTime startDate,
    DateTime endDate,
    int rentDays,
  )
  onConfirm;

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

  final Color primaryColor = const Color(
    0xFF0D1B3E,
  ); // Menggunakan Navy yang lebih pekat dan elegan
  final Color bgColor = const Color(0xFFFBFBFB);
  final Color accentGold = const Color(0xFFE4B04B);

  @override
  void initState() {
    super.initState();
    _sheetQuantity = widget.initialQuantity;
    // default 1 hari
    _endDate = _startDate.add(const Duration(days: 1));
  }

  // 🔻 TEMA KALENDER YANG LEBIH ELEGAN 🔻
  Theme _buildCalendarTheme(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: primaryColor, // Warna header kalender
          onPrimary: Colors.white, // Warna teks di header
          onSurface: Colors.black87, // Warna angka tanggal
        ),
        dialogBackgroundColor: Colors.white,

        // 🔻 PERBAIKAN: Ubah 'DialogTheme' menjadi 'DialogThemeData' 🔻
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 15,
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: accentGold, // Warna tombol Batal/Pilih
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
      child: child!,
    );
  }

  Future<void> _pickDateRange() async {
    // 1. Munculkan Kalender Pertama (Tanggal Mulai)
    DateTime? pickedStart = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: '1. PILIH TANGGAL MULAI SEWA',
      cancelText: 'BATAL',
      confirmText: 'LANJUT',
      initialEntryMode:
          DatePickerEntryMode.calendarOnly, // Cegah user mengetik manual
      builder: _buildCalendarTheme,
    );

    if (pickedStart != null) {
      if (!mounted) return;

      // Hitung batas maksimal pengembalian (H+3)
      DateTime maxEndDate = pickedStart.add(const Duration(days: 3));

      // Amankan initialDate untuk kalender kedua
      DateTime initialEnd =
          _endDate.isBefore(pickedStart) || _endDate.isAfter(maxEndDate)
          ? pickedStart.add(const Duration(days: 1))
          : _endDate;

      // 2. Munculkan Kalender Kedua (Tanggal Kembali) -> Sisanya otomatis Abu-abu!
      DateTime? pickedEnd = await showDatePicker(
        context: context,
        initialDate: initialEnd,
        firstDate: pickedStart,
        lastDate:
            maxEndDate, // 🔻 OTOMATIS MENGUNCI TANGGAL KE-4 DAN SETERUSNYA
        helpText: '2. PILIH TANGGAL KEMBALI (MAKS 3 HARI)',
        cancelText: 'KEMBALI',
        confirmText: 'SIMPAN',
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        builder: _buildCalendarTheme,
      );

      if (pickedEnd != null) {
        setState(() {
          _startDate = pickedStart;
          _endDate = pickedEnd;
        });
      }
    }
  }

  int get rentalDays {
    final days = _endDate.difference(_startDate).inDays;
    return days == 0 ? 1 : days;
  }

  int get totalPrice =>
      (widget.costume.price * rentalDays * _sheetQuantity).toInt();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 25),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(32),
        ), // Lebih melengkung
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HANDLE
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // TITLE
              const Text(
                "Atur Penyewaan",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0D1B3E),
                  fontFamily: 'Poppins',
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Tentukan tanggal (maksimal 3 hari) dan jumlah kostum yang ingin Anda sewa.",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              // KARTU TANGGAL YANG LEBIH PREMIUM
              const Text(
                "Tanggal Sewa",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF0D1B3E),
                ),
              ),
              const SizedBox(height: 12),

              GestureDetector(
                onTap: _pickDateRange,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.06),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(color: primaryColor.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.calendar_month_rounded,
                          color: primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${DateFormat('dd MMM yyyy').format(_startDate)} - ${DateFormat('dd MMM yyyy').format(_endDate)}",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: primaryColor,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "$rentalDays Hari Penyewaan",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.edit_calendar_rounded,
                        size: 22,
                        color: accentGold,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // JUMLAH
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Jumlah Kostum",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF0D1B3E),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        _qtyButton(Icons.remove, () {
                          if (_sheetQuantity > 1) {
                            setState(() => _sheetQuantity--);
                          }
                        }),
                        SizedBox(
                          width: 45,
                          child: Text(
                            "$_sheetQuantity",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        _qtyButton(Icons.add, () {
                          if (_sheetQuantity < widget.costume.stock) {
                            setState(() => _sheetQuantity++);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Stok maksimum tercapai"),
                              ),
                            );
                          }
                        }, isAdd: true),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // SUMMARY BILLING
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _summaryRow("Durasi Sewa", "$rentalDays Hari"),
                    const SizedBox(height: 12),
                    _summaryRow("Harga / Hari", widget.costume.formattedPrice),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Bayar",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Rp ${NumberFormat('#,###', 'id_ID').format(totalPrice).replaceAll(',', '.')}",
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // BUTTON CONFIRM
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 5,
                    shadowColor: primaryColor.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    int days = _endDate.difference(_startDate).inDays;
                    if (days < 1) days = 1;

                    widget.onConfirm(
                      _sheetQuantity,
                      _startDate,
                      _endDate,
                      days,
                    );
                    Navigator.pop(context);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Masukkan Keranjang",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap, {bool isAdd = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isAdd ? primaryColor : Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isAdd ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}
