import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constants/colors.dart';
import '../../../data/services/dashboard_service.dart';
import '../../auth/widgets/auth_background.dart';
import '../widgets/income_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  Map<String, dynamic>? _stats;
  bool _isLoading = true;
  String _selectedFilter = 'Bulanan'; // Default awal

  @override
  void initState() {
    super.initState();
    _fetchReportData();
  }

  Future<void> _fetchReportData() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse(
          '${DashboardService.baseUrl}/get_report_data.php?filter=$_selectedFilter',
        ),
      );
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _stats = json.decode(response.body);
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- FUNGSI MENCETAK LAPORAN PDF (SANGAT DETAIL & PROFESIONAL) ---
  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    int incomeTotal =
        double.tryParse(_stats?['income_total']?.toString() ?? '0')?.toInt() ??
        0;
    int totalOrders =
        int.tryParse(_stats?['total_orders']?.toString() ?? '0') ?? 0;
    int activeOrders =
        int.tryParse(_stats?['active_orders']?.toString() ?? '0') ?? 0;

    // Siapkan Data Tabel Pendapatan
    final chartData = (_stats?['chart_data'] as List?) ?? [];
    final tableIncomeData = [
      ['Waktu / Periode', 'Total Pendapatan'],
      ...chartData.map(
        (e) => [
          e['day'].toString(),
          formatRupiah(double.parse(e['total'].toString()).toInt()),
        ],
      ),
    ];

    // Siapkan Data Tabel Kostum
    final topCostumes = (_stats?['top_costumes'] as List?) ?? [];
    final tableCostumeData = [
      ['Nama Kostum', 'Kategori', 'Jumlah Disewa'],
      ...topCostumes.map(
        (e) => [
          e['nama_kostum'].toString(),
          e['kategori'].toString(),
          "${e['total_disewa']} Kali",
        ],
      ),
    ];

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // HEADER LAPORAN
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "KUSUMA CANTIKA",
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue900,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      "Laporan Kinerja Penyewaan Kostum",
                      style: const pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.Text(
                      "Rentang Waktu: ${_selectedFilter.toUpperCase()}",
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.orange700,
                      ),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      "Tanggal Cetak:",
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey,
                      ),
                    ),
                    pw.Text(
                      DateTime.now().toString().split('.')[0],
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Divider(color: PdfColors.grey400, thickness: 1.5),
            pw.SizedBox(height: 20),

            // KOTAK RINGKASAN (SUMMARY BOXES)
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _buildPdfSummaryBox(
                  "Total Pendapatan",
                  formatRupiah(incomeTotal),
                  PdfColors.green50,
                ),
                _buildPdfSummaryBox(
                  "Total Transaksi",
                  "$totalOrders Pesanan",
                  PdfColors.blue50,
                ),
                _buildPdfSummaryBox(
                  "Pesanan Aktif",
                  "$activeOrders Kostum",
                  PdfColors.orange50,
                ),
              ],
            ),
            pw.SizedBox(height: 30),

            // TABEL RINCIAN PENDAPATAN
            pw.Text(
              "1. Rincian Pendapatan ($_selectedFilter)",
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900,
              ),
            ),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              context: context,
              data: tableIncomeData,
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.blue900,
              ),
              rowDecoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
                ),
              ),
              cellAlignment: pw.Alignment.centerLeft,
              cellPadding: const pw.EdgeInsets.all(8),
            ),
            pw.SizedBox(height: 30),

            // TABEL KOSTUM TERLARIS
            pw.Text(
              "2. Kostum Paling Sering Disewa",
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900,
              ),
            ),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              context: context,
              data: tableCostumeData,
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.orange700,
              ),
              rowDecoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
                ),
              ),
              cellAlignment: pw.Alignment.centerLeft,
              cellPadding: const pw.EdgeInsets.all(8),
            ),
          ];
        },
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 20),
            child: pw.Text(
              'Halaman ${context.pageNumber} dari ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Laporan_${_selectedFilter}_KusumaCantika.pdf',
    );
  }

  pw.Widget _buildPdfSummaryBox(String title, String value, PdfColor bgColor) {
    return pw.Container(
      width: 150,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: bgColor,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String formatRupiah(int number) {
    return "Rp ${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
    int incomeTotal =
        double.tryParse(_stats?['income_total']?.toString() ?? '0')?.toInt() ??
        0;
    int totalOrders =
        int.tryParse(_stats?['total_orders']?.toString() ?? '0') ?? 0;
    int activeOrders =
        int.tryParse(_stats?['active_orders']?.toString() ?? '0') ?? 0;

    return Column(
      children: [
        // HEADER ATAS
        Container(
          padding: const EdgeInsets.only(
            top: 50,
            left: 20,
            right: 15,
            bottom: 25,
          ),
          color: AppColors.primaryNavy,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Laporan & Statistik',
                style: TextStyle(
                  color: AppColors.primaryGold,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _generatePdf,
                icon: const Icon(
                  Icons.print,
                  size: 18,
                  color: AppColors.primaryNavy,
                ),
                label: const Text(
                  "Cetak PDF",
                  style: TextStyle(
                    color: AppColors.primaryNavy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
        ),

        // 🔻 PERBAIKAN: Mengganti AuthBackground dengan Stack biasa (Tanpa SafeArea) 🔻
        Expanded(
          child: Stack(
            children: [
              // 1. Gambar Background Motif
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // 2. Konten Halaman
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // DESAIN FILTER RENTANG WAKTU
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    color: Colors.white.withOpacity(0.9),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ['Harian', 'Bulanan', 'Tahunan'].map((
                          filter,
                        ) {
                          bool isSelected = _selectedFilter == filter;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                                _fetchReportData(); // Muat ulang data
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 23,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryNavy
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: AppColors.primaryNavy,
                                  width: 1.5,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primaryNavy
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.primaryNavy,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // KONTEN UTAMA RINGKASAN
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryNavy,
                            ),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ringkasan $_selectedFilter",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: AppColors.primaryNavy,
                                  ),
                                ),
                                const SizedBox(height: 15),

                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSummaryCard(
                                        "Pendapatan",
                                        formatRupiah(incomeTotal),
                                        Icons.account_balance_wallet,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: _buildSummaryCard(
                                        "Transaksi",
                                        "$totalOrders Pesanan",
                                        Icons.shopping_bag,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                _buildSummaryCard(
                                  "Pesanan Aktif / Disewa",
                                  "$activeOrders Kostum",
                                  Icons.local_shipping,
                                ),

                                const SizedBox(height: 30),
                                Text(
                                  "Grafik Pendapatan $_selectedFilter",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: AppColors.primaryNavy,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                IncomeChart(
                                  chartData: _stats?['chart_data'] ?? [],
                                ),

                                const SizedBox(height: 30),
                                const Text(
                                  "Kostum Sering Disewa",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: AppColors.primaryNavy,
                                  ),
                                ),
                                const SizedBox(height: 15),

                                if (_stats?['top_costumes'] != null &&
                                    (_stats!['top_costumes'] as List)
                                        .isNotEmpty)
                                  ...(_stats!['top_costumes'] as List)
                                      .map(
                                        (item) => _buildPopularItem(
                                          item['nama_kostum']?.toString() ?? '',
                                          item['kategori']?.toString() ?? '',
                                          "${item['total_disewa']} disewa",
                                          item['foto_kostum']?.toString() ?? '',
                                        ),
                                      )
                                      .toList()
                                else
                                  const Center(
                                    child: Text(
                                      "Belum ada data",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primaryGold.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryGold, size: 28),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.primaryNavy,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularItem(String name, String cat, String count, String foto) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: foto.isNotEmpty
                ? Image.network(
                    "${DashboardService.baseUrl}/uploads/$foto",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  )
                : Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
                Text(
                  cat,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            count,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
